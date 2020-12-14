import 'package:flutter/material.dart';
import 'package:imageChat/locator.dart';
import 'package:imageChat/logger.dart';
import 'package:imageChat/service/auth_service.dart';

import '_hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/user.dart';
import '../model/message.dart';

class DB extends ChangeNotifier {
  DB() {
    init();
  }
  
  bool _loaded = false;
  bool get loaded => _loaded;

  // MessageId as Key
  Map<String, Message> _messages = {};
  // int _currentMessage;
  // UserId as Key
  Map<String, User> _users = {};
  // UserId as Key
  Map<String, Message> _lastMessage = {};
  Map<String, Message> get lastMessage => _lastMessage;

  final log = getLogger('DB');
  
  init() async {
    log.i('Start');
    // await Hive.initFlutter();
    Hive.registerAdapter<Message>(MessageAdapter());
    Hive.registerAdapter<User>(UserAdapter());
    await Hive.openLazyBox<Message>(HiveBoxes.message);
    await Hive.openBox<User>(HiveBoxes.user);
    await Hive.openBox<List<String>>(HiveBoxes.userMessages);
    await _currentUserSettings();
    await _loadUsers();
    log.i('Done');
    _loaded = true;
    notifyListeners();
  }

  Future<void> _currentUserSettings() async {
    var userBox = Hive.box<User>(HiveBoxes.user);
    var currentUser = locator<AuthService>().user;
    await userBox.put(currentUser.id, currentUser);
    var selflist = Hive.box<List<String>>(HiveBoxes.userMessages).get(currentUser.id, defaultValue: []);
    log.i('SelfChat: $selflist');
    await Hive.box<List<String>>(HiveBoxes.userMessages).put(currentUser.id, selflist);
  }

  Future<User> getUser(String id) async {
    if(!_users.containsKey(id)) {
      // TODO: load from server and save
      _users[id] = await locator<AuthService>().getUser(id);
      await Hive.box<User>(HiveBoxes.user).put(id, _users[id]);
    }
    return _users[id];
  }

  Future<User> searchUser(String word) async {
    var u = await locator<AuthService>().searchUser(word);
    if(u != null) {
      _users[u.id] = u;
    }
    return u;
  }

  Future<void> addUser(User u) async {
    _lastMessage[u.id] = null;
    await Hive.box<List<String>>(HiveBoxes.userMessages).put(u.id, []);
    await Hive.box<User>(HiveBoxes.user).put(u.id, u);
  }

  List<String> getMessagesListByUser(String id) {
    var value = Hive.box<List<String>>(HiveBoxes.userMessages).get(id);
    // if(!_messages.containsKey(id)) {
    //   return [];
    // }
    return value?? [];
  }

  addMessage(Message message) async {
    log.i('[message id]: ${message.id}');
    var box = Hive.lazyBox<Message>(HiveBoxes.message);
    // var timekey = message.time.millisecondsSinceEpoch.toRadixString(16);
    // while(timekey.length < 16) {
    //   timekey = '0' + timekey;
    // }
    // await box.put(timekey + message.id, message);
    await box.put(message.id, message);
    _messages[message.id] = message;
    // box.add(message);
    String target = message.receiverId == locator<AuthService>().user.id? message.senderId : message.receiverId;
    // _messages[target].add(message);
    
    var mBox = Hive.box<List<String>>(HiveBoxes.userMessages);
    var messageList = mBox.get(target);
    messageList.add(message.id);
    mBox.put(target, messageList);
    _lastMessage.remove(target);
    _lastMessage[target] = message;
    log.i('After add message, $_lastMessage');
    notifyListeners();
  }

  _loadUsers() async {
    // load user
    var iterator = Hive.box<User>(HiveBoxes.user).values.iterator;
    while( iterator.moveNext() ) {
      _users[iterator.current.id] = iterator.current;
    }

    // load last message
    var box = Hive.lazyBox<Message>(HiveBoxes.message);
    var iterator2 = Hive.box<List<String>>(HiveBoxes.userMessages).keys.iterator;
    while( iterator2.moveNext() ) {
      var messageList = Hive.box<List<String>>(HiveBoxes.userMessages).get(iterator2.current);
      if(messageList.length > 0)
        _lastMessage[iterator2.current] = await box.get(messageList[messageList.length-1]);
      else 
        _lastMessage[iterator2.current] = null;
    }
    // Sort
    var tempLastMessage = _lastMessage;
    _lastMessage = {};
    var users = tempLastMessage.keys.toList();
    users.sort((a, b) {
      if(tempLastMessage[a] == null) {
        return 1;
      }
      if(tempLastMessage[b] == null) {
        return -1;
      }
      return tempLastMessage[a].time.millisecondsSinceEpoch - tempLastMessage[b].time.millisecondsSinceEpoch;
    });
    for (var user in users) {
      _lastMessage[user] = tempLastMessage[user];
    }
    tempLastMessage.clear();
    log.i(_lastMessage);
    notifyListeners();
  }

  Future<List<Message>> loadMessages(List<String> messagesIds) async {
    var box = Hive.lazyBox<Message>(HiveBoxes.message);
    var values = List<Message>();

    for(int i = 0; i < messagesIds.length; i++) {
      Message m;
      if(!_messages.containsKey(messagesIds[i])) {
        m = await box.get(messagesIds[i]);
        _messages[m.id] = m;
      } else {
        m = _messages[messagesIds[i]];
      }
      values.add(m);
    }

    return values;
  }

  // loadMessages() async {
  //   var box = Hive.lazyBox<Message>(HiveBoxes.message);
  //   var list = box.keys.toList();
  //   if(_currentMessage == null) _currentMessage = list.length;
  //   int start = _currentMessage - 64 > 0? _currentMessage - 64 : 0;
  //   for(var i = start; i < _currentMessage; i++) {
  //     var m = await box.get(list[i]);
  //     String target = m.receiverId == locator<AuthService>().user.id? m.senderId : m.receiverId;
  //     if(_messages.containsKey(target)) {
  //       _messages[target] = [];
  //     }
  //     _messages[target].insert(0, m);
  //   }
  //   _currentMessage = start;
  // }

  LazyBox<Message> getMessageBox() {
    return Hive.lazyBox<Message>(HiveBoxes.message);
  }

  Box<User> getUserBox() {
    return Hive.box<User>(HiveBoxes.user);
  }

  Box<List<String>> getUserMessagesBox() {
    return Hive.box<List<String>>(HiveBoxes.userMessages);
  }
}
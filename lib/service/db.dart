import 'package:imageChat/locator.dart';
import 'package:imageChat/service/auth_service.dart';

import '_hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/user.dart';
import '../model/message.dart';

class DB {
  DB() {
    init();
  }

  // UserId as Key
  Map<String, List<Message>> _messages = {};
  int _currentMessage;
  // UserId as Key
  Map<String, User> _users = {};
  
  init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<Message>(MessageAdapter());
    Hive.registerAdapter<User>(UserAdapter());
    await Hive.openLazyBox<Message>(HiveBoxes.message);
    await Hive.openBox<User>(HiveBoxes.user);
    _loadUsers();
  }

  Future<User> getUser(String id) async {
    if(!_users.containsKey(id)) {
      // TODO: load from server and save
    }
    return _users[id];
  }

  Future<List<Message>> getMessagesByUser(String id) async {
    if(!_messages.containsKey(id)) {
      return [];
    }
    return _messages[id];
  }

  addMessage(Message message) {
    var box = Hive.lazyBox<Message>(HiveBoxes.message);
    box.add(message);
  }

  _loadUsers() async {
    var iterator = Hive.box<User>(HiveBoxes.user).values.iterator;
    while( iterator.moveNext() ) {
      _users[iterator.current.id] = iterator.current;
    }
  }

  loadMessages() async {
    var box = Hive.lazyBox<Message>(HiveBoxes.message);
    var list = box.keys.toList();
    if(_currentMessage == null) _currentMessage = list.length;
    int start = _currentMessage - 64 > 0? _currentMessage - 64 : 0;
    for(var i = start; i < _currentMessage; i++) {
      var m = await box.get(list[i]);
      String target = m.receiverId == locator<AuthService>().user.id? m.senderId : m.receiverId;
      if(_messages.containsKey(target)) {
        _messages[target] = [];
      }
      _messages[target].insert(0, m);
    }
    _currentMessage = start;
  }

  LazyBox<Message> getMessageBox() {
    return Hive.lazyBox<Message>(HiveBoxes.message);
  }

  Box<User> getUserBox() {
    return Hive.box<User>(HiveBoxes.user);
  }
}
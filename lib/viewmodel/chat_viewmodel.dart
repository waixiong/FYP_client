import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imageChat/service/chat_service.dart';
import 'package:imageChat/service/db.dart';

import '../logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:dash_chat/dash_chat.dart';
import '../locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class ChatViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final ChatService _chatService = locator<ChatService>();
  final GlobalKey<DashChatState> chatViewKey = GlobalKey<DashChatState>();
  ChatUser targetUser;
  ChatUser self;
  ValueListenable<Box<List<String>>> _messageListener;
  final db = locator<DB>();

  List<String> _messagesList = [];  
  int _counter;

  ChatViewModel({this.self, this.targetUser}); 
  final log = getLogger('ChatViewModel');
  
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  // getMessagesByTarget() {
  //   try {
  //     log.i('getMessagesByTarget');
  //     setBusy(true);
  //     _messages = [
  //       ChatMessage(text: 'Hello', user: self, createdAt: DateTime(2020, 8, 12, 14, 26, 59, 999)),
  //       ChatMessage(text: 'Hai', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 30, 59, 999)),
  //       ChatMessage(text: 'Check this', user: self, createdAt: DateTime(2020, 8, 12, 14, 31, 22, 999), image: 'https://file.angelmortal.xyz/file/testBuc/test_testwebpicture'),
  //       ChatMessage(text: 'Wow great picture, where u get this?', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 31, 42, 999)),
  //       ChatMessage(text: 'I take this', user: self, createdAt: DateTime(2020, 8, 12, 14, 33, 02, 999)),
  //       ChatMessage(text: 'What camera specs?', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 33, 58, 999)),
  //       ChatMessage(text: 'Plz teach me how to produce this photo', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 34, 21, 999)),
  //       ChatMessage(text: 'Can no issue', user: self, createdAt: DateTime(2020, 8, 12, 14, 35, 02, 999)),
  //       ChatMessage(text: '', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 37, 21, 999), image: 'https://i.giphy.com/media/fWfowxJtHySJ0SGCgN/giphy.webp'),
  //     ];
  //     // _chatService.connect();
      
  //     setBusy(false);
  //   } catch(e) {
  //     log.e('init : $e');
  //     setBusy(false);
  //   }
  //   notifyListeners();
  // }

  init() async {
    setBusy(true);
    var userMessageBox = db.getUserMessagesBox();
    _messageListener = userMessageBox.listenable(keys: [targetUser.uid]);
    _messageListener.addListener(() async {
      _messagesList = db.getMessagesListByUser(targetUser.uid);
      _counter = _messagesList.length - 50;
      _counter = _counter < 0? 0 : _counter;
      var ms = await db.loadMessages(_messagesList.sublist(_counter));
      _messages = [];
      for(var element in ms) {
        _messages.add(await element.toChatMessage());
      }
      _goToBottom();
    });
    _messagesList = db.getMessagesListByUser(targetUser.uid);
    log.i(_messagesList);
    _counter = _messagesList.length - 50;
    _counter = _counter < 0? 0 : _counter;
    var ms = await db.loadMessages(_messagesList.sublist(_counter));
    _messages = [];
    for(var element in ms) {
      _messages.add(await element.toChatMessage());
    }
    _goToBottom();
    setBusy(false);
    notifyListeners();
  }

  // readMessage(Inbox inbox) async {
    
  // }

  loadEarlier() async {
    log.i('Load earlier...');
    var _oldCounter = _counter;
    _counter = _counter - 50;
    _counter = _counter < 0? 0 : _counter;
    var ms = await db.loadMessages(_messagesList.sublist(_counter, _oldCounter));
    List<ChatMessage> oldMessages = [];
    for(var element in ms) {
      oldMessages.add(await element.toChatMessage());
    }
    _messages = oldMessages + _messages;
  }

  _goToBottom() {
    if(chatViewKey.currentState!=null)
    chatViewKey.currentState.scrollController.animateTo(
      chatViewKey.currentState.scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  postMessage(ChatMessage message) async {
    try {
      // setBusy(true);
      setBusyForObject('send', true);
      print('\tsend messsage "${message.text}"');
      await _chatService.sendMessage(message, targetUser.uid);
      // _messages.add(message);
      // setBusy(false);
      setBusyForObject('send', false);
      _goToBottom();
    } catch(e) {
      log.e('err : $e');
      // setBusy(false);
      setBusyForObject('send', false);
    }
    // notifyListeners();
  }
}
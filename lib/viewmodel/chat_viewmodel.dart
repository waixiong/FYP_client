import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imageChat/service/chat_service.dart';
import 'package:imageChat/service/db.dart';
import 'package:imageChat/view/pages/secret_image_decode_page.dart';

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
      log.i('new message on ${targetUser.name}');
      _messagesList = db.getMessagesListByUser(targetUser.uid);
      print(_messagesList.length);
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
    _messages = [
      ChatMessage(
          text: '', 
          user: self,
          buttons: [
            OutlineButton(
              // color
              onPressed: () => locator<NavigationService>().navigateToView(SecretImageDecodeFullPage()),
              child: Text('Decode Image'),
            )
          ],
          image: 'https://res.cloudinary.com/dk-find-out/image/upload/q_80,c_limit,h_80,w_80,f_auto/Geometry2_hdxtr9.jpg'
        )
    ];
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
    List<ChatMessage> oldMessages = [
      ChatMessage(
        text: '', 
        user: self,
        buttons: [
          OutlineButton(
            onPressed: () => locator<NavigationService>().navigateToView(SecretImageDecodeFullPage()),
          )
        ],
        image: 'data:image/png;base64,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'
      )
    ];
    for(var element in ms) {
      oldMessages.add(await element.toChatMessage());
    }
    _messages = oldMessages + _messages;
  }

  _goToBottom() {
    if(chatViewKey.currentState!=null) {
      chatViewKey.currentState.setState(() {});
      chatViewKey.currentState.scrollController.animateTo(
        chatViewKey.currentState.scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
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
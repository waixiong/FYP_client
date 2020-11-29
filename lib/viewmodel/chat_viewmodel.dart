import '../logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:dash_chat/dash_chat.dart';
import '../locator.dart';

class ChatViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  ChatUser targetUser;
  ChatUser self;

  ChatViewModel({this.self, this.targetUser}); 
  final log = getLogger('ChatViewModel');
  
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  getMessagesByTarget() async {
    try {
      setBusy(true);
      _messages = [
        ChatMessage(text: 'Hello', user: self, createdAt: DateTime(2020, 8, 12, 14, 26, 59, 999)),
        ChatMessage(text: 'Hai', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 30, 59, 999)),
        ChatMessage(text: 'Check this', user: self, createdAt: DateTime(2020, 8, 12, 14, 31, 22, 999), image: 'https://file.angelmortal.xyz/file/testBuc/test_testwebpicture'),
        ChatMessage(text: 'Wow great picture, where u get this?', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 31, 42, 999)),
        ChatMessage(text: 'I take this', user: self, createdAt: DateTime(2020, 8, 12, 14, 33, 02, 999)),
        ChatMessage(text: 'What camera specs?', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 33, 58, 999)),
        ChatMessage(text: 'Plz teach me how to produce this photo', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 34, 21, 999)),
        ChatMessage(text: 'Can no issue', user: self, createdAt: DateTime(2020, 8, 12, 14, 35, 02, 999)),
        ChatMessage(text: '', user: targetUser, createdAt: DateTime(2020, 8, 12, 14, 37, 21, 999), image: 'https://i.giphy.com/media/fWfowxJtHySJ0SGCgN/giphy.webp'),
      ];
      setBusy(false);
    } catch(e) {
      log.e('init : $e');
      setBusy(false);
    }
    notifyListeners();
  }

  // readMessage(Inbox inbox) async {
    
  // }

  loadEarlier() async {
    log.i('Load earlier...');
  }

  postMessage(ChatMessage message) async {
    try {
      print('\tsend $message');
      setBusy(true);
      _messages.add(message);
      setBusy(false);
    } catch(e) {
      log.e('init : $e');
      setBusy(false);
    }
    notifyListeners();
  }
}
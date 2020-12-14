import 'package:imageChat/service/auth_service.dart';
import 'package:imageChat/service/chat_service.dart';
import 'package:imageChat/service/db.dart';
import 'package:imageChat/view/pages/chat_page.dart';

import '../logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:dash_chat/dash_chat.dart';
import '../locator.dart';

class ChatListViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final ChatService _chatService = locator<ChatService>();
  
  ChatUser self;

  ChatListViewModel(); 
  final log = getLogger('ChatListViewModel');
  
  Map<ChatUser, ChatMessage> messagesList = {};
  List<ChatUser> users = [];
  
  Future<void> init() async {
    setBusy(true);
    var db = locator<DB>();
    while(!db.loaded) {
      await Future.delayed(Duration(milliseconds: 250));
    }
    var u = await db.getUser(locator<AuthService>().user.id);
    self = u.toChatUser();
    await loadMessagesList();
    db.addListener(loadMessagesList);
    setBusy(false);
    notifyListeners();
  }

  loadMessagesList() async {
    log.i('Load Messages');
    messagesList.clear();
    users.clear();
    var db = locator<DB>();
    var iterator = db.lastMessage.keys.iterator;
    log.i(db.lastMessage);
    while(iterator.moveNext()) {
      var user = await db.getUser(iterator.current);
      var u = user.toChatUser();
      users.insert(0, u);
      // log.i(iterator.current);
      // log.i(db.lastMessage[iterator.current] == null);
      messagesList[u] = db.lastMessage[iterator.current] == null? null : await db.lastMessage[iterator.current].toChatMessage();
    }
    log.i(messagesList);
    notifyListeners();
  }

  navigateToChat(ChatUser target) {
    locator<NavigationService>().navigateToView(ChatPage(self: self, target: target,));
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage()));
  }

  @override
  void dispose() {
    locator<DB>().removeListener(loadMessagesList);
    super.dispose();
  }
}
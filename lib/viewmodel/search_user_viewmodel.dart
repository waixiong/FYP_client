import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imageChat/locator.dart';
import 'package:imageChat/model/user.dart';
import 'package:imageChat/service/auth_service.dart';
import 'package:imageChat/service/db.dart';
import 'package:imageChat/util/validator.dart';
import 'package:imageChat/view/pages/chat_page.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchUserViewmodel extends BaseViewModel {
  final authService = locator<AuthService>();
  User user;
  String errorString;

  Future<void> search(String email) async {
    errorString = Validator.emailValidator(email);
    if(errorString != null) {
      notifyListeners();
      return;
    }
    setBusy(true);
    try {
      user = await authService.searchUser(email);
    } catch(e) {
      user = null;
      locator<SnackbarService>().showSnackbar(message: 'User not found');
    }
    setBusy(false);
    notifyListeners();
  }

  navigateToChat(BuildContext context) async {
    setBusy(true);
    await locator<DB>().addUser(user);
    // locator<NavigationService>().replaceWithTransition(ChatPage(self: authService.user.toChatUser(), target: user.toChatUser(),));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatPage(self: authService.user.toChatUser(), target: user.toChatUser(),)));
  }
}
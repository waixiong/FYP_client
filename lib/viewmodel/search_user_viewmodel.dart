import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imageChat/locator.dart';
import 'package:imageChat/model/user.dart';
import 'package:imageChat/service/auth_service.dart';
import 'package:imageChat/service/db.dart';
import 'package:imageChat/service/mail_service.dart';
import 'package:imageChat/service/notification/messaging_token.dart';
import 'package:imageChat/util/validator.dart';
import 'package:imageChat/view/pages/chat_page.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchUserViewmodel extends BaseViewModel {
  final authService = locator<AuthService>();
  User user;
  String errorString;

  bool notFound = false;
  String email;

  String nameErrorString;

  Future<void> search(String email) async {
    errorString = Validator.emailValidator(email);
    if(errorString != null) {
      notifyListeners();
      return;
    }
    this.email = email;
    setBusy(true);
    try {
      user = await authService.searchUser(email);
    } catch(e) {
      user = null;
      locator<SnackbarService>().showSnackbar(message: 'User not found');
      notFound = true;
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> invite(String name) async {
    setBusy(true);
    print('invite 1');
    if(email.isEmpty) {
      return;
    }
    if(name.isEmpty) {
      nameErrorString = 'Fill in the name';
      locator<SnackbarService>().showSnackbar(message: 'Fill in the name');
      return;
    }
    errorString = Validator.emailValidator(email);
    if(errorString != null) {
      notifyListeners();
      return;
    }
    // print('invite 2');
    // setBusy(true);
    // try {
    //   await locator<MessagingTokenService>().sendInvitation(email, name);
    //   print('invite 3');
    // } catch(e) {
    //   print('invite 3 error');
    // }
    // setBusy(false);
    // print('invite 4');
    // notifyListeners();
    // locator<NavigationService>().popRepeated(1);
    // locator<SnackbarService>().showSnackbar(message: 'Invitation sent');
    try {
      await locator<MailService>().sendEmail(email, name);
    } catch(e) {
      print('invite error');
      print(e);
      locator<SnackbarService>().showSnackbar(message: 'Connection error, try again');
      return;
    }
    setBusy(false);
    locator<NavigationService>().popRepeated(1);
    locator<SnackbarService>().showSnackbar(message: 'Invitation sent');
  }

  navigateToChat(BuildContext context) async {
    setBusy(true);
    await locator<DB>().addUser(user);
    // locator<NavigationService>().replaceWithTransition(ChatPage(self: authService.user.toChatUser(), target: user.toChatUser(),));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatPage(self: authService.user.toChatUser(), target: user.toChatUser(),)));
  }
}
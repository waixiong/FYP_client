import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/src/user_repository_interface.dart';
import 'package:user_repository/src/platform/default.dart';
import 'package:user_repository/src/web_user_repository.dart';

Future<UserRepositoryI> getUserRepository() async {
  return WebUserRepository(await SharedPreferences.getInstance());
}

PlatformOn getPlatform() {
  return PlatformOn.Web;
}
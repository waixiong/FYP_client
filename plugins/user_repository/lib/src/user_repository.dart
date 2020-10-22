import 'dart:async';

import 'package:meta/meta.dart';
import 'package:user_repository/src/token.dart';
import 'package:user_repository/src/user_repository_interface.dart';

class UserRepository implements UserRepositoryI {
  @override
  Future<void> deleteToken() {
    // TODO: implement deleteToken
    return null;
  }

  @override
  Future<Token> getToken() {
    // TODO: implement getToken
    return null;
  }

  @override
  Future<void> persistToken(String accessToken, String refreshToken) {
    // TODO: implement persistToken
    return null;
  }
}
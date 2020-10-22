import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:user_repository/src/token.dart';
import 'package:user_repository/src/user_repository_interface.dart';

class MobileUserRepository implements UserRepositoryI {
  FlutterSecureStorage _storage;

  MobileUserRepository(this._storage);

  @override
  Future<void> deleteToken() async {
    // TODO: implement deleteToken
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    return null;
  }

  @override
  Future<Token> getToken() async {
    // TODO: implement getToken
    String accessToken = await _storage.read(key: 'access_token');
    String refreshToken = await _storage.read(key: 'refresh_token');
    if(accessToken == null|| refreshToken == null) {
      return null;
    }
    return Token()..accessToken = accessToken ..refreshToken = refreshToken;
  }

  @override
  Future<void> persistToken(String accessToken, String refreshToken) async {
    // TODO: implement persistToken
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    return null;
  }
  
}
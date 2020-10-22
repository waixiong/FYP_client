import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/src/token.dart';
import 'package:user_repository/src/user_repository_interface.dart';

class WebUserRepository implements UserRepositoryI {

  SharedPreferences _storage;

  WebUserRepository(this._storage);
  
  @override
  Future<void> deleteToken() async {
    _storage = await SharedPreferences.getInstance();
    await _storage.remove('access_token');
    await _storage.remove('refresh_token');
  }

  @override
  Future<Token> getToken() async {
    _storage = await SharedPreferences.getInstance();
    if(!_storage.containsKey('access_token') || !_storage.containsKey('refresh_token')) {
      return null;
    }
    String accessToken = _storage.getString('access_token');
    String refreshToken = _storage.getString('refresh_token');
    return Token()..accessToken = accessToken ..refreshToken = refreshToken;
  }

  @override
  Future<void> persistToken(String accessToken, String refreshToken) async {
    _storage = await SharedPreferences.getInstance();
    await _storage.setString('access_token', accessToken);
    await _storage.setString('refresh_token', refreshToken);
  }
}
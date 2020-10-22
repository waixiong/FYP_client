import 'package:user_repository/src/token.dart';

abstract class UserRepositoryI {

  Future<void> deleteToken();

  Future<void> persistToken(String accessToken, String refreshToken);

  Future<Token> getToken();
  
}
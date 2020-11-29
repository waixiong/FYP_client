import 'package:flutter/foundation.dart';
import '../util/validator.dart';
import 'package:logger/logger.dart';
import '_exception.dart';
import 'package:user_repository/user_repository.dart';
import 'package:imageChat/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../util/network_config.dart';
import '../logger.dart';
import '../locator.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Unauthenticated,
}

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Unauthenticated,
}

class AuthService extends ChangeNotifier {
  AuthStatus _status = AuthStatus.Uninitialized;
  AuthStatus get status => _status;

  Logger log = getLogger("AuthService");
  final String service;

  User user;
  bool firstTime = false;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ]
  );

  AuthService({this.service = 'http://localhost:8091'});

  // return boolean, whether is a first time user
  Future<bool> signInSilently() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signInSilently();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('Code: ${googleAuth.serverAuthCode}');
      print("Id: ${googleAuth.idToken}");
      print("Access: ${googleAuth.accessToken}");
      
      try {
        Map<String, dynamic> result = await locator<API>().post(service, '/api/invest/user/signin', {
          "idToken": googleAuth.idToken,
          "accessToken": googleAuth.accessToken
        });
        User u = User.fromJson(result["user"]);
        this.firstTime = result["exist"];
        this.user = u;
        _status = AuthStatus.Authenticated;
        locator<API>().setAuthorization(googleAuth.accessToken, '');
        notifyListeners();
        return result["exist"];
      } catch(e) {
        print('--- API ERR ---');
        log.e(e);
        _status = AuthStatus.Unauthenticated;
        notifyListeners();
        throw(checkServiceError(e));
      }
    } catch(e) {
      print('--- Silently GOOGLE sign in ERR ---');
      log.e(e);
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      throw(checkServiceError(e));
    }
  }

  Future<void> init() async {
    log.i('loadToken');
    await signInSilently();
  }

  // return boolean, whether is a first time user
  Future<bool> signIn() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('Code: ${googleAuth.serverAuthCode}');
      print("Id: ${googleAuth.idToken}");
      print("Access: ${googleAuth.accessToken}");
      try {
        Map<String, dynamic> result = await locator<API>().post(service, '/api/invest/user/signin', {
          "idToken": googleAuth.idToken,
          "accessToken": googleAuth.accessToken
        });
        this.firstTime = result["exist"];
        this.user = User.fromJson(result["user"]);
        _status = AuthStatus.Authenticated;
        locator<API>().setAuthorization(googleAuth.accessToken, '');
        notifyListeners();
        return result["exist"];
      } catch(e) {
        print('--- API ERR ---');
        _status = AuthStatus.Unauthenticated;
        notifyListeners();
        throw(checkServiceError(e));
      }
    } catch(e) {
      print('--- GOOGLE sign in ERR ---');
        _status = AuthStatus.Unauthenticated;
        notifyListeners();
      throw(e);
    }
  }

  Future<void> thirdPartySignIn() async {
    await signIn();
  }

  Future<void> refresh() async {
    await signInSilently();
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    _status = AuthStatus.Unauthenticated;
    locator<API>().setAuthorization(null, null);
    notifyListeners();
  }
}

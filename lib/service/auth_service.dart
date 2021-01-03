import 'package:flutter/foundation.dart';
import 'package:imageChat/service/chat_service.dart';
import 'package:imageChat/service/notification/push_notification.dart';
import '../util/validator.dart';
import 'package:logger/logger.dart';
import '_exception.dart';
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
        Map<String, dynamic> result = await locator<API>().post(service, '/api/user/signin', {
          "idToken": googleAuth.idToken,
          "accessToken": googleAuth.accessToken
        });
        User u = User.fromJson(result["user"]);
        this.firstTime = result["exist"];
        this.user = u;
        _status = AuthStatus.Authenticated;
        locator<API>().setAuthorization(googleAuth.accessToken, '');
        // locator<ChatService>().accessToken = googleAuth.accessToken;
        locator<PushNotificationsManager>().init();
        setupChatService(googleAuth.accessToken);
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
      // log.e(e);
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      throw(e);
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
        Map<String, dynamic> result = await locator<API>().post(service, '/api/user/signin', {
          "idToken": googleAuth.idToken,
          "accessToken": googleAuth.accessToken
        });
        this.firstTime = result["exist"];
        this.user = User.fromJson(result["user"]);
        _status = AuthStatus.Authenticated;
        locator<API>().setAuthorization(googleAuth.accessToken, '');
        // locator<ChatService>().accessToken = googleAuth.accessToken;
        locator<PushNotificationsManager>().init();
        setupChatService(googleAuth.accessToken);
        notifyListeners();
        return result["exist"];
      } catch(e) {
        print('--- API ERR ---');
        _status = AuthStatus.Unauthenticated;
        notifyListeners();
        log.e(e);
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
    log.i('Signing Out');
    await googleSignIn.signOut();
    _status = AuthStatus.Unauthenticated;
    locator<API>().setAuthorization(null, null);
    notifyListeners();
  }

  // return boolean, whether is a first time user
  Future<User> getUser(String id) async {
    try {
      try {
        Map<String, dynamic> result = await locator<API>().get(service, '/api/user/user/$id');
        var user = User.fromJson(result);
        return user;
      } catch(e) {
        print('--- API ERR ---');
        // _status = AuthStatus.Unauthenticated;
        notifyListeners();
        log.e(e);
        throw(checkServiceError(e));
      }
    } catch(e) {
      print('--- getUser Err ---');
      throw(e);
    }
  }

  Future<User> searchUser(String word) async {
    // use email
    try {
      try {
        Map<String, dynamic> result = await locator<API>().get(service, '/api/user/search/$word');
        var user = User.fromJson(result);
        return user;
      } catch(e) {
        print('--- API ERR ---');
        // _status = AuthStatus.Unauthenticated;
        notifyListeners();
        log.e(e);
        throw(checkServiceError(e));
      }
    } catch(e) {
      print('--- getUser Err ---');
      throw(e);
    }
  }
}

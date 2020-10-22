import 'package:flutter/foundation.dart';
import '../util/validator.dart';
import 'package:logger/logger.dart';
import 'package:user_repository/user_repository.dart';

import '../util/network_config.dart';
import '../logger.dart';
import '../locator.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Unauthenticated,
}

class AuthService extends ChangeNotifier {
  Status _status = Status.Uninitialized;
  Status get status => _status;

  String _accessToken;
  String _refreshToken;

  Logger log = getLogger("AuthService");
  final String service;
  // User user;

  AuthService({this.service = 'https://example.com'});

  Future<void> loadToken() async {
    await locator.allReady();
    await locator.isReady<UserRepositoryI>();
    log.i('get token from repository');
    final token = await locator<UserRepositoryI>().getToken();
    if(token != null) {
      log.i('\ttoken found');
      _accessToken = token.accessToken;
      _refreshToken = token.refreshToken;
      locator<API>().setAuthorization(_accessToken, _refreshToken);
      _status = Status.Authenticated;
      notifyListeners();
    } else {
      _status = Status.Unauthenticated;
      notifyListeners();
    }
  }

  Future<void> init() async {
    log.i('loadToken');
    await loadToken();
  }

  Future<void> signIn(String phone, String password) async {
    // mock
    // await Future.delayed(Duration(milliseconds: 500));
    // _status = Status.Authenticated;
    // notifyListeners();
    // return;
    try {
      Map result = await locator<API>().post(service, '/api/auth/signin', {
        'username': MobileValidator.mobileTransform(phone),
        'password': password,
        'temp': _tempToken
      });
      _accessToken = result['accessToken'];
      _refreshToken = result['refreshToken'];
      locator<API>().setAuthorization(_accessToken, _refreshToken);
      _status = Status.Authenticated;
      notifyListeners();
      await locator<UserRepositoryI>().persistToken(_accessToken, _refreshToken);
    } on ApiError catch(e) {
      throw e;
    } catch(e) {
      throw e;
    }
  }

  Future<void> thirdPartySignIn() async {
    // thirdpartysignin
    throw UnimplementedError('Third Party Sign In');
  }

  Future<void> refresh() async {
    try {
      Map result = await locator<API>().post(service, '/api/auth/refresh', {
        'accessToken': _accessToken,
        'refreshToken': _refreshToken
      });
      _accessToken = result['accessToken'];
      _refreshToken = result['refreshToken'];
      locator<API>().setAuthorization(_accessToken, _refreshToken);
      await locator<UserRepositoryI>().persistToken(_accessToken, _refreshToken);
    } on ApiError catch(e) {
      // Remove Token
      log.e('ApiError: $e');
      _status = Status.Unauthenticated;
      _accessToken = null;
      _refreshToken = null;
      locator<API>().setAuthorization(null, null);
      await locator<UserRepositoryI>().deleteToken();
      notifyListeners();
    } catch(e) {
      log.e('$e');
      throw e;
    }
  }

  Future<String> changePassword(String oldPassword, String newPassword) async {
    try {
      Map result = await locator<API>().post(service, '/api/auth/password/change', {
        'oldPassword': oldPassword,
        'newPassword': newPassword
      });
      return result['message'];
    } on ApiError catch(e) {
      // throw exception;
      return e.errorMessage;
    } catch(e) {
      return 'AuthService Error $e';
    }
  }

  // Future<void> forgotPassword({String email, String phone}) async {
  //   try {
  //     Map<String, String> body = {};
  //     if(email != null) body['email'] = email;
  //     else if(phone != null) body['phone'] = phone;
  //     // checking in model
  //     await locator<API>().post(service, '/api/auth/password/request', body);
  //   }  on ApiError catch(e) {
  //     throw checkServiceError(e);
  //   } catch(e) {
  //     throw e;
  //   }
  // }

  // Future<void> resetPassword(String auth, String otp, String newPassword) async {
  //   try {
  //     // currently email and phone have same implementation
  //     Map result = await locator<API>().post(service, '/api/auth/password/reset/email', {
  //       'authorisation': auth,
  //       'otp': otp,
  //       'newPassword': newPassword
  //     });
  //   }  on ApiError catch(e) {
  //     throw checkServiceError(e);
  //   } catch(e) {
  //     throw e;
  //   }
  // }

  Future<void> signOut() async {
    try {
      await locator<API>().post(service, '/api/auth/signout', {
        'accessToken': _accessToken,
        'refreshToken': _refreshToken
      });
      locator<API>().setAuthorization(null, null);
      await locator<UserRepositoryI>().deleteToken();
      _status = Status.Unauthenticated;
      notifyListeners();
    }  on ApiError catch(e) {
      await locator<UserRepositoryI>().deleteToken();
      _status = Status.Unauthenticated;
      notifyListeners();
      throw e;
    } catch(e) {
      throw e;
    }
  }

  Future<void> tokenFromSignUp(String accessToken, String refreshToken) async {
    try {
      locator<API>().setAuthorization(accessToken, refreshToken);
      _status = Status.Authenticated;
      notifyListeners();
      await locator<UserRepositoryI>().persistToken(_accessToken, _refreshToken);
    } catch(e) {
      //
    }
  }

  String _tempToken = '';
  String _birthVToken = '';

  Future<void> signUp(String name, String password, String phone, String email, DateTime birthday) async {
    try {
      Map result = await locator<API>().post(service, '/api/auth/signup', {
        "email": email,
        "phone": MobileValidator.mobileTransform(phone),
        "password": password,
        "name": name,
        "birthday": birthday.millisecondsSinceEpoch,
        "temp": _tempToken
      });
      _accessToken = result['accessToken'];
      _refreshToken = result['refreshToken'];
      locator<API>().setAuthorization(_accessToken, _refreshToken);
      _status = Status.Authenticated;
      notifyListeners();
      await locator<UserRepositoryI>().persistToken(_accessToken, _refreshToken);
    } on ApiError catch(e) {
      throw e;
    } catch(e) {
      throw e;
    }
  }

  Future<void> requestOTP(String target) async {
    try {
      log.d(MobileValidator.mobileTransform(target));
      await locator<API>().post(service, '/api/auth/otp/request', {
        "target": MobileValidator.mobileTransform(target),
      });
    } on ApiError catch(e) {
      throw e;
    } catch(e) {
      throw e;
    }
  }

  Future<bool> validateOTP(String target, String otp) async {
    try {
      log.i('validateOTP');
      Map result = await locator<API>().post(service, '/api/auth/otp/validate', {
        "target": MobileValidator.mobileTransform(target),
        "otp": otp
      });
      log.i('receive result: $result');
      _tempToken = result['temp'];
      return result['account'];
    } on ApiError catch(e) {
      log.e('validateOTP: $e');
      throw e;
    } catch(e) {
      throw e;
    }
  }

  /// currently use birthday
  Future<bool> resetPasswordValidation(String phone, DateTime birthday) async {
    try {
      Map result = await locator<API>().post(service, '/api/auth/password/request', {
        "target": MobileValidator.mobileTransform(phone),
        "birthday": birthday.millisecondsSinceEpoch
      });
      _birthVToken = result['birthVToken'];
      return result['result'];
    } on ApiError catch(e) {
      throw e;
    } catch(e) {
      throw e;
    }
  }

  Future<void> resetPassword(String phone, String newPassword) async {
    try {
      // currently email and phone have same implementation
      Map result = await locator<API>().post(service, '/api/auth/password/reset/email', {
        'authorisation': MobileValidator.mobileTransform(phone),
        'otp': _tempToken,
        'birthVToken': _birthVToken,
        'newPassword': newPassword
      });
    }  on ApiError catch(e) {
      throw e;
    } catch(e) {
      throw e;
    }
  }
}
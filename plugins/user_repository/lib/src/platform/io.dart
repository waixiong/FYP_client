import 'package:user_repository/src/mobile_user_repository.dart';
import 'package:user_repository/src/user_repository_interface.dart';
import 'dart:io';
import 'dart:async';
import 'package:user_repository/src/platform/default.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<UserRepositoryI> getUserRepository() async {
  return await Future<UserRepositoryI>.value(MobileUserRepository(FlutterSecureStorage()));
}

PlatformOn getPlatform() {
  switch(Platform.operatingSystem) {
    case 'android':
      return PlatformOn.Android;
    case 'ios':
      return PlatformOn.IOS;
    case 'linux':
      return PlatformOn.Linux;
    case 'windows':
      return PlatformOn.Windows;
    case 'macos':
      return PlatformOn.MacOS;
    case 'fuchsia':
      return PlatformOn.Fuchsia;
  }
  return PlatformOn.UNKNOWN;
}
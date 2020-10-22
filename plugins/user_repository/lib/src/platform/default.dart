import 'package:user_repository/src/user_repository_interface.dart';

enum PlatformOn {
  Linux,
  Windows,
  Android,
  IOS,
  MacOS,
  Fuchsia,
  Web,
  UNKNOWN
}

Future<UserRepositoryI> getUserRepository() async => throw UnsupportedError('Cannot get user repository without dart:html or dart:io.');

PlatformOn getPlatform() => throw UnsupportedError('Unknown either dart:html or dart:io.');
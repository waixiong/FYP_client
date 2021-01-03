import 'package:get_it/get_it.dart';
import 'package:imageChat/service/file_service.dart';
import 'package:stacked_services/stacked_services.dart';

import './service/db.dart';
import './service/auth_service.dart';
import './service/chat_service.dart';
import './service/notification/messaging_token.dart';
import './service/notification/push_notification.dart';
import './util/network_config.dart';
import 'logger.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// import 'core/services/database.dart';

GetIt locator = GetIt.instance;
final _log = getLogger('locator');

Directory tempDir;
Directory externalDir;

void setupLocator() {
  // for services or viewmodels that needs to be kept alive throughout the app
  getTemporaryDirectory().then((dir) => tempDir = dir);
  getExternalStorageDirectory().then((dir) => externalDir = dir);

  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => NavigationService());

  // locator.registerLazySingleton(() => DB());

  locator.registerLazySingleton(() => API());
  locator.registerLazySingleton(() => AuthService(service: 'https://imagechat.getitqec.com'));
  // locator.registerLazySingleton(() => ChatService(host: '192.168.1.114', port: 8100));
  // locator.unregister(instance: locator<ChatService>());
  // locator.registerLazySingleton(() => ChatService(host: 'imagechat.getitqec.com', port: 2053));

  locator.registerLazySingleton(() => MessagingTokenService(service: 'https://imagechat.getitqec.com'));
  locator.registerLazySingleton(() => PushNotificationsManager());
  locator.registerLazySingleton(() => FileService(service: 'https://imagechat.getitqec.com'));
}

void setupChatService(String accessToken) {
  try {
    locator.unregister(instance: locator<DB>());
  } catch(e) {
    _log.i('No type DB is registered inside GetIt.');
  }
  locator.registerLazySingleton(() => DB());
  
  try {
    locator.unregister(instance: locator<ChatService>());
  } catch(e) {
    _log.i('No type ChatService is registered inside GetIt.');
  }
  // ChatService s = ChatService(host: '192.168.1.114', port: 8100);
  ChatService s = ChatService(host: 'imagechat.getitqec.com', port: 2053);
  // locator.registerLazySingleton(() => ChatService(host: 'imagechat.getitqec.com', port: 2053)..connect());
  locator.registerLazySingleton(() => s);
  s.accessToken = accessToken;
  s.connect();
}
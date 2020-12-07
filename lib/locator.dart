import 'package:get_it/get_it.dart';
import 'package:imageChat/service/auth_service.dart';
import 'package:imageChat/service/chat_service.dart';
import 'package:stacked_services/stacked_services.dart';
import './util/network_config.dart';

// import 'core/services/database.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // for services or viewmodels that needs to be kept alive throughout the app

  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());

  locator.registerLazySingleton(() => API());
  locator.registerLazySingleton(() => AuthService(service: 'https://imagechat.getitqec.com'));
  locator.registerLazySingleton(() => ChatService(host: '192.168.1.114', port: 8100));
}

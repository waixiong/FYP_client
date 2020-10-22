import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

// import 'core/services/database.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // for services or viewmodels that needs to be kept alive throughout the app

  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
}

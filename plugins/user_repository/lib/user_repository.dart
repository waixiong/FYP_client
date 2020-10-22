library user_repository;

export './src/user_repository_interface.dart';
export './src/platform/default.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) './src/platform/html.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) './src/platform/io.dart';
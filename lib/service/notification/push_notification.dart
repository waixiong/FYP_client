import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:imageChat/service/notification/messaging_token.dart';
import '../../locator.dart';
import '../../logger.dart';

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    print("onBackgroundMessage (d): $data");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("onBackgroundMessage (n): $notification");
  }

  // Or do other work.
}

class PushNotificationsManager {
  final log = getLogger("PushNotificationsManager");

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    log.i('init');
    if (!_initialized) {
      log.i('start INIT');
      // For iOS request permission first.
      // _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        log.i("Settings registered: $settings");
      });
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          log.i("onMessage: $message");
          final dynamic data = message['data'];
          // check type
          if(data != null) {
            if(data['type'] == 'NewJob') {
              // locator<DeliveryService>().receiveTask(data['params']);
            }
          }
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          log.i("onLaunch: $message");
          final dynamic data = message['data'];
          // check type
          if(data != null) {
            if(data['type'] == 'NewJob') {
              log.i('new-job');
              // locator<DeliveryService>().receiveTask(data['params']);
            }
          }
        },
        onResume: (Map<String, dynamic> message) async {
          log.i("onResume: $message");
          final dynamic data = message['data'];
          // check type
          if(data != null) {
            if(data['type'] == 'NewJob') {
              log.i('new-job');
              // locator<DeliveryService>().receiveTask(data['params']);
            }
          }
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      log.d("FirebaseMessaging token: $token");
      await locator<MessagingTokenService>().sendToken(token);
      
      _initialized = true;
    }
  }
}
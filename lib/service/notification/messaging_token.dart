import 'package:flutter/foundation.dart';
import 'package:imageChat/service/auth_service.dart';
import 'package:logger/logger.dart';
import '../../util/network_config.dart';
import '../../logger.dart';
import '../../locator.dart';

class MessagingTokenService extends ChangeNotifier {
  Logger log = getLogger("MessagingTokenService");
  final String service;

  /// Notification settings
  bool _promotion = true;
  bool _orderStatus = true;
  bool get promotion => _promotion;
  bool get orderStatus => _orderStatus;

  MessagingTokenService({this.service = 'https://example.com'});

  Future<void> sendToken(String token) async {
    Map<String, dynamic> body = {
      // string id = 1;
      "id": locator<AuthService>().user.id?? '',
      // string type = 2; "FirebaseMessaging", "HMS"
      "type": "FirebaseMessaging",
      // string platform = 3; "Mobile/Android", "Mobile/IOS"
      "platform": "Mobile/Android",
      // string token = 4;
      "token": token,
      // string domain = 5; "com.getitqec.getit_client"
      "domain": "com.getitqec.imagechat"
    };
    try {
      await locator<API>().post(service, '/api/notification/token', body);
    } on ApiError catch(e) {
      // 
    } catch(e) {
      //
    }
  }

  // Future<void> getSetting() async {
  //   try {
  //     Map result = await locator<API>().get(service, '/api/notification/setting');
  //     _promotion = result['promotion'];
  //     _orderStatus = result['orderStatus'];
  //   } on ApiError catch(e) {
  //     // 
  //   } catch(e) {
  //     //
  //   }
  // }

  // Future<void> putSetting({promotion = true, orderStatus = true}) async {
  //   try {
  //     await locator<API>().put(service, '/api/notification/setting', {
  //       'promotion': promotion,
  //       'orderStatus': orderStatus
  //     });
  //     _promotion = promotion;
  //     _orderStatus = orderStatus;
  //   } on ApiError catch(e) {
  //     // 
  //   } catch(e) {
  //     //
  //   }
  // }
}
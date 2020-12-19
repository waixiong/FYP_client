import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imagechat_native_opencv/native_opencv.dart';

void main() {
  const MethodChannel channel = MethodChannel('native_opencv');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ImageChatNativeOpenCV.platformVersion, '42');
  });
}

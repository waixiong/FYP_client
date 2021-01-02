import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:convert';
import 'package:ffi/ffi.dart';
// import 'package:ffi/src/utf8.dart';
import 'package:aes_crypt/aes_crypt.dart';

import './_cryptor.dart';

// C function signatures
typedef _encode_image_func = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Int8, ffi.Int8, ffi.Int8);
typedef _decode_image_func = ffi.Void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Int8, ffi.Int8);

// Dart function signatures
typedef _EncodeImageFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, int, int, int);
typedef _DecodeImageFunc = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, int, int);

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = Platform.isAndroid
  ? ffi.DynamicLibrary.open('libnative_opencv.so')
  : ffi.DynamicLibrary.process();
// ffi.DynamicLibrary _lib = Platform.isAndroid
//   ? ffi.DynamicLibrary.open('libdelaunator_pattern.so')
//   : ffi.DynamicLibrary.process();

// Looking for the functions
final _EncodeImageFunc _nativeEncodeDelaunatorPattern = _lib
  .lookup<ffi.NativeFunction<_encode_image_func>>('encodeDelaunatorPattern')
  .asFunction();
final _DecodeImageFunc _nativeDecodeDelaunatorPattern = _lib
  .lookup<ffi.NativeFunction<_decode_image_func>>('decodeDelaunatorPattern')
  .asFunction();

ffi.Pointer<Utf8> _encodeDelaunatorPattern(List args/*[String inputB64, String outputFile]*/) {
  return _nativeEncodeDelaunatorPattern(Utf8.toUtf8(args[0]), Utf8.toUtf8(args[1]), args[2], args[3], args[4]);
}

void _decodeDelaunatorPattern(List args/*[String inputFile, String outputFile]*/) {
  return _nativeDecodeDelaunatorPattern(Utf8.toUtf8(args[0]), Utf8.toUtf8(args[1]), args[2], args[3]);
}

Future<String> encodeDelaunatorPattern(String input, String outputFile, {String password = '', int type = 0, int colorFixed = 0, int fixedValue = 0}) async {
  // try {
  //   await File(intermediate).delete();
  // } catch(e) {
  //   // ignore
  // }
  // if(password.isEmpty) password = 'pass';
  // var crypt = AesCrypt(password);
  // intermediate = await crypt.encryptTextToFile(input, intermediate, utf16: true);
  // Uint8List byteData = await File(intermediate).readAsBytes();
  // String inputB64 = base64Encode(byteData);
  String inputB64 = encrypt(input, password);
  print(inputB64);

  try {
    print('START [encodeDelaunatorPattern]');
    final port = ReceivePort();
    // Completer<ffi.Pointer<Utf8>> completer = Completer<ffi.Pointer<Utf8>>();
    Completer<void> completer = Completer<void>();
    // Making a variable to store a subscription in, listeting for messages on port
    StreamSubscription sub;
    sub = port.listen((result) async {
      // Cancel a subscription after message received called
      print('FROM CPP Port: $result');
      completer.complete();
      await sub?.cancel();
    }, onDone: completer.complete);
    final isolate = await Isolate.spawn<List>(
      _encodeDelaunatorPattern, 
      [inputB64, outputFile, type, colorFixed, fixedValue], 
      onError: port.sendPort, 
      onExit: port.sendPort
    );
    // var n = _encodeDelaunatorPattern([inputB64, outputFile]);

    var n = await completer.future;
    print('DONE [encodeDelaunatorPattern]');
    isolate.kill();
    if( !(await File(outputFile).exists()) ) return "Too many tries, try again to encode";
    return "Done";
  } catch(e) {
    print('[Error on encodeDelaunatorPattern] $e');
    return 'isolate issue, please run again';
  }
}

Future<String> decodeDelaunatorPattern(String inputFile, String outputFile, {String password = '', int type = 0, int colorFixed = 0}) async {
  try {
    print('START [decodeDelaunatorPattern]');
    final port = ReceivePort();
    Completer<void> completer = Completer<void>();
    // Making a variable to store a subscription in, listeting for messages on port
    StreamSubscription sub;
    sub = port.listen((_) async {
      // Cancel a subscription after message received called
      completer.complete();
      await sub?.cancel();
    }, onDone: completer.complete);
    final isolate = await Isolate.spawn<List>(
      _decodeDelaunatorPattern, 
      [inputFile, outputFile, type, colorFixed], 
      onError: port.sendPort, 
      onExit: port.sendPort
    );
    // _decodeDelaunatorPattern([inputFile, outputFile]);
    await completer.future;
    print('DONE [decodeDelaunatorPattern]');
    isolate.kill();
  } catch(e) {
    print('[Error on _decodeDelaunatorPattern] $e');
    return 'isolate issue, please run again';
  }

  try {
    var outputB64 = (await File(outputFile).readAsString());
    String decryptedString = decrypt(outputB64, password);
    return decryptedString;
  } catch(e) {
    print('[Error on decrypt] $e');
    return 'decrypt error';
  }
}

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
typedef _encode_image_func = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _decode_image_func = ffi.Void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Dart function signatures
typedef _EncodeImageFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _DecodeImageFunc = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

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

ffi.Pointer<Utf8> _encodeDelaunatorPattern(List<String> args/*[String inputB64, String outputFile]*/) {
  return _nativeEncodeDelaunatorPattern(Utf8.toUtf8(args[0]), Utf8.toUtf8(args[1]));
}

void _decodeDelaunatorPattern(List<String> args/*[String inputFile, String outputFile]*/) {
  return _nativeDecodeDelaunatorPattern(Utf8.toUtf8(args[0]), Utf8.toUtf8(args[1]));
}

Future<String> encodeDelaunatorPattern(String input, String outputFile, {String password = '', String intermediate = 'input'}) async {
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
  final isolate = await Isolate.spawn<List<String>>(
    _encodeDelaunatorPattern, 
    [inputB64, outputFile], 
    onError: port.sendPort, 
    onExit: port.sendPort
  );
  // var n = _encodeDelaunatorPattern([inputB64, outputFile]);

  var n = await completer.future;
  print('DONE [encodeDelaunatorPattern]');
  // final int length = Utf8.strlen(n);
  // print('length $length');
  // Uint8List bytes = Uint8List.view(n.cast<ffi.Uint8>().asTypedList(length).buffer, 0, length);
  // print(bytes);
  return "Done";
  // return ascii.decode(bytes);
  // return utf8.decode(bytes, allowMalformed: true);
  // return Utf8.fromUtf8(n);
  // return Utf8.fromUtf8(_encodeDelaunatorPattern(Utf8.toUtf8(input), Utf8.toUtf8(outputFile)));
}

Future<String> decodeDelaunatorPattern(String inputFile, String outputFile, {String password = ''}) async {
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
  final isolate = await Isolate.spawn<List<String>>(
    _decodeDelaunatorPattern, 
    [inputFile, outputFile], 
    onError: port.sendPort, 
    onExit: port.sendPort
  );
  // _decodeDelaunatorPattern([inputFile, outputFile]);
  await completer.future;
  print('DONE [decodeDelaunatorPattern]');
  // final int length = Utf8.strlen(n);
  // print('length $length');
  // Uint8List bytes = Uint8List.view(n.cast<ffi.Uint8>().asTypedList(length).buffer, 0, length);
  // print(bytes);
  // return "Done";
  // return Utf8.fromUtf8(n);
  // return Utf8.fromUtf8(_decodeDelaunatorPattern(Utf8.toUtf8(inputFile)));

  // if(password.isEmpty) password = 'pass';
  // var crypt = AesCrypt(password);
  // print(outputFile);
  var outputB64 = (await File(outputFile).readAsString());
  print(outputB64);
  // await File(outputFile).writeAsBytes(base64Decode(outputB64), mode: FileMode.write);
  // print(await File(outputFile).length());
  // String decryptedString = await crypt.decryptTextFromFile(outputFile, utf16: true);
  String decryptedString = decrypt(outputB64, password);
  return decryptedString;
}

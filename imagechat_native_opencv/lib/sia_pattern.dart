import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

// C function signatures
typedef _generate_image_func = ffi.Void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _decode_image_func = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Dart function signatures
typedef _GenerateImageFunc = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _DecodeImageFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = Platform.isAndroid
  ? ffi.DynamicLibrary.open('libnative_opencv.so')
  : ffi.DynamicLibrary.process();

// Looking for the functions
final _GenerateImageFunc _generateImage = _lib
  .lookup<ffi.NativeFunction<_generate_image_func>>('generateImage')
  .asFunction();
final _DecodeImageFunc _decodeImage = _lib
    .lookup<ffi.NativeFunction<_decode_image_func>>('decodeImage')
    .asFunction();

void dart_generateImage(List<String> args) {
  _generateImage(Utf8.toUtf8(args[0]), Utf8.toUtf8(args[1]), Utf8.toUtf8(args[2]));
}

void dart_decodeImage(List<String> args) {
  _decodeImage(Utf8.toUtf8(args[0]), Utf8.toUtf8(args[1]));
}

Future<void> generateImage(String data, String outputPath, String type) async {
  // _generateImage(Utf8.toUtf8(data), Utf8.toUtf8(outputPath), Utf8.toUtf8(type));

  try {
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
      dart_generateImage, 
      [data, outputPath, type], 
      onError: port.sendPort, 
      onExit: port.sendPort
    );
    // _decodeDelaunatorPattern([inputFile, outputFile]);
    await completer.future;
    isolate.kill();
  } catch(e) {
    print('Error on SiaPattern isolate');
  }
}

Future<String> decodeImage(String inputPath, String outputPath) async {
  // _decodeImage(Utf8.toUtf8(inputPath), Utf8.toUtf8(outputPath));
  // ffi.Pointer<Utf8> r = _decodeImage(Utf8.toUtf8(inputPath));
  // final int length = Utf8.strlen(r);
  // print('Result: $length');
  // Uint8List list = Uint8List.view(r.cast<ffi.Uint8>().asTypedList(length).buffer, 0, length);
  // print(list);
  try {
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
      dart_decodeImage, 
      [inputPath, outputPath], 
      onError: port.sendPort, 
      onExit: port.sendPort
    );
    // _decodeDelaunatorPattern([inputFile, outputFile]);
    await completer.future;
    isolate.kill();
  } catch(e) {
    print('Error on SiaPattern isolate');
    return null;
  }

  print('done cpp');
  var output = await File(outputPath).readAsString();
  print('done get output');
  return output;
}

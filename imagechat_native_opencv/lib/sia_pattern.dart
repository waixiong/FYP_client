import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// C function signatures
typedef _generate_image_func = ffi.Void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _decode_image_func = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>);

// Dart function signatures
typedef _VersionFunc = ffi.Pointer<Utf8> Function();
typedef _GenerateImageFunc = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _DecodeImageFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>);

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

void generateImage(String data, String outputPath, String type) {
  _generateImage(Utf8.toUtf8(data), Utf8.toUtf8(outputPath), Utf8.toUtf8(type));
}

String decodeImage(String inputPath){
  return Utf8.fromUtf8(_decodeImage(Utf8.toUtf8(inputPath)));
}

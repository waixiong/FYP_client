import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// C function signatures
typedef _encode_image_func = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Dart function signatures
typedef _EncodeImageFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = Platform.isAndroid
  ? ffi.DynamicLibrary.open('libnative_opencv.so')
  : ffi.DynamicLibrary.process();
// ffi.DynamicLibrary _lib = Platform.isAndroid
//   ? ffi.DynamicLibrary.open('libdelaunator_pattern.so')
//   : ffi.DynamicLibrary.process();

// Looking for the functions
final _EncodeImageFunc _encodeDelaunatorPattern = _lib
  .lookup<ffi.NativeFunction<_encode_image_func>>('encodeDelaunatorPattern')
  .asFunction();

String encodeDelaunatorPattern(String input, String outputFile) {
  return Utf8.fromUtf8(_encodeDelaunatorPattern(Utf8.toUtf8(input), Utf8.toUtf8(outputFile)));
}

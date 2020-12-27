import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:ffi/ffi.dart';
// import 'package:ffi/src/utf8.dart';

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
final _EncodeImageFunc _encodeDelaunatorPattern = _lib
  .lookup<ffi.NativeFunction<_encode_image_func>>('encodeDelaunatorPattern')
  .asFunction();
final _DecodeImageFunc _decodeDelaunatorPattern = _lib
  .lookup<ffi.NativeFunction<_decode_image_func>>('decodeDelaunatorPattern')
  .asFunction();

String encodeDelaunatorPattern(String input, String outputFile) {
  print(utf8.encode(input));
  print(ascii.encode(input));
  print('START [encodeDelaunatorPattern]');
  var n = _encodeDelaunatorPattern(Utf8.toUtf8(input), Utf8.toUtf8(outputFile));
  print('DONE [encodeDelaunatorPattern] $n');
  final int length = Utf8.strlen(n);
  print('length $length');
  Uint8List bytes = Uint8List.view(n.cast<ffi.Uint8>().asTypedList(length).buffer, 0, length);
  print(bytes);
  return "Done";
  return ascii.decode(bytes);
  return utf8.decode(bytes, allowMalformed: true);
  return Utf8.fromUtf8(n);
  // return Utf8.fromUtf8(_encodeDelaunatorPattern(Utf8.toUtf8(input), Utf8.toUtf8(outputFile)));
}

void decodeDelaunatorPattern(String inputFile, String outputFile) {
  print('START [decodeDelaunatorPattern]');
  _decodeDelaunatorPattern(Utf8.toUtf8(inputFile), Utf8.toUtf8(outputFile));
  print('DONE [decodeDelaunatorPattern]');
  // final int length = Utf8.strlen(n);
  // print('length $length');
  // Uint8List bytes = Uint8List.view(n.cast<ffi.Uint8>().asTypedList(length).buffer, 0, length);
  // print(bytes);
  // return "Done";
  // return Utf8.fromUtf8(n);
  // return Utf8.fromUtf8(_decodeDelaunatorPattern(Utf8.toUtf8(inputFile)));
}


// print wrapped
// void wrappedPrint(ffi.Pointer<Utf8> arg){
//   print(Utf8.fromUtf8(arg));
// }

// typedef _wrappedPrint_C = ffi.Void Function(ffi.Pointer<Utf8> a);
// final wrappedPrintPointer = ffi.Pointer.fromFunction<_wrappedPrint_C>(_wrappedPrint_C);

// final void Function(ffi.Pointer) initialize =
//   _lib
//     .lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer)>>("initialize")
//     .asFunction<void Function(ffi.Pointer)>();

// initialize(wrappedPrintPointer);
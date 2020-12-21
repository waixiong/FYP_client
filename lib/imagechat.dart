import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// C function signatures
typedef _version_func = ffi.Pointer<Utf8> Function();
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
final _VersionFunc _version = _lib
  .lookup<ffi.NativeFunction<_version_func>>('version')
  .asFunction();
final _GenerateImageFunc _generateImage = _lib
  .lookup<ffi.NativeFunction<_generate_image_func>>('generateImage')
  .asFunction();
final _DecodeImageFunc _decodeImage = _lib
    .lookup<ffi.NativeFunction<_decode_image_func>>('decodeImage')
    .asFunction();

String opencvVersion() {
  return Utf8.fromUtf8(_version());
}

void generateImage(ProcessImageArguments args) {
  _generateImage(Utf8.toUtf8(args.data), Utf8.toUtf8(args.outputPath), Utf8.toUtf8(args.type));
}

String decodeImage(DecodeImageArguments args){
  return Utf8.fromUtf8(_decodeImage(Utf8.toUtf8(args.inputPath)));
}

class ProcessImageArguments {
  final String data;
  final String outputPath;
  final String type;

  ProcessImageArguments(this.data, this.outputPath, this.type);
}

class DecodeImageArguments {
  final String inputPath;

  DecodeImageArguments(this.inputPath);
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import 'package:imageChat/view/pages/secret_image_decode_page.dart';

import 'package:imagechat_native_opencv/delaunator_pattern.dart' as DelaunatorPattern;
import 'package:imagechat_native_opencv/imagechat.dart' as nativeCV;

import 'package:image_downloader/image_downloader.dart';
import '../locator.dart';

enum Format {
  Cheelaunator,
  SiaPattern,
}

class SecretImageViewModel extends BaseViewModel {
  final TextEditingController inputText = TextEditingController();
  final TextEditingController secretText = TextEditingController();
  // Format format = Format.SiaPattern;
  Format format = Format.Cheelaunator;

  ImageProvider _image;

  FileImage _outputImg;
  String _outputString;
  FileImage get outputImg => _outputImg;
  String get outputString => _outputString;

  imageFromNetwork(String url) {
    _image = NetworkImage(url);
  }

  imageFromFile(File file) {
    _image = FileImage(file);
  }

  decode() async {
    String path;
    if(_image is NetworkImage) {
      var imageId = await ImageDownloader.downloadImage((_image as NetworkImage).url);
      // Below is a method of obtaining saved image information.
      path = await ImageDownloader.findPath(imageId);
    } else if(_image is FileImage) {
      path = (_image as FileImage).file.path;
    }
    try {
      if(format == Format.Cheelaunator) {
        DelaunatorPattern.encodeDelaunatorPattern(inputText.text, tempDir.path + '/img.webp');
      }
      _outputImg = FileImage(File(tempDir.path + '/img.webp'));
      setBusyForObject("decode", false);
    } catch(e) {
      log.e("encoding err");
      setBusyForObject("decode", false);
    }
  }

  encode() async {
    setBusyForObject("encode", true);
    log.i('start encode');
    // await File(tempDir.path + '/img.webp').delete();
    // print(appDocDir.path);
    try {
      if(format == Format.Cheelaunator) {
        DelaunatorPattern.encodeDelaunatorPattern(inputText.text, tempDir.path + '/img.webp');
      } else {
        //
      }
      _outputImg = FileImage(File(tempDir.path + '/img.webp'));
      setBusyForObject("encode", false);
      log.i('done encode');
    } catch(e) {
      log.e("encoding err");
      log.e(e);
      setBusyForObject("encode", false);
    }
  }

  void clear() {
    inputText.clear();
    secretText.clear();
  }
}
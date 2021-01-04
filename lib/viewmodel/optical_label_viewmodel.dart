import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import '../locator.dart';
import 'package:imagechat_native_opencv/sia_pattern.dart' as siaPattern;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:imageChat/logger.dart';

class OpticalLabelViewModel extends BaseViewModel {
  final log = getLogger('OpticalLabelViewModel');
  final TextEditingController inputText = TextEditingController();
  //camera
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();

  FileImage _outputImg;
  String _outputString;
  FileImage get outputImg => _outputImg;
  String get outputString => _outputString;

  String decodeErr;

  OpticalLabelViewModel();

  //camera
  void onCameraButtonPressed() async{
    await _onCameraButtonPressed(ImageSource.camera);
  }

  void _onCameraButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      _imageFile = pickedFile;
      await decode();
      print(pickedFile.toString());
    } catch (e) {
      _pickImageError = e;
    }
  }

  //gallery
  void onGalleryButtonPressed() async{
    await _onGalleryButtonPressed(ImageSource.gallery);
  }

  void _onGalleryButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      _imageFile = pickedFile;
      log.i("pickedFile");
      log.i(pickedFile.path);
      await decode();
    } catch (e) {
      _pickImageError = e;
    }
  }

  decode() async {
    String path;
    try {
      if(_imageFile != null){
        log.i("Enter decoding:");
        log.i(_imageFile.path);
        String decodedText = await siaPattern.decodeImage(_imageFile.path, tempDir.path+'/output');
        if(decodedText == "error in decoding"){
          decodeErr = decodedText;
        }
        else{
          _outputString = decodedText;
        }
        log.i("decode text: ");
        log.i(decodedText);
      }
//      _outputImg = FileImage(File(tempDir.path + '/img.webp'));
      setBusyForObject("decode", false);
    } catch(e) {
      log.e("decoding err");
      log.e(e);
      decodeErr = "decoding err";
      setBusyForObject("decode", false);
    }
  }

  encode() async {
    setBusyForObject("encode", true);
    log.i('start encode');
    // await File(tempDir.path + '/img.webp').delete();
    // print(appDocDir.path);
    try {
        siaPattern.generateImage(inputText.text, tempDir.path + '/img.jpg', "Code");
        _outputImg = FileImage(File(tempDir.path + '/img.jpg'));
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
  }
}
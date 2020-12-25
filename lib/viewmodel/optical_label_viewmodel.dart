import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';

class OpticalLabelViewModel extends BaseViewModel {
  //camera
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();

  OpticalLabelViewModel();

  //camera
  void onImageButtonPressed(BuildContext context) async{
    await _onImageButtonPressed(ImageSource.camera, context: context);
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      _imageFile = pickedFile;
      print(pickedFile.toString());
    } catch (e) {
      _pickImageError = e;
    }
  }
}
// FROM yeez_menu wxchee@gitlab.com

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../util/network_config.dart';
import '../logger.dart';
import '../locator.dart';
import './_exception.dart';

// import 'dart:html' as html;
// import 'package:file_picker/file_picker.dart';

// enum Bucket {
//   getitproducts,
//   storeprofile,
//   storelogo,
//   yeezcarouselads,
//   // userprofile,
// }

// String Bucket2String(Bucket bucket) {
//   return bucket.toString().substring(7);
// }

/// admin used - upload image
class FileService extends ChangeNotifier {
  Logger log = getLogger("UserService");
  final String service;

  FileService({this.service = 'https://example.com'});

  // --------- For Business and Store Admin ---------
  Future<void> uploadImage(String name, Uint8List bytes) async {
    try {
      await locator<API>().post(service, '/api/file/s', {
        'name': name,
        'image': base64Encode(bytes)
      });
    } on ApiError catch(e) {
      log.e("API: $e");
      throw checkServiceError(e);
    } catch(e) {
      log.e("Err: $e");
      throw e;
    }
  }
  // --------- For Business and Store Admin ---------
}

// class ImagePicker {
//   Logger log = getLogger("ImagePicker");

//   static Future<Uint8List> startFilePicker() async {
//     // html.InputElement uploadInput = html.FileUploadInputElement();
//     // uploadInput.click();

//     FilePickerResult result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       withData: true,
//       onFileLoading: (status) {
//         // status.index;
//       }
//     );

//     if(result != null) {
//       // File file = File(result.files.single.path);
//       Uint8List bytes = result.files.single.bytes;
//       return bytes;
//     }
//     return null;
//   }
// }
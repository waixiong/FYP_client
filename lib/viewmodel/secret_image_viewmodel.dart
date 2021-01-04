import 'dart:io';

import 'package:flutter/services.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:imageChat/logger.dart';
import 'package:imageChat/service/auth_service.dart';
import 'package:imageChat/service/chat_service.dart';
import 'package:imageChat/service/file_service.dart';
import 'package:imageChat/util/random.dart';
import 'package:imageChat/view/pages/chats_list_page.dart';
import 'package:imageChat/view/widgets/color_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import 'package:imageChat/view/pages/secret_image_decode_page.dart';

import 'package:imagechat_native_opencv/delaunator_pattern.dart' as DelaunatorPattern;
import 'package:imagechat_native_opencv/opencv.dart' as nativeCV;
import 'package:imagechat_native_opencv/sia_pattern.dart' as SiaPattern;

import 'package:image_downloader/image_downloader.dart';
import 'package:stacked_services/stacked_services.dart';
import '../locator.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

enum Format {
  Cheelaunator,
  SiaPattern,
}

class SecretImageViewModel extends BaseViewModel {
  final log = getLogger('SecretImageViewModel');
  final TextEditingController inputText = TextEditingController();
  final TextEditingController secretText = TextEditingController();
  // final TextEditingController decodedText = TextEditingController();
  // final String salt = "a=";
  final String salt = "SW1hZ2VDaGF0MTIz";

  Format format = Format.SiaPattern;
  bool custom = false;
  FixedColor fixedColor = FixedColor.Green;
  int fixedValue = 8;

  final Future Function(String, String) sendToChat;

  ImageProvider _image;
  ImageProvider get inputImage => _image;

  FileImage _outputImg;
  String _outputString;
  FileImage get outputImg => _outputImg;
  String get outputString => _outputString;

  String decodeErr;
  String encodeErr;

  imageFromNetwork(String url) {
    if(url != null)
    _image = NetworkImage(url);
  }

  imageFromFile(String path) {
    log.i('OPEN: '+path);
    _image = FileImage(File(path));
    notifyListeners();
  }

  SecretImageViewModel({this.sendToChat});

  Future<void> decode() async {
    setBusyForObject("decode", true);
    String path;
    if(_image is NetworkImage) {
      try {
        // var imageId = await ImageDownloader.downloadImage((_image as NetworkImage).url, destination: AndroidDestinationType.directoryDownloads);
        // Below is a method of obtaining saved image information.
        // path = await ImageDownloader.findPath(imageId);

        final ByteData imageData = await NetworkAssetBundle(Uri.parse((_image as NetworkImage).url)).load("");
        final tempFile = File(tempDir.path+"/downloadedImg");
        await tempFile.writeAsBytes(imageData.buffer.asUint8List());
        path = tempDir.path+"/downloadedImg";
      } on PlatformException catch (error) {
        print(error);
        return;
      }
    } else if(_image is FileImage) {
      path = (_image as FileImage).file.path;
    }
    try {
      if(format == Format.Cheelaunator) {
        String n = await DelaunatorPattern.decodeDelaunatorPattern(
          path, 
          tempDir.path+'/output', password: secretText.text,
          type: custom? 1 : 0,
          colorFixed: fixedColor == FixedColor.Red? 0 : fixedColor == FixedColor.Green? 1 : 2 
        );
        if(n == 'decrypt error' || n == 'isolate issue, please run again') {
          _outputString = null;
          decodeErr = n;
        } else {
          _outputString = n;
        }
      } else{
        log.i('Using SiaPattern');
        String out = await SiaPattern.decodeImage(path, tempDir.path+'/output');
        log.i('Done SiaPattern $out');
        if(out == "error in decoding"){
          decodeErr = out;
        }
        else{
          if(secretText.text.length != 0){
            await _decrypt(out);
            // _outputString = await _decrypt(out);
          } else {
            _outputString = out;
          }
        }
      }
      // _outputImg = FileImage(File(tempDir.path + '/img.webp'));
      setBusyForObject("decode", false);
    } catch(e) {
      log.e("encoding err");
      log.e(e);
      setBusyForObject("decode", false);
    }
  }

  Future<void> encode() async {
    setBusyForObject("encode", true);
    log.i('start encode');
    // await File(tempDir.path + '/img.webp').delete();
    // print(appDocDir.path);
    try {
      await File(tempDir.path + '/img.webp').delete();
    } catch(e) {} // ignore
    try {
      if(format == Format.Cheelaunator) {
        var n = await DelaunatorPattern.encodeDelaunatorPattern(
          inputText.text, 
          tempDir.path + '/img.webp', 
          password: secretText.text,
          type: custom? 1 : 0,
          colorFixed: fixedColor == FixedColor.Red? 0 : fixedColor == FixedColor.Green? 1 : 2,
          fixedValue: fixedValue
        );
        log.i('from cpp: $n');
        if(n == 'Done') {
          _outputImg = FileImage(File(tempDir.path + '/img.webp'));
        } else {
          _outputImg = null;
          encodeErr = n;
        }
      } else {
        String encryptedData = inputText.text;
        if(secretText.text.length != 0){
          encryptedData = await _encrypt();
        }
        await SiaPattern.generateImage(encryptedData, tempDir.path + '/img.webp', 'Image');
        if(await File(tempDir.path + '/img.webp').exists()) {
          _outputImg = FileImage(File(tempDir.path + '/img.webp'));
        } else {
          _outputImg = null;
          encodeErr = 'Error on SiaPattern Encoding';
        }        
      }
      setBusyForObject("encode", false);
      log.i('done encode');
    } catch(e) {
      log.e("encoding err");
      log.e(e);
      setBusyForObject("encode", false);
      log.e("err drop");
    }
  }

  Future<String> _encrypt() async{
    final cryptor = new PlatformStringCryptor();
    String secretKey = secretText.text;
    String key = await cryptor.generateKeyFromPassword(secretKey, salt);
    String encryptedData = await cryptor.encrypt(inputText.text, key);
    return encryptedData;
  }

  Future<String> _decrypt(String encryptedData) async{
    final cryptor = new PlatformStringCryptor();
    String secretKey = secretText.text;
    try {
      String key = await cryptor.generateKeyFromPassword(secretKey, salt);
      String decryptedData = await cryptor.decrypt(encryptedData, key);
      _outputString = decryptedData;
      return _outputString;
    } on MacMismatchException {
      log.e("wrongly decrypted");
      _outputString = null;
      decodeErr = "Can't decrypt the image";
    }
    return _outputString;
  }
  
  changePatternFormat(Format f) {
    format = f;
    notifyListeners();
  }

  Future<void> send() async {
    String attach = format == Format.Cheelaunator? 'chee' : 'sia';
    if(sendToChat != null) {
      log.i('send');
      // locator<SnackbarService>().showSnackbar(message: 'Send');
      // return;
      setBusyForObject("send", true);
      try {
        await sendToChat(outputImg.file.path, attach);
      } catch(e) {
        // setBusyForObject("send", false);
        log.e('send: $e');
        locator<SnackbarService>().showSnackbar(message: 'Error sending message');
      }
    } else {
      log.i('pick');
      // locator<SnackbarService>().showSnackbar(message: 'Pick');
      // return;
      // TODO: choose from receiver
      ChatUser receiver = await locator<NavigationService>().navigateToView(ChatListChoice());
      if(receiver == null) {
        locator<SnackbarService>().showSnackbar(message: 'Abort send image');
      }
      String id = getRandomString(18);
      var bytes = await outputImg.file.readAsBytes();
      try {
        await locator<FileService>().uploadImage(id, bytes);
        String url = 'https://file.angelmortal.xyz/file/testBuc/$id';
        ChatMessage message = ChatMessage(
          text: '', 
          user: locator<AuthService>().user.toChatUser(), 
          image: url, 
          customProperties: {
            'attachment': attach
          }
        );
        await locator<ChatService>().sendMessage(message, receiver.uid);
        locator<SnackbarService>().showSnackbar(message: 'message sent');
      } catch(e) {
        log.e('send: $e');
        setBusyForObject("send", false);
        locator<SnackbarService>().showSnackbar(message: 'Error sending message');
      }
    }
    setBusyForObject("send", false);
  }

  Future<void> save() async {
    setBusyForObject("save", true);
    String path = externalDir.path + '/' + getRandomString(15) + '.webp';
    File file = await _outputImg.file.copy(path);
    log.i(file.path);
    setBusyForObject("save", false);
    locator<SnackbarService>().showSnackbar(message: 'Save at $path', duration: Duration(seconds: 6));
  }

  void clear() {
    inputText.clear();
    secretText.clear();
    _outputImg = null;
    notifyListeners();
  }
}
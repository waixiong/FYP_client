import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:imageChat/service/auth_service.dart';
import 'package:imageChat/service/chat_service.dart';
import 'package:imageChat/service/file_service.dart';
import 'package:imageChat/util/random.dart';
import 'package:imageChat/view/pages/chats_list_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import 'package:imageChat/view/pages/secret_image_decode_page.dart';

import 'package:imagechat_native_opencv/delaunator_pattern.dart' as DelaunatorPattern;
import 'package:imagechat_native_opencv/opencv.dart' as nativeCV;

import 'package:image_downloader/image_downloader.dart';
import 'package:stacked_services/stacked_services.dart';
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

  final Future Function(String, String) sendToChat;

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

  SecretImageViewModel({this.sendToChat});

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

  send() async {
    String attach = format == Format.Cheelaunator? 'chee' : 'sia';
    if(sendToChat != null) {
      log.i('send');
      // locator<SnackbarService>().showSnackbar(message: 'Send');
      // return;
      setBusyForObject("send", true);
      try {
        await sendToChat(outputImg.file.path, attach);
      } catch(e) {
        setBusyForObject("send", false);
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
        locator<SnackbarService>().showSnackbar(message: 'Error sending message');
      }
    }
    setBusyForObject("send", false);
  }

  void clear() {
    inputText.clear();
    secretText.clear();
  }
}
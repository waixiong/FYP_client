import 'dart:convert';
import 'dart:typed_data';

// import 'package:aes_crypt/aes_crypt.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:pointycastle/pointycastle.dart';
import "package:pointycastle/export.dart";
import 'package:encrypt/encrypt.dart';

String encrypt(String input, String password) {
  final derivator = KeyDerivator("scrypt");
  derivator.init(ScryptParameters(64, 8, 4, 32, Uint8List.fromList([])));
  
  final ivDerivator = KeyDerivator("scrypt");
  ivDerivator.init(ScryptParameters(32, 8, 4, 16, Uint8List.fromList([])));

  var passwordByte = Uint8List.fromList(utf8.encode(password));
  var keyByte = Uint8List(32);
  var ivByte = Uint8List(16);
  derivator.deriveKey(passwordByte, 0, keyByte, 0);
  ivDerivator.deriveKey(passwordByte, 0, ivByte, 32);
  
  final key = Key(keyByte);
  final iv = IV(ivByte);
  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(input, iv: iv);

  // print(encrypted.base64);
  return encrypted.base64;
}

String decrypt(String encoded, String password) {
  final derivator = KeyDerivator("scrypt");
  derivator.init(ScryptParameters(64, 8, 4, 32, Uint8List.fromList([])));
  
  final ivDerivator = KeyDerivator("scrypt");
  ivDerivator.init(ScryptParameters(32, 8, 4, 16, Uint8List.fromList([])));

  var passwordByte = Uint8List.fromList(utf8.encode(password));
  var keyByte = Uint8List(32);
  var ivByte = Uint8List(16);
  derivator.deriveKey(passwordByte, 0, keyByte, 0);
  ivDerivator.deriveKey(passwordByte, 0, ivByte, 32);
  
  final key = Key(keyByte);
  final iv = IV(ivByte);
  final encrypter = Encrypter(AES(key));

  Encrypted encrypted = Encrypted.fromBase64(encoded);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  // print(encrypted.base64);
  return decrypted;
}
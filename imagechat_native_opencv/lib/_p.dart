import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// import 'package:aes_crypt/aes_crypt.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:imagechat_native_opencv/_cryptor.dart';

main(List<String> args) async {
  String password = 'p';
  String intermediate = './tttt';
  // String input = 'hey we are here for a great thing to start our new journey, the venture is loading';
  String input = 'hey';

  // var crypt = AesCrypt(password);
  // // await File(intermediate).delete();

  // try {
  //   await File(intermediate).delete();
  // } catch(e) {
  //   // ignore
  // }

  // intermediate = await crypt.encryptTextToFile(input, intermediate, utf16: true);
  // String decryptedString = await crypt.decryptTextFromFile(intermediate, utf16: true);

  // print(decryptedString);
  // print(await File(intermediate).length());
  // print((await File(intermediate).readAsBytes()).length);



  // final cryptor = new PlatformStringCryptor();
  // final String salt = await cryptor.generateSalt();
  // print('Salt: $salt\n');
  // final String key = await cryptor.generateKeyFromPassword(password, salt);
  // print('Key: $key\n');
  // final String encrypted = await cryptor.encrypt("A string to encrypt.", key);
  // print('Encrypted: $encrypted\n');
  // print('Len:s ${encrypted.length}\n');
  // try {
  //   final String decrypted = await cryptor.decrypt(encrypted, key);
  //   print(decrypted); // - A string to encrypt.
  // } on MacMismatchException {
  //   // unable to decrypt (wrong key or forged data)
  // }


  String en = encrypt(input, password);
  String de = decrypt(en, password);
  print(en);
  print(de);
}
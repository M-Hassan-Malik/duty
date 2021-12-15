import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class UserStorage {
  static var currentUserId;
  static final _storage = const FlutterSecureStorage();

  static storeGoogleUser(uid,BuildContext context) async {
    if (uid != null) {
      await _storage.write(key: "googleUser", value: uid);
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else
      print("@Method: storeGoogleUser: $uid");
  }

  static Future readGoogleUser() async {
    return await _storage.read(key: "googleUser");
  }

  static removeGoogleUser() {
    _storage.delete(key: "googleUser");
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class UserStorage {
  static var currentUserId;
  static final _storage = const FlutterSecureStorage();

  static storeGoogleUser(userData, BuildContext context) async {
    print("UserStorage/storeGoogleUser: ${userData.toString()}");
    if (userData != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("logging in..")));
      await _storage.write(key: "googleUser_uid", value: userData["uid"]);
      await _storage.write(key: "googleUser_photoURL", value: userData["photoURL"]);
      await _storage.write(key: "googleUser_email", value: userData["email"]);
      await _storage.write(key: "googleUser_name", value: userData["name"]);
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else
      print("@Method: storeGoogleUser: $userData");
  }

  static Future readGoogleUser(String value) async {
    if (value == "uid") {
      return await _storage.read(key: "googleUser_uid");
    } else if (value == "name") {
      return await _storage.read(key: "googleUser_name");
    } else if (value == "photoURL") {
      return await _storage.read(key: "googleUser_photoURL");
    } else if (value == "email") {
      return await _storage.read(key: "googleUser_email");
    }
  }

  static removeGoogleUser() {
    _storage.delete(key: "googleUser_uid");
    _storage.delete(key: "googleUser_photoURL");
    _storage.delete(key: "googleUser_email");
    _storage.delete(key: "googleUser_name");
  }
}

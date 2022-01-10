import 'package:duty/components/storage.dart';
import 'package:duty/provider/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;

      final credentials =
          GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      var googleUserInfo = await FirebaseAuth.instance.signInWithCredential(credentials);
      if(googleUserInfo.user != null) {
         Map<String,dynamic> userData= {
          "uid":  googleUserInfo.user?.uid,
          "email":  googleUserInfo.user?.email,
          "name":  googleUserInfo.user?.displayName,
          "photoURL":  googleUserInfo.user?.photoURL,

          };
        UserStorage.storeGoogleUser(userData, context);
      }else "";
    } catch (e) {
      print("google sign in catch-> ${e.toString()}");
    }
    notifyListeners();
  }

  Future googleLogout() async {
    UserStorage.removeGoogleUser();
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
} // Class endsc

class OTPProvider extends ChangeNotifier {
  bool clickedOTP = false;
  bool verifiedOTP = false;
  String _validEmail = "";
  int? _validOTP;

  String get validEmail => _validEmail;

  sendOTP(String email) async {
    OTP_Received(jsonResponse) {
      clickedOTP = true;
      _validOTP = jsonResponse['result']['otp'];
      _validEmail = "";
    }

    var body = new Map<String, dynamic>();
    body['email'] = email;
    var response = await http.post(Uri.parse('$API_URL/user/verify'), body: body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      jsonResponse.containsKey('result') ? OTP_Received(jsonResponse) : _validEmail = "Error Sending verification code.\nTry again";
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }

  bool verifyOTP(String otp) {
    if (int.parse(otp) == _validOTP)
      return true;
    else
      return false;
  } // ends
}

class FirebaseAuthenticationProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> register(String _email, String _pass) async {
    try {
      final UserCredential _user = await _auth.createUserWithEmailAndPassword(email: _email, password: _pass);
      print("Successful:  ${_user.toString()}");
      return true;
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          return false;
        }
      }
    }
    return false;
  } //

  signIn(String _email, String _pass,context) async {
    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(email: _email, password: _pass);
      if(credentials.user != null) {
        Map<String,dynamic> userData= {
          "uid":  credentials.user?.uid,
          "email":  credentials.user?.email,
          "name":  credentials.user?.displayName,
          "photoURL":  credentials.user?.photoURL,
        };
        UserStorage.storeGoogleUser(userData, context);
      }else "";
    } catch (e) {
      ScaffoldMessenger.of(context)

          .showSnackBar(SnackBar(
          duration: Duration(seconds: 8, milliseconds: 500),
      content: Text(e.toString())));
    }
  } //

  Future<void> signOut() async {
    UserStorage.removeGoogleUser();
    await _auth.signOut();
  }
}

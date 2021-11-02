import 'package:duty/theme.dart';
import 'package:duty/ui/home_page.dart';
import 'package:duty/ui/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggingPage extends StatelessWidget {
  const LoggingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator( color: myPrimaryColor,));
        } else if (snapshot.hasData) {
          return HomePage();
        } else if (snapshot.hasError) {
          return Center(child: Text("Something Went Wrong"));
        } else {
          return Login();
        }
      });
}

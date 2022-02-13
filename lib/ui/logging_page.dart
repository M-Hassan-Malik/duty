import 'package:duty/components/storage.dart';
import 'package:duty/components/switchUser.dart';
import 'package:duty/theme.dart';
import 'package:duty/ui/home_page.dart';
import 'package:duty/ui/login_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: UserStorage.readGoogleUser("uid"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: myPrimaryColor,
          ));
        } else if (snapshot.hasData) {
          return SwitchUser(uid: snapshot.data);
        //  return HomePage(uid: snapshot.data);
        } else if (snapshot.hasError) {
          return Login();
        } else {
          return Login();
        }
      });
}

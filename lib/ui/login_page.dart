import 'package:duty/components/login_area.dart';
import 'package:duty/provider/SignInProvider.dart';
import 'package:duty/theme.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Widget getElevatedButton(Widget logo, String name, BuildContext context) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.white, minimumSize: Size(30, 40)),
      child: logo,
      onPressed: () {
        switch (name) {
          case "google":
            {
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin(context);
            }
            break;
          case "facebook":
            {
              int t = 0;
            }
            break;
          default:
            print("Default");
        }
      },
    );

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.9,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.accessibility_new_rounded, size: 100.0, color: myPrimaryColor),
              Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50), child: LoginTextForm()),
              SizedBox(height: 10),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/otpRoute'),//registrationRoute
                child: RichText(
                    text: TextSpan(
                        text: "Don't have an account ",
                        style: DefaultTextStyle
                            .of(context)
                            .style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                decoration: TextDecoration.underline,
                                color: myPrimaryColor,
                              ))
                        ])),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: SizedBox(child: Text("or", style: TextStyle(color: Colors.grey),)),
              ),
              Text("Sign in with"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getElevatedButton(Icon(FontAwesomeIcons.google, color: Colors.red), "google", context),
                  SizedBox(width: 5),
                  getElevatedButton(Icon(FontAwesomeIcons.facebook, color: Colors.blue), "facebook", context)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

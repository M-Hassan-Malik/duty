import 'package:duty/components/registration/regFields.dart';
import 'package:duty/provider/SignInProvider.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';

class LoginTextForm extends StatefulWidget {
  const LoginTextForm({Key? key}) : super(key: key);

  static bool validPassword(value) {
    if (value.contains(RegExp(r'[A-Z]')) &&
        value.contains(RegExp(r'[0-9]')) &&
        value.contains(RegExp(r'[a-z]')) &&
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    } else {
      return true;
    }
  }

  @override
  _LoginTextFormState createState() => _LoginTextFormState();
}

class _LoginTextFormState extends State<LoginTextForm> {
  final _formKey = GlobalKey<FormState>();

  bool obscureText = true;
  static String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          getTextFormField(),
          SizedBox(height: 10),
          Stack(
            alignment: const Alignment(0, 0),
            children: <Widget>[
              TextFormField(
                  validator: (value) {
                    if (LoginTextForm.validPassword(value) == true) {
                      return 'Password should be like: Az1*';
                    }
                    password = value!;
                    return null;
                  },
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 12, color: Colors.black),
                    labelText: 'Password',
                  )),
              Positioned(
                  right: 0,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      child: Text(
                        'SHOW',
                        style: TextStyle(fontSize: 10, color: myPrimaryColor),
                      )))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuthenticationProvider object = FirebaseAuthenticationProvider();
                      print(_LoginTextFormState.email + password);
                      String str = await object.signIn(email, password);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(str)));
                      if (str == "logging in...") {
                        Navigator.pushNamed(context, '/homePageRoute');
                      }
                    }
                  },
                  child: Text("Login"),
                  style: ElevatedButton.styleFrom(primary: myPrimaryColor, onPrimary: mySecondaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}

Widget getTextFormField() {
  return TextFormField(
      validator: (value) {
        if (value == null ||
            value.isEmpty &&
                false ==
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return 'Please enter a valid email';
        }
        _LoginTextFormState.email = value;
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 12, color: Colors.black),
        labelText: 'Email',
      ));
}

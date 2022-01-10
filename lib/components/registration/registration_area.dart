import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duty/components/registration/regFields.dart';
import 'package:duty/provider/GoogleAddressProvider.dart';
import 'package:duty/provider/SignInProvider.dart';
import 'package:duty/provider/SignInProvider.dart';
import 'package:duty/provider/url.dart';
import 'package:duty/ui/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RegistrationTextForm extends StatefulWidget {
  const RegistrationTextForm({Key? key}) : super(key: key);

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
  _RegistrationTextFormState createState() => _RegistrationTextFormState();
}

class _RegistrationTextFormState extends State<RegistrationTextForm> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    Map<String, String?> locationAddress;
    GoogleAddressProvider address = new GoogleAddressProvider();
    String userCurrent;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(RegFields.userFields['email']!, overflow: TextOverflow.fade),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: FlutterLogo(size: 100),
                  ),
                  Text(
                    "Registration",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(height: 5),
                  getTextFormField("Name"),
                  SizedBox(height: 5),
                  getTextFormField("Last Name"),
                  SizedBox(height: 5),
                  Stack(
                    alignment: const Alignment(0, 0),
                    children: <Widget>[
                      TextFormField(
                          validator: (value) {
                            if (RegistrationTextForm.validPassword(value) == true) {
                              return 'Password should be like: Az1*';
                            }
                            RegFields.userFields['pass'] = value!;
                            return null;
                          },
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 12),
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
                                style: TextStyle(fontSize: 10),
                              )))
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                      validator: (value) {
                        if (RegistrationTextForm.validPassword(value) == true) {
                          return 'Password should be like: Az1*';
                        } else if (RegFields.userFields['pass'] != value) {
                          return 'Password and Confirm Password should be same';
                        } else {
                          return null;
                        }
                      },
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'Confirm password',
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                          onPressed: () {
                            Map<String, dynamic> body = {
                              "name": "",
                              "email": "",
                              "last_name": "",
                              "password": "",
                              "address": {},
                            };
                            var jsonResponse = Map<String, dynamic>();
                            if (_formKey.currentState!.validate()) {
                              Provider.of<GoogleAddressProvider>(context, listen: false).findCurrentLocation();
                              locationAddress =
                                  Provider.of<GoogleAddressProvider>(context, listen: false).getFullAddress()!;
                              body = {
                                "name": RegFields.userFields['name'],
                                "email": RegFields.userFields['email'],
                                "last_name": RegFields.userFields['lastName'],
                                "password": RegFields.userFields['pass'],
                                "address": convert.jsonEncode(locationAddress),
                              };
                              http.post(Uri.parse('$API_URL/user/signup'), body: body).then((response) => {
                                    if (response.statusCode == 200)
                                      {
                                        jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>,
                                        Navigator.pushNamed(context, '/loginRoute')
                                      }
                                    else if (response.statusCode == 400)
                                      {
                                        jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>,
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text(jsonResponse['error'].toString()))),
                                      }
                                    else
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text("Error Occurred")))
                                  });

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Processing...")));
                              //Navigator.pushNamed(context, '/loginRoute');
                            }
                          },
                          child: Text("Register"),
                          style: ElevatedButton.styleFrom(primary: Colors.blue, onPrimary: Colors.white)),
                    ),
                  ),
                  TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/loginRoute'),
                      child: Text("Already have an account!"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget getTextFormField(String str) {
  return TextFormField(
      validator: (value) {
        switch (str) {
          case "Name":
            {
              if (value == null ||
                  value.isEmpty &&
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                return 'Please enter valid name';
              }
              RegFields.userFields['name'] = value;
              return null;
            }
          case "Last Name":
            {
              if (value == null || value.isEmpty) {
                return 'Please enter valid name';
              }
              RegFields.userFields['lastName'] = value;
              return null;
            }
        } // switch
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 12),
        labelText: str,
      ));
}

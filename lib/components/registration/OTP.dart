import 'package:duty/components/registration/regFields.dart';
import 'package:duty/provider/SignInProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTP extends StatelessWidget {
  OTP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OTPProvider>(builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(children: [
                Container(
                  child: TextField(
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter a valid email",
                        contentPadding: const EdgeInsets.only(right: 80)),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        RegFields.userFields['email'] = value;
                      }
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: ElevatedButton(
                      onPressed: () {
                        value.sendOTP(RegFields.userFields['email']!);
                      },
                      child: Text(
                        "Send OTP",
                        style: TextStyle(fontSize: 8),
                      )),
                ),
              ]),
              SizedBox(height: 10),
              value.clickedOTP
                  ? Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(labelText: "Enter OTP"),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              RegFields.userFields['otp'] = value;
                            }
                          },
                        ),
                        ElevatedButton(
                          child: Text("Verify OTP"),
                          onPressed: () {
                            bool check = value.verifyOTP(RegFields.userFields['otp']!);
                            check == true
                                ? Navigator.pushNamed(context, '/registrationRoute')
                                : ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("Invalid OTP code")));
                          },
                        )
                      ],
                    )
                  : Text(value.validEmail)
            ],
          ),
        );
      }),
    );
  }
}

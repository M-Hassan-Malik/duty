import 'package:duty/provider/GoogleAddressProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class StepperProviderContinuity extends ChangeNotifier {

  void addTask(BuildContext context) {
    Provider.of<GoogleAddressProvider>(context, listen: false).getCurrentAddress();
    var locationAddress = Provider.of<GoogleAddressProvider>(context, listen: false).getFullAddress()!;
    var jsonResponse = new Map<String, dynamic>();


    var userCurrent = FirebaseAuth.instance.currentUser!.uid;
    DataHolder.dataHolder['uid'] = userCurrent;
    DataHolder.dataHolder['city'] = locationAddress['city'];
    DataHolder.dataHolder['country'] = locationAddress['country'];

    http.post(Uri.parse('https://hello.loca.lt/duty/setDuty'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    body: convert.jsonEncode(DataHolder.dataHolder)).then((response) => {
      if (response.statusCode == 200)
        {
          jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>,
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
  }

  bool _continue = false;
  int _currentStep = 0;
  bool _complete = false;

  int get currentStep => _currentStep;

  bool get complete => _complete;

  bool get getContinuityValidation => _continue;

  void goTo(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void setContinuityTrue() {
    print("true chali");
    _continue = true;
    notifyListeners();
  }

  void setContinuityFalse() {
    print("false chali");
    _continue = false;
    notifyListeners();
  }

  void next(int stepLength, BuildContext context) {
    if (_currentStep != stepLength - 1) {
      goTo(_currentStep + 1);
    } else {
      _complete = true;
      addTask(context);
      _currentStep = 0; // When next time new post is add so it will start from 0'th Step.
      Navigator.pop(context); // go to main screen
    }
    notifyListeners();
  }

  void cancel() {
    if (_currentStep > 0) goTo(_currentStep - 1);
    notifyListeners();
  }

  void titleDisposer(TextEditingController ctrl) {
    ctrl.dispose();
  }
}

class DataHolder {
  static Map<String, dynamic> dataHolder = {
    "uid": "",
    "title": "",
    "description": "",
    "place": {},
    "address": "",
    "city": "",
    "country": "",
    "date": "",
    "createdOn": "",
    "person": 0,
    "payment": 0,
    "done": 0,
    "Offers": "",
    "Comments": "",
  };
}

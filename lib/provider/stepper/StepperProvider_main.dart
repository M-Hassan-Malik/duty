import 'package:duty/components/storage.dart';
import 'package:duty/provider/stepper/StepperProvider_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class StepperProviderContinuity extends ChangeNotifier {
  Future<bool> addTask(BuildContext context) async {
    var locationAddress = Provider.of<StepperProviderLocation>(context, listen: false).getFullAddress()!;
    var jsonResponse = new Map<String, dynamic>();

    DataHolder.dataHolder['uid'] = UserStorage.currentUserId;
    DataHolder.dataHolder['city'] = locationAddress['city'];
    DataHolder.dataHolder['country'] = locationAddress['country'];

    final response = await http.post(Uri.parse('https://newoneder.loca.lt/duty/setDuty'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(DataHolder.dataHolder));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Duty published.")));
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return true;
    } else if (response.statusCode == 400) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonResponse['error'].toString())));
      return false;
    } else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Occurred")));
    return false;
  } //addTask()

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
      addTask(context).then((value) {
        if (value == true) {
          _currentStep = 0; // When next time new post is add so it will start from 0'th Step.
          Navigator.pop(context); // go to main screen
        }
      });
    }
    notifyListeners();
  }

  void cancel() {
    if (_currentStep > 0) goTo(_currentStep - 1);
    notifyListeners();
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

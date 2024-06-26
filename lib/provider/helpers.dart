import 'package:flutter/material.dart';

class Helper extends ChangeNotifier {
  int stepperIndex = 1;
  String _userType = "";

  int get getStepperIndex => stepperIndex;

  String get getUserType => _userType;

  setStepperIndex(int index) {
    stepperIndex = index;
    notifyListeners();
  }

  void setUserType(int userType) {
    userType == 0 ? _userType = 'customer' : _userType = 'worker';
    stepperIndex = 1;
    notifyListeners();
  }
}

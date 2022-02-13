import 'package:flutter/material.dart';

class Helper extends ChangeNotifier{
  int stepperIndex = 2;
  String _userType = "";
  int get getStepperIndex => stepperIndex;
  String get getUserType => _userType;

  setStepperIndex (int index){
    stepperIndex = index;
    notifyListeners();
  }

  void setUserType (int userType){
    userType == 1 ? _userType = 'customer'  :  _userType = 'worker';
    notifyListeners();
  }

}
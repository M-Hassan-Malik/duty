import 'package:flutter/material.dart';

class Helper extends ChangeNotifier{
  int stepperIndex = 2;

  int get getStepperIndex => stepperIndex;

  setStepperIndex (int index){
    stepperIndex = index;
    notifyListeners();
  }
}
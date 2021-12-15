import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duty/provider/stepper/StepperProvider_main.dart';
import 'package:duty/theme.dart';
import 'package:duty/ui/post_duty/step_1.dart';
import 'package:duty/ui/post_duty/step_2.dart';
import 'package:duty/ui/post_duty/step_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostingDuty extends StatelessWidget {
  final name;

  PostingDuty({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int activeStep = Provider.of<StepperProviderContinuity>(context, listen: true).currentStep;

    final List<Step> mySteps = [
      Step(
          title: const Text("Task Details"),
          isActive: activeStep == 0 ? true : false,
          state: StepState.indexed,
          content: StepForm(name: name)),
      Step(
          title: const Text("Task Location"),
          isActive: activeStep == 1 ? true : false,
          state: StepState.indexed,
          content: LocationAndTime()),
      Step(
          title: const Text("Task Standards"),
          isActive: activeStep == 2 ? true : false,
          state: StepState.indexed,
          content: StepperProviderBilling())
    ];

    return WillPopScope(
      onWillPop: () async {
        if (activeStep != 0) {
          Provider.of<StepperProviderContinuity>(context, listen: false).cancel();
          return false;
        } else
          return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Post Duty"),
          backgroundColor: myPrimaryColor,
          foregroundColor: mySecondaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Consumer<StepperProviderContinuity>(builder: (context, value, child) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Theme(
                      data: ThemeData(colorScheme: ColorScheme.light(primary: myPrimaryColor)),
                      child: Stepper(
                          steps: mySteps,
                          type: StepperType.vertical,
                          currentStep: value.currentStep,
                          onStepContinue: value.getContinuityValidation == true
                              ? () {
                                  value.next(mySteps.length, context);
                                  value.setContinuityFalse();
                                }
                              : null,
                          onStepCancel: value.cancel,
                          onStepTapped: (step) => value.goTo(step)),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

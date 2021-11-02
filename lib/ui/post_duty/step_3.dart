import 'package:duty/provider/stepper/StepperProvider_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepperProviderBilling extends StatelessWidget {
  StepperProviderBilling({Key? key}) : super(key: key);

  final _peopleController = TextEditingController();
  final _paymentController = TextEditingController();

  finalize(BuildContext context) => _paymentController.text.isNotEmpty && _peopleController.text.isNotEmpty
      ? {
          DataHolder.dataHolder["person"] = _peopleController.text,
          DataHolder.dataHolder["payment"] =  _paymentController.text,
          Provider.of<StepperProviderContinuity>(context, listen: false).setContinuityTrue(),
        }
      : print("false 3rd step");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _peopleController,
          onChanged: (String empty) {
            _peopleController.text.isNotEmpty == true ? finalize(context) : print("empty ha People");
          },
          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
          decoration: InputDecoration(
            hintMaxLines: 4,
            hintText: "How many Person('s) are required for the Task?\n\nEnter a number only",
          ),
        ),
        TextField(
          controller: _paymentController,
          onChanged: (String empty) {
            _paymentController.text.isNotEmpty == true ? finalize(context) : print("empty ha Payment");
          },
          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
          decoration: InputDecoration(
            hintMaxLines: 4,
            hintText: "How much you want to Pay for the task?",
          ),
        ),
      ],
    );
  }
}

import 'package:duty/provider/stepper/StepperProvider_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepperProviderBilling extends StatefulWidget {
  const StepperProviderBilling({Key? key}) : super(key: key);

  @override
  _StepperProviderBillingState createState() => _StepperProviderBillingState();
}

class _StepperProviderBillingState extends State<StepperProviderBilling> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Text("How many people required for this work?"),
            TextFormField(
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                decoration: InputDecoration(
                  hintText: "e.g: 1"
                ),
                onChanged: (text) {
                  _validateForm(_formKey, context);
                },
                validator: (value) {
                  if (!value!.isEmpty && isNumeric(value) == true) {
                    if (int.parse(value) < 1) {
                      return "Person cannot be 0";
                    }
                    DataHolder.dataHolder["person"] = value;
                    return null;
                  } else
                    return "Empty or wrong input";
                }),
            Text("How much you want to pay for this work?"),
            TextFormField(
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                decoration: InputDecoration(
                    hintText: "e.g: 100\$"
                ),
                onChanged: (text) {
                  _validateForm(_formKey, context);
                },
                validator: (value) {
                  if (!value!.isEmpty && isNumeric(value) == true) {
                    if (int.parse(value) < 100) {
                      return "Payment must be at least 100";
                    }

                    DataHolder.dataHolder["payment"] = value;
                    return null;
                  } else
                    return "Empty or wrong input";
                }),
          ],
        ));
  }
}
bool isNumeric(String value) {
  try {
    return int.tryParse(value) == null ? false : true; // int.tryParse() returns null when value is not integer
  } catch (e) {
    return false;
  }
}

_validateForm(formKey, BuildContext context) {
  if (formKey.currentState!.validate()) {
    Provider.of<StepperProviderContinuity>(context, listen: false).setContinuityTrue();
  } else
    Provider.of<StepperProviderContinuity>(context, listen: false).getContinuityValidation
        ? Provider.of<StepperProviderContinuity>(context, listen: false).setContinuityFalse()
        : "";
}


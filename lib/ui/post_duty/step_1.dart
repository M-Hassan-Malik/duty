import 'package:duty/provider/stepper/StepperProvider_main.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepForm extends StatefulWidget {
  final name;

  const StepForm({Key? key, required this.name}) : super(key: key);

  @override
  _StepFormState createState() => _StepFormState();
}

class _StepFormState extends State<StepForm> {
  final _formKey = GlobalKey<FormState>();

  String title = "", description = "";

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                minLines: 1,
                maxLines: 2,
                readOnly: true,
                initialValue: widget.name,
                onChanged: (text) {
                  _validateForm(_formKey, context);
                },
                validator: (value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Title should be at least 3 characters";
                  }
                  DataHolder.dataHolder["title"] = value;
                  return null;
                }),
            TextFormField(
                minLines: 1,
                maxLines: 20,
                onChanged: (text) {
                  _validateForm(_formKey, context);
                },
                validator: (value) {
                  if (value!.isEmpty || value.length < 30) {
                    return "Write at least 30 characters about";
                  }
                  DataHolder.dataHolder["description"] = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Add Description",
                )),
          ],
        ));
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

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

  String title="",description="";

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              minLines: 1, maxLines: 2,
                readOnly: true,
                initialValue: widget.name,
                validator: (value) {
                  if (value == null || value.isEmpty && value.length < 3 ) {
                    return "Title should be at least 3 characters";
                  }
                  title= value;
                  return null;
                }),
            TextFormField(
                minLines: 1,
                maxLines: 20,
                validator: (value) {
                  if (value == null || value.isEmpty && value.length < 30 ) {
                      return "Write at least 30 characters about";
                  }
                  description = value;
                  return null;
                },
                decoration: InputDecoration(hintText: "Add Description",
                )),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<StepperProviderContinuity>(context, listen: false).setContinuityTrue();
                    DataHolder.dataHolder["title"] = title;
                    DataHolder.dataHolder["description"] = description;
                  }
                },
                child: Text("Validate Form"))
          ],
        ));
  }
}

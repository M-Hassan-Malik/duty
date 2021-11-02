import 'package:intl/intl.dart';
import 'package:duty/provider/stepper/StepperProvider_main.dart';
import 'package:duty/provider/stepper/StepperProvider_2.dart';
import 'package:duty/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';

class LocationAndTime extends StatefulWidget {
  const LocationAndTime({Key? key}) : super(key: key);

  @override
  _LocationAndTimeState createState() => _LocationAndTimeState();
}

class _LocationAndTimeState extends State<LocationAndTime> {
  Map<String, dynamic> latLng = {};

  Color locationButton =  myPrimaryColor;
  Color onlineButton = Colors.grey;

  updateDisableColor(int id) {
    setState(() {
      if (id == 0) {
        locationButton = myPrimaryColor;
        onlineButton =Colors.grey;
      } else {
        onlineButton = myPrimaryColor;
        locationButton = Colors.grey;
      }
    });
  }

  setContinuityTrue() => Provider.of<StepperProviderContinuity>(context, listen: false).setContinuityTrue();

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context, initialDate: selectedDate, firstDate: DateTime(2021, 4), lastDate: DateTime(2101));

      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          DataHolder.dataHolder['date'] = dateFormat.format(picked);
        });
    }

    return Consumer<StepperProviderLocation>(builder: (context, value, child) {
      return Column(children: [
        Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                  icon: Icon(Icons.location_on, size: (35.0)),
                  onPressed: () {
                    value.getCurrentAddress();
                    var pos = value.position;
                    latLng = {
                      "lat": pos.latitude,
                      "lng": pos.longitude,
                    };
                    value.getCoordinatesFromPosition(Coordinates(pos.latitude, pos.longitude));
                    updateDisableColor(0);
                    value.updateAddress = true;
                    setContinuityTrue();
                    DataHolder.dataHolder["place"] = latLng;
                  },
                  color: locationButton,
                  tooltip: "Set Current Location"),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                  icon: Icon(Icons.vpn_lock , size: (30.0)),
                  onPressed: () {
                    updateDisableColor(1);
                    value.updateAddress = false;
                    setContinuityTrue();
                    DataHolder.dataHolder['address'] = "online";
                  },
                  tooltip: "Set Online Task",
                  color: onlineButton),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0, bottom: 10),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: myPrimaryColor),
          child: Text(
            value.updateAddress ? '${value.getAddress()}' : "The task is set to online",
            style: TextStyle(color: mySecondaryColor),
          ),
        ),
        Divider(thickness: 5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${selectedDate.toLocal()}".split(' ')[0]),
        ),
        ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select date'),
            style: ElevatedButton.styleFrom(primary: Colors.grey, onPrimary: Colors.white)),
      ]);
    });
  }
}

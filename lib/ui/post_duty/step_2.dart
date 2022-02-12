import 'package:duty/provider/GoogleAddressProvider.dart';
import 'package:intl/intl.dart';
import 'package:duty/provider/stepper/StepperProvider_main.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationAndTime extends StatefulWidget {
  const LocationAndTime({Key? key}) : super(key: key);

  @override
  _LocationAndTimeState createState() => _LocationAndTimeState();
}

class _LocationAndTimeState extends State<LocationAndTime> {
  String _msgBox = "Select service type, please!";
  Color _selectDateColor = Colors.grey;
  Map<String, dynamic> latLng = {};

  Color locationButton = mySecondaryColor;
  Color onlineButton = mySecondaryColor;

  updateDisableColor(int id) {
    setState(() {
      if (id == 0) {
        locationButton = myPrimaryColor;
        onlineButton = mySecondaryColor;
      } else {
        onlineButton = myPrimaryColor;
        locationButton = mySecondaryColor;
      }
    });
  }

  setContinuityTrue() => Provider.of<StepperProviderContinuity>(context, listen: false).setContinuityTrue();

  /*void _setLocationButton(value) {
    var pos = null;
    pos = value.position;
    if (pos != null) {
      latLng = {
        "lat": pos.latitude,
        "lng": pos.longitude,
      };
      value.getCoordinatesFromPosition(Coordinates(pos.latitude, pos.longitude));
      updateDisableColor(0);
      value.onlineDuty = true;
      setContinuityTrue();
      DataHolder.dataHolder["place"] = latLng;
    } else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Re-tap on Location button, Please. Cannot get your location.")));
  }*/

  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2021, 4), lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _selectDateColor = myPrimaryColor;
      });
      DataHolder.dataHolder['date'] = dateFormat.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoogleAddressProvider>(builder: (context, value, child) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: InkWell(
                onTap: () {
                  value.getCurrentAddress();
                  var pos = value.getPosition;
                  if(pos != null) {
                    latLng = {
                      "lat": pos.latitude,
                      "lng": pos.longitude,
                    };
                    value.getCoordinatesFromPositionB(pos.latitude, pos.longitude);
                    updateDisableColor(0);
                    value.onlineDuty = true;
                    setContinuityTrue();
                    DataHolder.dataHolder["place"] = latLng;
                  }
                },
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.black), color: locationButton),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Location"),
                        Icon(Icons.location_on, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.0),
            Flexible(
              fit: FlexFit.tight,
              child: InkWell(
                onTap: () {
                  updateDisableColor(1);
                  value.onlineDuty = false;
                  setContinuityTrue();
                  DataHolder.dataHolder['address'] = "online";
                  _msgBox = "The duty is Online";
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.black), color: onlineButton),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Online"),
                        Icon(
                          Icons.vpn_lock,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
         Container(
          margin: const EdgeInsets.only(top: 15.0, bottom: 10),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: myPrimaryColor),
          child: Text(
            value.onlineDuty ? '${value.getFullAddress()!['address']}' : _msgBox,
            style: TextStyle(color: mySecondaryColor),
          ),
        ),
        Divider(thickness: 5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${selectedDate.toLocal()}".split(' ')[0],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select date'),
            style: ElevatedButton.styleFrom(primary: _selectDateColor, onPrimary: Colors.white)),
      ]);
    });
  }
}

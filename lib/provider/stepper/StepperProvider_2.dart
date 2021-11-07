import 'package:duty/provider/stepper/StepperProvider_main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class StepperProviderLocation extends ChangeNotifier {

  String? _address;
  var _position;
  bool updateAddress = false;

  Position get position => _position;

  String getAddress() {
    if (_address == null ) {
      return "Couldn't find the address, tap button again";
    } else {
      DataHolder.dataHolder["address"] = _address;
      return _address!;
    }
  }

  void getCurrentAddress() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((value) {
      _position = value;
      notifyListeners();
    });
  }

  //getCoordinatesFromPosition(Coordinates(position.latitude, position.longitude));

  void getCoordinatesFromPosition(Coordinates coordinates) async {
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = address.first;
    _address = first.addressLine;
    notifyListeners();
  }
}

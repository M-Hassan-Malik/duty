import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class StepperProviderLocation extends ChangeNotifier {
  String? _address;
  late Position _position;
  bool isUpdateAddress = false;

  Position get position => _position;

  String getAddress() {
    if (_address == null ) {
      return "";
    } else {
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

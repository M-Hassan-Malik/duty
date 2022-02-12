import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:duty/provider/stepper/StepperProvider_main.dart';

class GoogleAddressProvider extends ChangeNotifier {
  Placemark? _first;
  Position? _position;
  bool onlineDuty = false;

  Position? get getPosition => _position ??= null;

  Map<String, String?>? getFullAddress() {
    if (_first == null) {
      return {"address": 'not found'};
    } else {
      var detailedAddress =
          "${_first!.street.toString() + ", " + _first!.subLocality.toString() + ", " + _first!.locality.toString() + ", " + _first!.subAdministrativeArea.toString() + ", " + _first!.administrativeArea.toString() + ", " + _first!.country.toString() + "."}";
      DataHolder.dataHolder["address"] = detailedAddress;
      return {
        "address": detailedAddress,
        "city": _first!.subAdministrativeArea,
        "country": _first!.country,
      };
    }
  }

  void getCurrentAddress() async {
    _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    getCoordinatesFromPositionB(_position!.latitude, _position!.longitude);
    notifyListeners();
  }

  void getCoordinatesFromPositionB(double lat, double lng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
    try {
      _first = placeMarks.first;
      notifyListeners();
    } catch (e) {
      print("catch-block @getCoordinatesFromPosition: ${e.toString()}");
    }
  }

  findCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(position.toString());
    //getCoordinatesFromPositionB(Coordinates(position.latitude, position.longitude));
    notifyListeners();
  }
}

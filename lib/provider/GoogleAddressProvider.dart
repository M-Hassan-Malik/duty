import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class GoogleAddressProvider extends ChangeNotifier {
  String? _locality;
  Address? _first;

  Map<String, String?>? getFullAddress() {
    if (_first == null) {
      return {"address": 'not found'};
    } else {
      return {"address": _first!.addressLine,
        "city": _first!.subAdminArea,
        "country": _first!.countryName,

      };
    }
  }

  String getLocality() {
    if (_locality == null) {
      return "Press Again";
    } else {
      return _locality!;
    }
  }

  getCurrentAddress() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(position);
    getCoordinatesFromPosition(Coordinates(position.latitude, position.longitude));
    notifyListeners();
  }

  getCoordinatesFromPosition(Coordinates coords) async {
    var address = await Geocoder.local.findAddressesFromCoordinates(coords);
    _first = address.first;
    _locality = _first?.subAdminArea;
    notifyListeners();
  }
}

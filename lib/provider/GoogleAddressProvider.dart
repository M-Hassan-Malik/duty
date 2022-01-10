import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


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

  findCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    getCoordinatesFromPosition(Coordinates(position.latitude, position.longitude));
    print(position.toString());
    notifyListeners();
  }

  getCoordinatesFromPosition(Coordinates coords) async {
//    getCoordinatesFromPositionB(coords);
    var address = await Geocoder.local.findAddressesFromCoordinates(coords);
    _first = address.first;
    _locality = _first?.subAdminArea;
    notifyListeners();
  }

  getCoordinatesFromPositionB(Coordinates coords) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(coords.latitude, coords.longitude);
    try{
      print(placeMarks.first.locality);
      print(placeMarks.first.subLocality);
      print(placeMarks.first.administrativeArea);
      print(placeMarks.first.subAdministrativeArea);
      print(placeMarks.first.country);
      print(placeMarks.first.street);
      print(placeMarks.first.thoroughfare);
      print(placeMarks.first.name);
      notifyListeners();
    }catch(e){
      print("catch-block @getCoordinatesFromPosition: ${e.toString()}");
    }
  }
}

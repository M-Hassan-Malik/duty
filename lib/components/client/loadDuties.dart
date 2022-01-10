import 'dart:convert' as convert;
import 'package:duty/components/storage.dart';
import 'package:duty/provider/GoogleAddressProvider.dart';
import 'package:duty/provider/url.dart';
import 'package:http/http.dart' as http;
import 'package:duty/theme.dart';
import 'package:duty/components/client/getDuties.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadDuty extends StatefulWidget {
  final myDuty;

  const LoadDuty({Key? key, required this.myDuty}) : super(key: key);

  @override
  _LoadDutyState createState() => _LoadDutyState();
}

class _LoadDutyState extends State<LoadDuty> {
    var response;

  _getStatusError(int responseCode,BuildContext context) {
    responseCode == 400 ?
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("response.statusCode:400: Error Occurred"))) :
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Occurred")));
  }

  late ScrollController _chatScrollController;
  int _perPage = 10,
      _increment = 10;
  String userCurrent = "";
  var data;

  void initState() {
    _chatScrollController = ScrollController()
      ..addListener(() {
        if (_chatScrollController.position.atEdge) {
          if (_chatScrollController.position.pixels == 0)
            print('ListView scrolled to top');
          else {
            setState(() {
              _perPage += _increment;
            });
            print('ListView scrolled to bottom');
          }
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _chatScrollController.dispose();
    super.dispose();
  }

  Future _getDuties() async {
    print("_getDuty");
    try {

      response = await http.get(Uri.parse('$API_URL/duty/getDuty'));
      if (response.statusCode == 200) {
        var result = convert.jsonDecode(response.body) as Map<String, dynamic>;
        return result;
      } else if (response.statusCode == 400) {
        _getStatusError(400,context);
        return null;
      }
      else {
        _getStatusError(0,context);
        return null;
      }
    } catch (e) {
      print("try caught: $e");
      return null;
    }
  }

  Future _getMyDuties(BuildContext context) async {
    print("getMYDuty");
    try {
      var provider = Provider.of<GoogleAddressProvider>(context, listen: false);
      await provider.findCurrentLocation();
      Map<String, String?>? locationAddress = await provider.getFullAddress()!;
      if (locationAddress['city'] != null && locationAddress['country'] != null) {
        print("$API_URL : ${locationAddress.toString()}");
        response = await http.post(Uri.parse('$API_URL/user/getDuty'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: convert.jsonEncode({
              "uid" : UserStorage.currentUserId,
              "city" :locationAddress['city'],
              "country" :locationAddress['country'],
            }));
        if (response.statusCode == 200) {
          var result = convert.jsonDecode(response.body) as Map<String, dynamic>;
          return result;
        } else if (response.statusCode == 400) {
          _getStatusError(400,context);
          return null;
        } else {
          _getStatusError(0,context);
          return null;
        }
      }
    } catch (e) {
      print("try caught: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    userCurrent = UserStorage.currentUserId;
    return Scaffold(

    body: FutureBuilder(
          future: widget.myDuty ? _getMyDuties(context) : _getDuties(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasError && snapshot.data != null) {
              data = snapshot.data['result'];
              return ListView.builder(
                  controller: _chatScrollController,
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 8.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GetFullDetailsOfDuty(doc: data[i]['docData'], docId: data[i]['docId'])));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.8,
                                  decoration: BoxDecoration(
                                    color: myTertiaryColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: myTertiaryColor,
                                        offset: Offset(-3.0, 3.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0, left: 40),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                            child: Text(
                                              data[i]['docData']['duty']['title'],
                                              style: TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold,
                                                  color: myPrimaryColor),
                                            )),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                            ),
                                            Container(
                                                width: 190,
                                                child: Text(
                                                  data[i]['docData']['duty']['address'],
                                                  style: TextStyle(overflow: TextOverflow.ellipsis),
                                                )),
                                          ],
                                        ),
                                        Divider(thickness: 2),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("2 Offers", style: TextStyle(fontSize: 8)),
                                                  Text("3 Comments", style: TextStyle(fontSize: 8)),
                                                ],
                                              ),
                                              SizedBox(width: 1),
                                              Flexible(
                                                child: Text(
                                                    "Payment: " +
                                                        data[i]['docData']['duty']['payment'].toString() +
                                                        "/-",
                                                    style: TextStyle(fontSize: 15.0)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.account_circle,
                                    color: myPrimaryColor,
                                    size: 100,
                                  )),
                            ],
                          )),
                    );
                  });
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

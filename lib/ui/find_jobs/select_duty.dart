import 'dart:convert' as convert;
import 'package:duty/components/storage.dart';
import 'package:duty/provider/url.dart';
import 'package:http/http.dart' as http;
import 'package:duty/theme.dart';
import 'package:duty/ui/find_jobs/get_duty.dart';
import 'package:flutter/material.dart';
import 'package:duty/provider/GoogleAddressProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class FindDuty extends StatefulWidget {
  const FindDuty({Key? key}) : super(key: key);

  @override
  _FindDutyState createState() => _FindDutyState();
}

class _FindDutyState extends State<FindDuty> {
  late ScrollController _chatScrollController;
  int _perPage = 10, _increment = 10;
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
    try {
      var response = await http.get(Uri.parse('$API_URL/duty/getDuty'));
      if (response.statusCode == 200) {
        var result = convert.jsonDecode(response.body) as Map<String, dynamic>;
        return result;
      } else if (response.statusCode == 400) {
        return null;
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
          future: _getDuties(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasError && snapshot.data != null) {
              data = snapshot.data['result'];
              return ListView.builder(
                  controller: _chatScrollController,
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0,top: 8.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => GetFullDetailsOfDuty(doc: data[i]['docData'],docId: data[i]['docId'] )));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
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
                                                child: Text("Payment: " + data[i]['docData']['duty']['payment'].toString() + "/-",
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

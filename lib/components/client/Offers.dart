import 'dart:async';

import 'package:duty/components/client/getDuties.dart';
import 'package:duty/provider/helpers.dart';
import 'package:duty/provider/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:duty/theme.dart';
import 'package:duty/components/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class Offers extends StatefulWidget {
  final details;

  const Offers({Key? key, required this.details}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  final ScrollController _controllerOne = ScrollController();

  @override
  Widget build(BuildContext context) {
    final offers;
    var jsonResponse;
    return FutureBuilder(
      future: _getOffers(context, widget.details),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var data = snapshot.data;
        return ListView.builder(
            controller: _controllerOne,
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (Stack(
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
                            child: InkWell(
                              onTap: () => (showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Long-presses to visit profile."),
                                      ))),
                              onLongPress: () => print("duty long presses"),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(child: Text("Verification")),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                      Icon(Icons.email_outlined, color: myPrimaryColor),
                                      Icon(Icons.smartphone_outlined, color: myPrimaryColor),
                                      Icon(Icons.perm_identity_outlined, color: myPrimaryColor),
                                      Icon(Icons.credit_card_outlined, color: myPrimaryColor),
                                    ]),
                                  ),
                                  Divider(thickness: 5),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 100.0,
                                              child: Text("${data[i]["offeredMoney"]}",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15.0,
                                                      overflow: TextOverflow.fade)),
                                            ),
                                            Row(children: [
                                              Text("Rating: "),
                                              RatingBarIndicator(
                                                  rating: 2.5,
                                                  itemSize: 20,
                                                  physics: BouncingScrollPhysics(),
                                                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber))
                                            ]),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Yesterday", style: TextStyle(fontSize: 8.0)),
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0), color: Colors.green),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                                                  child: Text("100%", style: TextStyle(fontSize: 8.0)),
                                                )),
                                            Text("Completion Rate", style: TextStyle(fontSize: 8.0)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.details['status'] == 0
                                      ? Visibility(
                                          visible: UserStorage.currentUserId == widget.details['uid'],
                                          child: InkWell(
                                            onTap: () async {
                                              (showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                        title: Text("Accept offer, Confirm?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () async {
                                                              jsonResponse =
                                                                  await http.post(Uri.parse('$API_URL/duty/assignDuty'),
                                                                      headers: <String, String>{
                                                                        'Content-Type':
                                                                            'application/json; charset=UTF-8',
                                                                      },
                                                                      body: convert.jsonEncode({
                                                                        "status": 1,
                                                                        "workerId": data[i]["offeredBy"],
                                                                        "offeredMoney": data[i]['offeredMoney'],
                                                                        "city": widget.details['city'],
                                                                        "country": widget.details['country'],
                                                                        "docId": widget.details,
                                                                      }));
                                                              Navigator.pop(context);
                                                              if (jsonResponse.statusCode == 200) {
                                                                Navigator.pop(context);
                                                                Provider.of<Helper>(context, listen: false)
                                                                    .setStepperIndex(1);
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: Text("Offer Accepted")));
                                                              } else if (jsonResponse.statusCode == 400) {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                    content: Text("Server: Something went wrong.")));
                                                              } else {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: Text("Error Occurred")));
                                                              }
                                                            },
                                                            child: Text("Accept!"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: Text("No"),
                                                          ),
                                                        ],
                                                      )));
                                            },
                                            child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                                child: Center(
                                                    child: Text(
                                                  "Accept Offer ✓",
                                                  style: TextStyle(color: Colors.white),
                                                ))),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
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
                ));
      },
    );
  }
}
// helper Methods

Future _getOffers(BuildContext context, dynamic details) async {
  Map<String, dynamic> jsonResponse = new Map<String, dynamic>();
  try {
    final response = await http.post(Uri.parse('$API_URL/duty/getOffers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode({
          "docId": details['docId'],
          "city": details['city'],
          "country": details['country'],
        }));
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse['result'];
    } else if (response.statusCode == 400) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonResponse['error'])));
      return null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error while connecting to server ❌")));
      return null;
    }
  } catch (e) {
    print('try catch error: $e');
    return null;
  }
}

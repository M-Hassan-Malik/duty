import 'package:duty/components/storage.dart';
import 'package:duty/provider/url.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class makeOffer extends StatefulWidget {
  final userData, docId,userName;

  const makeOffer({Key? key, required this.userData, required this.docId,required this.userName}) : super(key: key);

  @override
  _makeOfferState createState() => _makeOfferState();
}

class _makeOfferState extends State<makeOffer> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> jsonResponse = Map<String, dynamic>();
  int _offerMoney = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Offer'),
        backgroundColor: myPrimaryColor,
      ),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.2,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(color: myTertiaryColor, borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Client Budget is: Rs ${widget.userData['duty']['payment']}/-"),
              Stack(children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black), hintText: 'Enter amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null && value!.isEmpty) {
                        return "Value shouldn't be empty.";
                      } else
                        _offerMoney = int.parse(value);
                      return null;
                    },
                  ),
                ),
                Positioned(
                    right: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: myPrimaryColor,
                        onPrimary: mySecondaryColor,
                      ),
                      child: Text("Send My offer"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          http
                              .post(Uri.parse('$API_URL/duty/addOffer'),
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                              body: convert.jsonEncode(<String, dynamic>{
                                'byUser': UserStorage.currentUserId,
                                'userName': widget.userName,
                                'offer': _offerMoney,
                                'toDuty': widget.docId,
                                'country': widget.userData['duty']['country'],
                                'city': widget.userData['duty']['city'],
                              }))
                              .then((response) =>
                          {
                            if (response.statusCode == 200)
                              {
                                jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>,
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("Offer Submitted, will me available soon"))),
                                Navigator.pop(context)
                              }
                            else
                              if (response.statusCode == 400)
                                {
                                  jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>,
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text(jsonResponse['error'])))
                                }
                              else
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("Error Occurred")))
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Please enter valid digit(s)")));
                        }
                      },
                    ))
              ])
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duty/components/client/Offers.dart';
import 'package:duty/components/client/comment.dart';
import 'package:duty/components/client/makeOffer.dart';
import 'package:duty/components/storage.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';

Padding getFirstRow(int? status) {
  return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Available",
            style: TextStyle(
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationThickness: 10,
                decorationColor: status! >= 0 ? Color(0xff14dc99) : myTertiaryColor)),
          ),


      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Assigned",
            style: TextStyle(
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationThickness: 10,
                decorationColor: status >= 1 ? Color(0xff14dc99) : myTertiaryColor)),
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Completed",
            style: TextStyle(
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationThickness: 10,
                decorationColor: status >= 2 ? Color(0xff14dc99) : myTertiaryColor)),
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Reviewed",
            style: TextStyle(
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationThickness: 10,
                decorationColor: status == 3 ? Color(0xff14dc99) : myTertiaryColor)),
      )
  ],
  )
  ,
  );
}

Container getClientCard(BuildContext context, dynamic userData) {
  TextButton getBtn() {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      backgroundColor: mySecondaryColor,
    );
    return TextButton(
      style: flatButtonStyle,
      onPressed: () => MapsLauncher.launchCoordinates(userData['place']['lat'], userData['place']['lng']),
      child: Text('Visit Location', style: TextStyle(color: myPrimaryColor)),
    );
  }

  String getTimePassed() {
    DateTime timestampToDateTime = DateTime.fromMillisecondsSinceEpoch(userData['createdOn']['_seconds'] * 1000);
    DateTime from = timestampToDateTime;
    DateTime to = DateTime.now();

    int time = (to
        .difference(from)
        .inHours);
    if (time < 24 && time > 0) {
      return time > 1 ? time.toString() + " hours ago" : time.toString() + " hour ago";
    } else {
      return (to
          .difference(from)
          .inDays) > 23
          ? (to
          .difference(from)
          .inDays).toString() + " Days ago"
          : (to
          .difference(from)
          .inDays).toString() + " Day ago";
    }
  }

  return Container(
    decoration: BoxDecoration(color: myTertiaryColor, borderRadius: BorderRadius.circular(10.0), boxShadow: [
      BoxShadow(
        color: Colors.grey,
        offset: Offset(0.0, 1.0), //(x,y)
        blurRadius: 6.0,
      ),
    ]),
    width: MediaQuery
        .of(context)
        .size
        .width,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(children: <Widget>[
        Text(
          userData['title'],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        Divider(color: myPrimaryColor),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(Icons.person, color: Colors.green),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text(
                    "Posted by",
                    style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userData['title'],
                    textAlign: TextAlign.left,
                    style: TextStyle(color: myPrimaryColor, fontWeight: FontWeight.bold),
                  )
                ])
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    getTimePassed(),
                    style: TextStyle(color: Colors.black),
                  )),
            ) // 1 Day ago,3 Days ago
          ],
        ),
        Divider(color: myPrimaryColor),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text(
                    "Address",
                    style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.35,
                    child: Text(
                      userData['address'],
                      style: TextStyle(color: myPrimaryColor, fontSize: 10),
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.left,
                    ),
                  )
                ])
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Align(alignment: Alignment.centerRight, child: getBtn()),
            ),
          ],
        ),
        Divider(color: myPrimaryColor),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Due",
              style: TextStyle(color: myPrimaryColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              DateTime
                  .fromMillisecondsSinceEpoch(userData['date']['_seconds'] * 1000)
                  .toString()
                  .split(" ")
                  .first,
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ]),
    ),
  );
}

Container getMakeOfferCard(BuildContext context, dynamic userData, String docId) {
  return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(color: myPrimaryColor, borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(text: 'Offered Duty Budget\n', children: <TextSpan>[
                  TextSpan(
                      text: userData['duty']['payment'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          foreground: Paint()
                            ..shader = (LinearGradient(
                              colors: <Color>[Color(0xffD4Af37), Color(0xfff6f3a6)],
                            ).createShader(
                              Rect.fromLTWH(20.0, 47.0, 10.0, 60.0),
                            )))),
                ])),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: mySecondaryColor),
              child: Text("Make your offer?", style: TextStyle(color: myPrimaryColor)),
              onPressed: () {
                UserStorage.readGoogleUser('name').then((name) =>
                {
                  if (name != null)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => makeOffer(userData: userData, docId: docId, userName: name)),
                      )
                    }
                  else
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Can't find your google Username. Please 'Sign-in' again.")))
                });
              },
            ),
          ],
        ),
      ));
}

Container getDutyDetails(BuildContext context, dynamic userData) {
  return Container(
    width: MediaQuery
        .of(context)
        .size
        .width,
    decoration: BoxDecoration(color: myTertiaryColor, borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        userData['description'],
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
} //GetDutiesDetails

Widget getOffers( Map<String, dynamic> details) {
  return details['offers'] != null && details['status'] == 0
      ? Container(
      child: ExpansionTile(
          leading: Icon(Icons.lightbulb, color: Colors.yellow),
          title: Text("View offers"),
          children: [Offers(details: details)]))
      : Container(
      child: ExpansionTile(
          title: Text("View offers"),
          children: [Offers(details: details)]));
} //getOffers

Widget getComments(Map<String, dynamic> details) {
  return Container(child: ExpansionTile(title: Text("View Comments"), children: [Comment(details: details)]));
}

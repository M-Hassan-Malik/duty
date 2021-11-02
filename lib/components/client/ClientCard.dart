import 'package:duty/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';

Padding getFirstRow(dynamic doc) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Available",
            style: TextStyle(
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationThickness: 10,
                decorationColor: doc['done'] >= 0 ? Colors.green : myTertiaryColor)),
        SizedBox(width: 5.0),
        Text("Assigned",
            style: TextStyle(
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationThickness: 10,
                decorationColor: doc['done'] >= 1 ? Color(0xff14dc99) : myTertiaryColor)),
        SizedBox(width: 5.0),
        Text("Completed",
            style: TextStyle(
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationThickness: 10,
                decorationColor: doc['done'] >= 2 ? Color(0xff14dc99) : myTertiaryColor)),
        SizedBox(width: 5.0),
        Text("Reviewed",
            style: TextStyle(
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationThickness: 10,
                decorationColor: doc['done'] == 3 ? Color(0xff14dc99) : myTertiaryColor)),
      ],
    ),
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
    DateTime timestampToDateTime = DateTime.parse(userData['createdOn'].toDate().toString());
    DateTime from = timestampToDateTime;
    DateTime to = DateTime.now();

    int time = (to.difference(from).inHours);
    if (time < 24) {
      return time > 1 ? time.toString() + " hours ago" : time.toString() + " hour ago";
    } else {
      return (to.difference(from).inDays) > 23
          ? (to.difference(from).inDays).toString() + " Days ago"
          : (to.difference(from).inDays).toString() + " Day ago";
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
    width: MediaQuery.of(context).size.width,
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
                    width: MediaQuery.of(context).size.width * 0.35,
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
              DateTime.parse(userData['date'].toDate().toString()).toString().split(" ").first,
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ]),
    ),
  );
}

Container getMakeOfferCard(BuildContext context, dynamic userData) {
  return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
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
                      text: userData['payment'],
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
              onPressed: () => {print("clicked Offer")},
            ),
          ],
        ),
      ));
}

Container getDutyDetails(BuildContext context, dynamic userData) {
  return Container(
    width: MediaQuery.of(context).size.width,
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
}

Widget getOffers(BuildContext context, dynamic userData) {
  Align mainCard = new Align(
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
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text("Saad Yaseen",
                              style:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, overflow: TextOverflow.fade))),
                      RatingBarIndicator(
                          rating: 2.5,
                          itemSize: 20,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Yesterday", style: TextStyle(fontSize: 8.0)),
                      Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                            child: Text("100%", style: TextStyle(fontSize: 8.0)),
                          )),
                      Text("Completion Rate", style: TextStyle(fontSize: 8.0)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
  Widget getOffersCard(context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        mainCard,
        Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.account_circle,
              color: myPrimaryColor,
              size: 110,
            )),
      ],
    );
  }

  return Container(
    child: ExpansionTile(
      title: Text("View offers"),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: getOffersCard(context),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: getOffersCard(context),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: getOffersCard(context),
        ),
      ],
    ),
  );
}

Widget getComments(BuildContext context, dynamic userData) {
  TextEditingController controller = new TextEditingController();
  return Container(
    child: ExpansionTile(
      title: Text("View Comments"),
      children: [
        Column(
          children: [],
        )
      ],
    ),
  );
}

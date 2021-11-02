import 'package:duty/components/client/ClientCard.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';

class GetFullDetailsOfDuty extends StatelessWidget {
  final doc;

  const GetFullDetailsOfDuty({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0))),
        backgroundColor: myPrimaryColor,
        foregroundColor: mySecondaryColor,
        title: Text(doc['title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                getFirstRow(doc),
                SizedBox(height: 20.0),
                getClientCard(context, doc),
                SizedBox(height: 15.0),
                getMakeOfferCard(context, doc),
                SizedBox(height: 10.0),
                Divider(
                  color: myTertiaryColor,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Duty Description",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 10),
                getDutyDetails(context, doc),
                SizedBox(height: 10),
                getOffers(context, doc),
                SizedBox(height: 10),
                //getComments(context, doc)

              ],
            ),
          ),
        ),
      ),
    );
  }
}

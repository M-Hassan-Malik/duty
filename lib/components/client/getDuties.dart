import 'package:duty/components/client/ClientCard.dart';
import 'package:duty/components/storage.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';

class GetFullDetailsOfDuty extends StatefulWidget {
  final doc, docId;
  const GetFullDetailsOfDuty({Key? key, required this.doc, required this.docId}) : super(key: key);

  @override
  _GetFullDetailsOfDutyState createState() => _GetFullDetailsOfDutyState();
}

class _GetFullDetailsOfDutyState extends State<GetFullDetailsOfDuty> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController textEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final doc =widget.doc;
    final docId =widget.docId;
    int _status = doc['status'] != null ? doc['status']['status'] : 0;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0))),
          backgroundColor: myPrimaryColor,
          foregroundColor: mySecondaryColor,
          title: Text(widget.docId),
        ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                getFirstRow(_status,context),
                SizedBox(height: 20.0),
                getClientCard(context, doc['duty']),
                SizedBox(height: 15.0),
                Visibility(
                    visible: doc['duty']['uid'] != UserStorage.currentUserId,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: getMakeOfferCard(context, doc, docId),
                    )),
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
                getDutyDetails(context, doc['duty']),
                SizedBox(height: 10),
                getOffers( {
                  "uid": doc['uid'],
                  "city": doc['duty']['city'],
                  "country": doc['duty']['country'],
                  "docId": docId,
                  "offeredMoney": doc['offers'],
                  "status": _status
                }),
                SizedBox(height: 10),
                getComments({
                  "uid": doc['uid'],
                  'doc': doc['duty'],
                  "docId": docId
                })

              ],
            ),
          ),
        ),
      ),
    );
  }
}


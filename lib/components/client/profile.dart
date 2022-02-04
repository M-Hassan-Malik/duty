import 'package:duty/components/GirdViewList.dart';
import 'package:duty/provider/url.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Profile extends StatefulWidget {
  final uidWithCityCountry;

  const Profile({Key? key, required this.uidWithCityCountry}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> topSectionData = {
    'overall_rating': -1.0,
    'task_completion_rate': -1.0,
    'task_completed': -1.0
  }; // using "-1.0" value to know that is it initialized and to use _getUserProfile's worker data at first time

  Future _getUserProfile(BuildContext context, data) async {
    var response;
    try {
      response = await http.post(Uri.parse('$API_URL/user/get-profile-data'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: convert.jsonEncode({
            "uid": data['uid'],
            "city": data['city'],
            "country": data['country'],
          }));
      if (response.statusCode == 200) {
        var resp = convert.jsonDecode(response.body) as Map<String, dynamic>;

        Map<String, dynamic> _setRatings(dynamic responseVariable) {
          double addedRatings = 0;
          int _one = 0, _two = 0, _three = 0, _four = 0, _five = 0;

          responseVariable.forEach((element) {
            addedRatings += element; // add all ratings in one variable
            switch (element.floor()) {
              case 1:
                _one++;
                break;
              case 2:
                _two++;
                break;
              case 3:
                _three++;
                break;
              case 4:
                _four++;
                break;
              case 5:
                _five++;
                break;
            }
          });
          return {
            'addedRatings': addedRatings,
            'list': [_one, _two, _three, _four, _five]
          };
        }

        Map<String, dynamic> workerCalc = _setRatings(resp['rating']['worker']);
        Map<String, dynamic> customerCals = _setRatings(resp['rating']['customer']);

        double workerAvg = workerCalc['addedRatings'] / resp['rating']['worker'].length; // to calculate average
        double customerAvg = customerCals['addedRatings'] / resp['rating']['customer'].length; // to calculate average

        return {
          'info': resp['data'],
          'worker_rating': {'overall': workerAvg, 'individual': workerCalc['list']},
          'customer_rating': {'overall': customerAvg, 'individual': customerCals['list']}
        };
      } else if (response.statusCode == 400) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print("try caught: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getUserProfile(context, widget.uidWithCityCountry),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasError && snapshot.data != null) {
              var info = snapshot.data['info'];
              var worker_rating = snapshot.data['worker_rating'];
              var customer_rating = snapshot.data['customer_rating'];

              return DefaultTabController(
                length: 2,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: myPrimaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: myTertiaryColor,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 2.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 1,
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                              RatingBarIndicator(
                                  rating: topSectionData['overall_rating'] == -1.0 ? worker_rating['overall'] : topSectionData['overall_rating'],
                                  itemSize: 30,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber)),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25), // to adjust below row in center
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 110,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(35.0), color: myTertiaryColor),
                                      child: Icon(Icons.person, size: 100),
                                    ),
                                    Text("Pro",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 2, color: mySecondaryColor))
                                  ],
                                ),
                              ),
                              Text(info['username'],
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 2, color: mySecondaryColor)),
                              Text("Completion rate ${topSectionData['task_completion_rate']}% | Task completed ${topSectionData['task_completed']}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1, color: mySecondaryColor)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2, top: 50),
                            child: TabBar(
                              onTap: (index) {
                                if (index == 0) {
                                  setState(() {
                                    topSectionData = {'overall_rating': worker_rating['overall'], 'task_completion_rate': 0.0, 'task_completed': 0.0};
                                  });
                                } else
                                  setState(() {
                                    topSectionData = {
                                      'overall_rating': customer_rating['overall'],
                                      'task_completion_rate': 5.0,
                                      'task_completed': 5.0
                                    };
                                  });
                              },
                              indicatorWeight: 6,
                              indicatorColor: mySecondaryColor,
                              tabs: [
                                Tab(
                                  text: 'as Worker',
                                ),
                                Tab(
                                  text: 'as Customer',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: new BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 1,
                      ),
                      child: Container(
                        color: Colors.white70,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: TabBarView(children: [
                          Column(
                            children: [
                              statsCard(context, info),
                              Divider(),
                              skillsCard(context, info),
                              Divider(),
                              reviewsCard(context, worker_rating),
                            ],
                          ),
                          Column(
                            children: [
                              statsCard(context, info),
                              Divider(),
                              reviewsCard(context, customer_rating),
                            ],
                          ),
                        ]),
                      ),
                    ),
                    Text(
                      '- - - - end - - - -',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            } else
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
                    ),
                    Text('Wait while we load the profile....', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 15))
                  ],
                ),
              );
          }),
    );
  }
}

ClipRRect statsCard(BuildContext context, dynamic info) => (ClipRRect(
    borderRadius: BorderRadius.circular(5.0),
    child: cardProfileContainer(
        context,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Stats", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 2, color: Colors.black)),
              Divider(),
              Row(
                children: [
                  Icon(Icons.access_time, color: myPrimaryColor),
                  SizedBox(width: 10),
                  Text("joined on ${DateTime.fromMillisecondsSinceEpoch(info['joined_on']['_seconds'] * 1000).toString().split(' ')[0]}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on, color: myPrimaryColor),
                  SizedBox(width: 10),
                  Expanded(child: Text("patel parat nwe town,  patel  nwe town, karachi"))
                ],
              ),
            ],
          ),
        ))));

ClipRRect skillsCard(BuildContext context, dynamic info) => (ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: cardProfileContainer(
          context,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Skills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 2, color: Colors.black)),
                Divider(),
                GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 80,
                      maxCrossAxisExtent: 100,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: (info['skills'].length),
                    itemBuilder: (BuildContext context, index) {
                      return Column(
                        children: [
                          Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: myPrimaryColor,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/${info['skills'][index]}.png',
                                color: myPrimaryColor,
                              )),
                          Text(
                            info['skills'][index],
                            textAlign: TextAlign.center,
                          )
                        ],
                      );
                    })
              ],
            ),
          )),
    ));

ClipRRect reviewsCard(BuildContext context, dynamic rating) {
  var n = 0;
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: cardProfileContainer(
        context,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 2, color: Colors.black)),
              Divider(),
              Text("Overall Rating:"),
              RatingBarIndicator(
                  rating: rating['overall'],
                  itemSize: 30,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber)),
              SizedBox(height: 10),
              SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${rating['individual'][0]} = ⭐",
                      textAlign: TextAlign.left,
                      style: TextStyle(letterSpacing: 5),
                    ),
                    Text(
                      "${rating['individual'][1]} = ⭐⭐",
                      textAlign: TextAlign.left,
                      style: TextStyle(letterSpacing: 5),
                    ),
                    Text(
                      "${rating['individual'][2]} = ⭐⭐⭐",
                      textAlign: TextAlign.left,
                      style: TextStyle(letterSpacing: 5),
                    ),
                    Text(
                      "${rating['individual'][3]} = ⭐⭐⭐⭐",
                      textAlign: TextAlign.left,
                      style: TextStyle(letterSpacing: 5),
                    ),
                    Text(
                      "${rating['individual'][4]} = ⭐⭐⭐⭐⭐",
                      textAlign: TextAlign.left,
                      style: TextStyle(letterSpacing: 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
  );
}

Container cardProfileContainer(BuildContext context, Widget parameterChild) {
  // Container will be returned with defined styling only
  return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 0.5), // shadow direction: bottom right
          )
        ],
      ),
      child: parameterChild);
}

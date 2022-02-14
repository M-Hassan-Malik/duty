import 'package:duty/components/client/loadDuties.dart';
import 'package:duty/components/client/options.dart';
import 'package:duty/components/client/postDuty.dart';
import 'package:duty/components/storage.dart';
import 'package:duty/provider/SignInProvider.dart';
import 'package:duty/provider/helpers.dart';
import 'package:duty/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final uid;

  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<Helper>(context, listen: true);
    int _selectedIndex = _provider.getStepperIndex;
    UserStorage.currentUserId = widget.uid;
    final _uid = widget.uid;
    DateTime timeBackedPressed = DateTime.now();

    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackedPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackedPressed = DateTime.now();
        if (isExitWarning) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Double-tap back to exit app.")));
          return false;
        } else
          return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: myPrimaryColor,
            title: Text(_uid == null ? "User is null" : _uid),
            leading: IconButton(
                onPressed: () {
                  FirebaseAuthenticationProvider().signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                },
                icon: Icon(FontAwesomeIcons.signOutAlt)),
          ),
          body: Container(
              child: _provider.getUserType == 'customer' ? getCurrentScreenForCustomer(_selectedIndex) : getCurrentScreenForWorker(_selectedIndex)),
          bottomNavigationBar: new Theme(
              data: Theme.of(context).copyWith(
                canvasColor: myPrimaryColor,
              ),
              child: _provider.getUserType == 'customer'
                  ? BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.tasks), label: "My Duties"),
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.home), label: "Post Duty"),
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.envelope), label: "Messages"),
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.sitemap), label: "Option"),
                ],
                unselectedItemColor: Colors.black,
                selectedItemColor: mySecondaryColor,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _provider.setStepperIndex(index);
                  });
                },
              )
                  : BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.searchDollar), label: "Find Jobs"),
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.envelope), label: "Messages"),
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.sitemap), label: "Option"),
                ],
                selectedItemColor: mySecondaryColor,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _provider.setStepperIndex(index);
                  });
                },
              ))),
    );
  }
}

Widget getCurrentScreenForCustomer(int index) {
  switch (index) {
    case 0:
      {
        return LoadDuty(myDuty: true);
      }
    case 1:
      {
        return PostDuty();
      }
    case 2:
      {
        return Text('Messages');
      }
    default:
      {
        return Options();
      }
  }
}

Widget getCurrentScreenForWorker(int index) {
  switch (index) {
    case 0:
      {
        return LoadDuty(myDuty: false);
      }
    case 1:
      {
        return Text('Messages');
      }
    default:
      {
        return Options();
      }
  }
}

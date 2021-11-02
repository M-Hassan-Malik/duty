import 'package:duty/provider/SignInProvider.dart';
import 'package:duty/theme.dart';
import 'package:duty/ui/widget_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key} ) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;


  @override
  Widget build(BuildContext context) {
    final _uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myPrimaryColor,
          title: Text(_uid == null ? "User is null" : _uid),
          leading: IconButton(
              onPressed: () {
                FirebaseAuthenticationProvider().signOut();
                Navigator.pushNamed(context, '/loginRoute');
              },
              icon: Icon(FontAwesomeIcons.signOutAlt)),
        ),
        body: Container(
          child: getCurrentScreen(_selectedIndex),
        ),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: myPrimaryColor,
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.searchDollar), label: "Find Jobs"),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.tasks), label: "My Duties"),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.home), label: "Post Duty"),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.envelope), label: "Messages"),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.sitemap), label: "Option"),
            ],
            unselectedItemColor: myTertiaryColor,
            selectedItemColor: mySecondaryColor,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ));
  }
}

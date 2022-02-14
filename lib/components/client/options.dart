import 'package:duty/components/storage.dart';
import 'package:duty/provider/helpers.dart';
import 'package:duty/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Options extends StatefulWidget {
  const Options({Key? key}) : super(key: key);

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<Helper>(context, listen: false);
    String _userType = _provider.getUserType;
    return Container(
      child: ElevatedButton(
        onPressed: () {
          (showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Switch user mode to ${_userType == 'customer' ? 'Worker' : 'Customer'}"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _userType == 'customer' ? _provider.setUserType(1) : _provider.setUserType(0);
                          Navigator.of(context).popUntil(ModalRoute.withName('/'));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(uid: UserStorage.currentUserId)));
                        },
                        child: Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("No"),
                      ),
                    ],
                  )));
        },
        child: Text('Switch user'),
      ),
    );
  }
}

import 'package:duty/provider/helpers.dart';
import 'package:duty/theme.dart';
import 'package:duty/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwitchUser extends StatelessWidget {
  final uid;

  const SwitchUser({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuerySize = MediaQuery.of(context).size;
    var _provider = Provider.of<Helper>(context, listen: false);
    return Container(
      height: mediaQuerySize.height * 1,
      width: mediaQuerySize.width * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {
                _provider.setUserType(0);// 0 => customer
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(uid: uid)));
              },
              child: getContainer({
                'size': mediaQuerySize,
                'imgName': 'customer.jpg',
                'title': 'Login as Customer',
                'description': 'You can repair or post task here.'
              })),
          SizedBox(height: 10.0),
          InkWell(
              onTap: () {
                _provider.setUserType(1);//1 => worker
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(uid: uid)));
              },
              child: getContainer({
                'size': mediaQuerySize,
                'imgName': 'worker.jpg',
                'title': 'Login as Worker',
                'description': 'Earn money by your service and your skills!'
              })),
        ],
      ),
    );
  }
}

Container getContainer(Map<String, dynamic> data) {
  return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: myPrimaryColor,
          width: 5.0,
        ),
      ),
      width: data['size'].width * 0.8,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Image.asset(
          'assets/images/${data['imgName']}',
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            data['title'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data['description']),
        )
      ]));
}

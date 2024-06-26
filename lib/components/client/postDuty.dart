import 'package:duty/ui/post_duty/post_duty.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';
import '../GirdViewList.dart';

class PostDuty extends StatelessWidget {
  const PostDuty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: arrayWidgets.length,
          itemBuilder: (BuildContext context, index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: myTertiaryColor,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 5),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostingDuty(name: arrayWidgets[index]["name"]!)));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(arrayWidgets[index]["path"]!),
                  Text(arrayWidgets[index]["name"]!, style: TextStyle(overflow: TextOverflow.ellipsis),)],
              ),
            );
          }),
    );
  }
}
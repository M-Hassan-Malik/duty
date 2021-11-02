/*
Padding(
padding: const EdgeInsets.all(8.0),
child: Container(
alignment: Alignment.center,
child: Column(
children: <Widget>[
SizedBox(
height: MediaQuery.of(context).size.width * 0.2,
child: ElevatedButton(onPressed: () {
final pro = Provider.of<GoogleAddressProvider>(context, listen: false);
pro.getCurrentAddress();
}, child: Consumer<GoogleAddressProvider>(builder: (context, value, child) {
return Text("Get current location :\n${value.getLocality()}");
})),
),
],
),
),
);*/

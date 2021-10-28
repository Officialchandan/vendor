import 'package:flutter/material.dart';
import 'package:vendor/utility/color.dart';

class DueAmountScreen extends StatefulWidget {
  const DueAmountScreen({Key? key}) : super(key: key);

  @override
  _DueAmountScreenState createState() => _DueAmountScreenState();
}

class _DueAmountScreenState extends State<DueAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPrimary,
      appBar: AppBar(
        title: Text("Money Due - UPI"),
        backgroundColor: ColorPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "₹ 5000",
              style: Theme.of(context).textTheme.headline4!.merge(TextStyle(color: Colors.white)),
            ),
            Text(
              "Company due amount",
              style: Theme.of(context).textTheme.headline6!.merge(TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

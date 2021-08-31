import 'package:flutter/material.dart';

class BillingScreen extends StatefulWidget {
  BillingScreen({Key? key}) : super(key: key);

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Billing"),
        leading: Text(""),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.ac_unit))],
      ),
      body: Container(
        child: Text(""),
      ),
    );
  }
}

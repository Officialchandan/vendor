import 'package:flutter/material.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  CustomAppBar customAppBar = CustomAppBar();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar,
      body: SingleChildScrollView(
        child: Center(
          child: TextButton(
            child: Text("change"),
            onPressed: () {
              customAppBar.createElement().state.setState(() {});
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TrackerReportDashboard extends StatefulWidget {
  @override
  _TrackerReportDashboardState createState() => _TrackerReportDashboardState();
}

class _TrackerReportDashboardState extends State<TrackerReportDashboard> {
  final options = [
    {"title": "Performance tracker", "subTitle": "click here to add product", "image": "assets/images/inventory.png", "id": 1},
    {"title": "View Product", "subTitle": "click here to add product", "image": "assets/images/inventory-h2.png", "id": 2},
    {"title": "Sale Return", "subTitle": "click here to add product", "image": "assets/images/inventory-h3.png", "id": 3},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

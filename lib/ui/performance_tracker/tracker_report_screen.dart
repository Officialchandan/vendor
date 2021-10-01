import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/performance_tracker/report/ViewReportScreen.dart';

import 'money_due_upi/money_due_screen.dart';

class TrackerReportDashboard extends StatefulWidget {
  @override
  _TrackerReportDashboardState createState() => _TrackerReportDashboardState();
}

class _TrackerReportDashboardState extends State<TrackerReportDashboard> {
  final options = [
    {"title": "Performance tracker", "subTitle": "click here to add product", "image": "assets/images/tr-ic1.png", "id": 1},
    {"title": "Reports", "subTitle": "click here to add product", "image": "assets/images/tr-ic2.png", "id": 2},
    {"title": "Money due - UPI", "subTitle": "click here to add product", "image": "assets/images/tr-ic3.png", "id": 3},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Trackers & Reports",
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Stack(
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      if (options[index]["id"] == 2) {
                        Navigator.push(context, PageTransition(child: ViewReportScreen(), type: PageTransitionType.fade));
                      }
                      if (options[index]["id"] == 3) {
                        Navigator.push(context, PageTransition(child: MoneyDueScreen(), type: PageTransitionType.fade));
                      }

                      // if (options[index]["id"] == 1) {
                      //   Navigator.push(context, PageTransition(child: ViewCategoryScreen(), type: PageTransitionType.fade));
                      // }
                    },
                    leading: Image(
                      image: AssetImage("${options[index]["image"]}"),
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    ),
                    title: Text("${options[index]["title"]}"),
                    subtitle: Text("${options[index]["subTitle"]}"),
                  ),
                ),
                Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 5,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                    ))
              ],
            ),
          );
        },
        itemCount: options.length,
      ),
    );
  }
}

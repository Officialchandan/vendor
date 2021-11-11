import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui_without_inventory/performancetracker/report/report_type_screen.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/due_amount_screen.dart';
import 'package:vendor/ui_without_inventory/performancetracker/without_inventory_performance_tracker_category/performance_tracker.dart';
import 'package:vendor/utility/color.dart';

class PerformanceTrackerWithoutInventory extends StatefulWidget {
  @override
  _PerformanceTrackerWithoutInventoryState createState() =>
      _PerformanceTrackerWithoutInventoryState();
}

class _PerformanceTrackerWithoutInventoryState
    extends State<PerformanceTrackerWithoutInventory> {
  final options = [
    {
      "title": "Performance tracker",
      "subTitle": "click here to add product",
      "image": "assets/images/tr-ic1.png",
      "id": 1
    },
    {
      "title": "Reports",
      "subTitle": "click here to add product",
      "image": "assets/images/tr-ic2.png",
      "id": 2
    },
    {
      "title": "Money due - UPI",
      "subTitle": "click here to add product",
      "image": "assets/images/tr-ic3.png",
      "id": 3
    },
    {
      "title": "My Customers",
      "subTitle": "click here to view customer",
      "image": "assets/images/tr-ic3.png",
      "id": 4
    },
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
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ReportTypeScreen(),
                                type: PageTransitionType.fade));
                      }
                      if (options[index]["id"] == 3) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: DueAmountScreen(),
                                type: PageTransitionType.fade));
                      }
                      // if (options[index]["id"] == 4) {
                      //   Navigator.push(context, PageTransition(child: MyCustomerScreen(), type: PageTransitionType.fade));
                      // }

                      if (options[index]["id"] == 1) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child:
                                    WithoutInventoryPerformanceTrackerByCategory(),
                                type: PageTransitionType.fade));
                      }
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
                          color: ColorPrimary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
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

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui_without_inventory/home/home.dart';
import 'package:vendor/ui_without_inventory/performancetracker/report/report_type_screen.dart';
import 'package:vendor/ui_without_inventory/performancetracker/without_inventory_performance_tracker_category/performance_tracker.dart';
import 'package:vendor/utility/color.dart';

import 'my_customer/customers_screen.dart';

class PerformanceTrackerWithoutInventory extends StatefulWidget {
  @override
  _PerformanceTrackerWithoutInventoryState createState() => _PerformanceTrackerWithoutInventoryState();
}

class _PerformanceTrackerWithoutInventoryState extends State<PerformanceTrackerWithoutInventory> {
  final options = [
    {
      "title": "performance_trackers_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/tr-ic1.png",
      "id": 1
    },
    {
      "title": "reports_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/tr-ic2.png",
      "id": 2
    },
    {
      "title": "my_customers_key".tr(),
      "subTitle": "click_here_to_view_customer_key".tr(),
      "image": "assets/images/tr-ic3.png",
      "id": 3
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("trackers_reports_key".tr(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        actions:[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(child: HomeScreenWithoutInventory(), type: PageTransitionType.fade),
                  ModalRoute.withName("/"));
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Stack(
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(0.0, 0.0), //(x,y)
                        blurRadius: 7.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      if (options[index]["id"] == 2) {
                        Navigator.push(
                            context, PageTransition(child: ReportTypeScreen(), type: PageTransitionType.fade));
                      }
                      // if (options[index]["id"] == 3) {
                      //   Navigator.push(
                      //       context,
                      //       PageTransition(
                      //           child: DueAmountScreen(),
                      //           type: PageTransitionType.fade));
                      // }
                      if (options[index]["id"] == 3) {
                        Navigator.push(context, PageTransition(child: CustomerScreen(), type: PageTransitionType.fade));
                      }

                      if (options[index]["id"] == 1) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: WithoutInventoryPerformanceTrackerByCategory(), type: PageTransitionType.fade));
                      }
                    },
                    leading: Image(
                      image: AssetImage("${options[index]["image"]}",),
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text("${options[index]["title"]}",
                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17,color: TextBlackLight),),
                    ),
                    // subtitle: Text("${options[index]["subTitle"]}"),
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

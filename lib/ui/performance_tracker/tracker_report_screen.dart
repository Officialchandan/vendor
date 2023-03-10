import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/home/home.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/performance_tracker.dart';
import 'package:vendor/ui/performance_tracker/report/select_report_types.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import '../money_due_upi/money_due_screen.dart';
import 'my_customers/MyCustomrScreen.dart';

class TrackerReportDashboard extends StatefulWidget {
  @override
  _TrackerReportDashboardState createState() => _TrackerReportDashboardState();
}

class _TrackerReportDashboardState extends State<TrackerReportDashboard> {
  final options = [
    {
      "title": "performance_trackers_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/tr-ic1.png",
      "id": 1
    },
    {
      "title": "reports_key".tr(),
      "subTitle": "click_here_to_view_reports_key".tr(),
      "image": "assets/images/tr-ic2.png",
      "id": 2
    },
    // {
    //   "title": "money_due_upi_key".tr(),
    //   "subTitle": "click_here_to_add_product_key".tr(),
    //   "image": "assets/images/tr-ic3.png",
    //   "id": 3
    // },
    {
      "title": "my_customers_key".tr(),
      "subTitle": "click_here_to_view_customer_key".tr(),
      "image": "assets/images/tr-ic3.png",
      "id": 4
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "trackers_reports_key".tr(),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(context, PageTransition(child: HomeScreen(), type: PageTransitionType.fade),
                  ModalRoute.withName("/"));
            },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              height: 30,
              width: 30,
              child: Image.asset("assets/images/home.png"),
            ),
          )
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
                        blurRadius:7.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    hoverColor: Colors.transparent,
                    onTap: () async {
                      if (await Network.isConnected()) {
                        if (options[index]["id"] == 2) {
                          Navigator.push(
                              context, PageTransition(child: SelectReportTypeScreen(), type: PageTransitionType.fade));
                        }
                        if (options[index]["id"] == 3) {
                          Navigator.push(
                              context, PageTransition(child: MoneyDueScreen(true), type: PageTransitionType.fade));
                        }
                        if (options[index]["id"] == 4) {
                          Navigator.push(
                              context, PageTransition(child: MyCustomerScreen(), type: PageTransitionType.fade));
                        }

                        if (options[index]["id"] == 1) {
                          Navigator.push(context,
                              PageTransition(child: PerformanceTrackerByCategory(), type: PageTransitionType.fade));
                        }
                      } else {
                        Utility.showToast(
                          msg: "please_check_your_internet_connection_key".tr(),
                        );
                      }
                    },
                    leading: Image(
                      image: AssetImage("${options[index]["image"]}"),
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "${options[index]["title"]}",

                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17,color: TextBlackLight),

                      ),
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

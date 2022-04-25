import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/earning_tillnow/earning_amount.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/sale_amount/sale_amount.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/walk_in/walkin.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class PerformanceTrackerByCategory extends StatefulWidget {
  @override
  _PerformanceTrackerByCategoryState createState() => _PerformanceTrackerByCategoryState();
}

class _PerformanceTrackerByCategoryState extends State<PerformanceTrackerByCategory> {
  final options = [
    {
      "title": "sale_amount_key".tr(),
      "subTitle": "click_here_to_see_sale_amount_key".tr(),
      "image": "assets/images/performance-ic1.png",
      "id": 1
    },
    {
      "title": "earning_till_now_key".tr(),
      "subTitle": "click_here_to_see_earning_amount_key".tr(),
      "image": "assets/images/performance-ic2.png",
      "id": 2
    },
    {
      "title": "walk_in_key".tr(),
      "subTitle": "click_here_to_sell_walikins_key".tr(),
      "image": "assets/images/performance-ic3.png",
      "id": 3
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "trackers_reports_key".tr(),
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
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () async {
                      if (await Network.isConnected()) {
                        if (options[index]["id"] == 2) {
                          Navigator.push(
                              context, PageTransition(child: EarningAmount(), type: PageTransitionType.fade));
                        }
                        if (options[index]["id"] == 3) {
                          Navigator.push(context, PageTransition(child: WalkInAmount(), type: PageTransitionType.fade));
                        }

                        if (options[index]["id"] == 1) {
                          Navigator.push(context, PageTransition(child: SaleAmount(), type: PageTransitionType.fade));
                        }
                      } else {
                        Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
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

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/performance_tracker/report/coin_redeem_report.dart';
import 'package:vendor/ui/performance_tracker/report/daily_report.dart';
import 'package:vendor/ui/performance_tracker/report/generated_coin_report.dart';
import 'package:vendor/utility/color.dart';

class ReportTypeScreen extends StatefulWidget {
  const ReportTypeScreen({Key? key}) : super(key: key);

  @override
  _ReportTypeScreenState createState() => _ReportTypeScreenState();
}

class _ReportTypeScreenState extends State<ReportTypeScreen> {
  final options = [
    {
      "title": "daily_sales_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/tr-ic1.png",
      "id": 1
    },
    {
      "title": "coin_generated_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/tr-ic2.png",
      "id": 2
    },
    {
      "title": "coin_redeemed_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/tr-ic3.png",
      "id": 3
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "report_types_key".tr(),
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
                      if (options[index]["id"] == 1) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: DailyReport(
                                  chatPapdi: 1,
                                ),
                                type: PageTransitionType.fade));
                      } else if (options[index]["id"] == 2) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: GeneratedCoinReport(
                                  chatPapdi: 1,
                                ),
                                type: PageTransitionType.fade));
                      } else if (options[index]["id"] == 3) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: CoinRedeemReport(
                                  chatPapdi: 1,
                                ),
                                type: PageTransitionType.fade));
                      }
                    },
                    title: Text("${options[index]["title"]}"),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
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

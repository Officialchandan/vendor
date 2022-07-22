import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/ui/performance_tracker/listner/performancetrackerlistner.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/bottom_widget.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/sale_amount/dailysaleamountwidget.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/sale_amount/monthlysaleamountwidget.dart';
import 'package:vendor/utility/color.dart';

class SaleAmount extends StatefulWidget {
  SaleAmount({Key? key}) : super(key: key);

  @override
  _SaleAmountState createState() => _SaleAmountState();
}

class _SaleAmountState extends State<SaleAmount> with TickerProviderStateMixin {
  TooltipBehavior? _tooltipBehavior;

  Map<String, String>? resultHourlyMap = {};
  int saleindex = 1;

  List<String> demo = [];
  // String categid = "", productid = "", cdate = "";
  TabController? _tabController;
  BottomWidget? bottomWidget;

  PerformanceTrackerListner? performanceTrackerListner;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                color: TabBarColor,
                child: TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: ColorPrimary,
                  controller: _tabController,
                  indicator: BoxDecoration(
                      color: TabBarColor, border: Border(bottom: BorderSide(color: ColorPrimary, width: 3))),
                  onTap: (index) {
                    log("$index");

                    // Tab index when user select it, it start from zero
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "daily_key".tr(),
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "monthly_key".tr(),
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: Text('sale_amount_key'.tr()),
            centerTitle: true,
            actions: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return BottomWidget(
                          index: _tabController!.index,
                          screenindex: saleindex,
                          onSelect: (categoryid, listSelected, date) {
                            performanceTrackerListner!.onFiterSelect(categoryid, listSelected, date);
                          },
                        );
                      }).then((value) {
                    log("======>data$value");
                    // setState(() {});
                  });
                },
                splashColor: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.filter_alt_sharp), Text("filter_key".tr())],
                ),
              ),
              const SizedBox(
                width: 15,
              )
            ],
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            backgroundColor: ColorPrimary,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // HourlySaleAmount(
              //   onInit: (PerformanceTrackerListner hourlyListner) {
              //     performanceTrackerListner = hourlyListner;
              //   },
              // ),
              DailySaleAmount(
                onInit: (PerformanceTrackerListner dailyListner) {
                  performanceTrackerListner = dailyListner;
                },
              ),
              MonthlySaleAmount(
                onInit: (PerformanceTrackerListner monthlyListner) {
                  performanceTrackerListner = monthlyListner;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

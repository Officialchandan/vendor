import 'dart:developer';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/performance_tracker/listner/performancetrackerlistner.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/bottom_widget.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/earning_tillnow/dailyearningamountwidget.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/earning_tillnow/hourlyearningamountwidget.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/earning_tillnow/monthlyearningamountwidget.dart';
import 'package:vendor/utility/color.dart';

class EarningAmount extends StatefulWidget {
  EarningAmount({Key? key}) : super(key: key);

  @override
  _EarningAmountState createState() => _EarningAmountState();
}

class _EarningAmountState extends State<EarningAmount>
    with TickerProviderStateMixin {
  Map<String, String>? resultHourlyMap = {};
  int earningindex = 2;
  List<String> demo = [];
  TabController? _tabController;
  BottomWidget? bottomWidget;
  PerformanceTrackerListner? performanceTrackerListner;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                      color: TabBarColor,
                      border: Border(
                          bottom: BorderSide(color: ColorPrimary, width: 3))),
                  onTap: (index) {
                    log("$index");
                    // Tab index when user select it, it start from zero
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "hourly_key".tr(),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "daily_key".tr(),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "monthly_key".tr(),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: Text('earning_amount_key'.tr()),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            backgroundColor: ColorPrimary,
            actions: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return BottomWidget(
                            index: _tabController!.index,
                            screenindex: earningindex,
                            onSelect: (categoryid, listSelected, date) {
                              performanceTrackerListner!.onFiterSelect(
                                  categoryid!, listSelected!, date!);
                            });
                      });
                },
                splashColor: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_alt_sharp),
                    Text("filter_key".tr())
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              )
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              HourlyEarningAmount(
                onInit: (PerformanceTrackerListner hourlyListner) {
                  performanceTrackerListner = hourlyListner;
                },
              ),
              DailyEarningAmount(
                onInit: (PerformanceTrackerListner dailyListner) {
                  performanceTrackerListner = dailyListner;
                },
              ),
              MonthlyEarningAmount(
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

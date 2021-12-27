import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/daily_walkin.dart';
import 'package:vendor/model/hourly_sale_amount.dart';
import 'package:vendor/model/hourly_walkin.dart';
import 'package:vendor/model/monthly_walkin.dart';
import 'package:vendor/ui/performance_tracker/listner/performancetrackerlistner.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/bottom_widget.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/walk_in/dailywalkinamountwidget.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/walk_in/hourlywalkinamountwidget.dart';
import 'package:vendor/ui/performance_tracker/performance_tracker_category/walk_in/monthlywalkinamountwidget.dart';
import 'package:vendor/utility/color.dart';

class WalkInAmount extends StatefulWidget {
  WalkInAmount({Key? key}) : super(key: key);

  @override
  _WalkInAmountState createState() => _WalkInAmountState();
}

class _WalkInAmountState extends State<WalkInAmount>
    with TickerProviderStateMixin {
  TooltipBehavior? _tooltipBehavior;
  DailyWalkinAmountResponse? resultDaily;
  PerformanceTrackerListner? performanceTrackerListner;
  int walkinindex = 3;

  Map<String, String>? resultHourlyMap = {};

  List<String> demo = [];
  TabController? _tabController;
  BottomWidget? bottomWidget;

  @override
  // ignore: must_call_super
  void initState() {
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: MaterialApp(
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
            title: Text('Walkin Amount'),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            actions: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return BottomWidget(
                            index: _tabController!.index,
                            screenindex: walkinindex,
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
            backgroundColor: ColorPrimary,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              HourlyWalkinAmount(),
              DailyWalkInAmount(),
              MonthlyWalkinAmount()
            ],
          ),
        ),
      ),
    );
  }
}

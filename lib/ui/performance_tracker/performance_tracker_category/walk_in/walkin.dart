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
import 'package:vendor/ui/performance_tracker/performance_tracker_category/bottom_widget.dart';
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
  MonthlyWalkinAmountResponse? resultMonthly;
  int walkinindex = 3;
  HourlyWalkinAmountResponse? resultHourly;
  Map<String, String>? resultHourlyMap = {};

  List<String> demo = [];
  TabController? _tabController;
  BottomWidget? bottomWidget;
  Future<DailyWalkinAmountData> getDhabasDay() async {
    resultDaily = await ApiProvider().getDailyWalkinAmount();
    log('${resultDaily!.data}');
    return resultDaily!.data!;
  }

  Future<MonthlyWalkinAmountData> getDhabasMonthly() async {
    resultMonthly = await ApiProvider().getMonthlyWalkinAmount();
    log('${resultMonthly!.data}');
    return resultMonthly!.data!;
  }

  Future<Map<String, String>> getDhabasHourly() async {
    resultHourly = (await ApiProvider().getHourlyWalkinAmount());
    log('${resultHourly!.data}');
    return resultHourly!.data!;
  }

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
                        );
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
              SingleChildScrollView(
                  child: FutureBuilder<Map<String, String>>(
                      future: getDhabasHourly(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: ColorPrimary));
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("data_not_found_key".tr()),
                          );
                        }
                        return Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Checkbox(
                                  //     value: checked,
                                  //     onChanged: (check) => saleAmountBloc
                                  //         .add(CheckBoxEvent(checked: check!))),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    defaultColumnWidth:
                                        FixedColumnWidth(deviceWidth * 0.44),
                                    border: TableBorder.all(
                                        color: Colors.black12,
                                        style: BorderStyle.solid,
                                        width: 1),
                                    children: [
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: TabBarColor,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        "  " +
                                                            "hourly_key".tr(),
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            color:
                                                                ColorPrimary)),
                                                  ))
                                            ]),
                                        Container(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    height: 50,
                                                    width: deviceWidth * 0.44,
                                                    color: TabBarColor,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: AutoSizeText(
                                                          "  " +
                                                              "earning_key"
                                                                  .tr(),
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color:
                                                                  ColorPrimary)),
                                                    ))
                                              ]),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: AutoSizeText(
                                                      '  ${snapshot.data!.keys.toList()[0]}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                      maxFontSize: 14,
                                                      minFontSize: 12,
                                                    ),
                                                  ))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '  ${(double.parse(snapshot.data!.values.toList()[0]).toStringAsFixed(2))} ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15.0,
                                                            color:
                                                                Colors.black)),
                                                  ))
                                            ]),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: AutoSizeText(
                                                      '  ${snapshot.data!.keys.toList()[1]}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                      maxFontSize: 14,
                                                      minFontSize: 12,
                                                    ),
                                                  ))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '  ${(double.parse(snapshot.data!.values.toList()[1]).toStringAsFixed(2))}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15.0,
                                                            color:
                                                                Colors.black)),
                                                  ))
                                            ]),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: AutoSizeText(
                                                      '  ${snapshot.data!.keys.toList()[2]}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                      maxFontSize: 14,
                                                      minFontSize: 12,
                                                    ),
                                                  ))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '  ${(double.parse(snapshot.data!.values.toList()[2]).toStringAsFixed(2))}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15.0,
                                                            color:
                                                                Colors.black)),
                                                  ))
                                            ]),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: AutoSizeText(
                                                      '  ${snapshot.data!.keys.toList()[3]}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                      maxFontSize: 14,
                                                      minFontSize: 12,
                                                    ),
                                                  ))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '  ${(double.parse(snapshot.data!.values.toList()[3]).toStringAsFixed(2))}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15.0,
                                                            color:
                                                                Colors.black)),
                                                  ))
                                            ]),
                                      ]),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 200,
                                    child: SfCartesianChart(
                                      plotAreaBorderWidth: 2,
                                      plotAreaBorderColor: Colors.transparent,
                                      //palette: <Color>[ColorPrimary],
                                      borderColor: Colors.grey.shade500,

                                      title: ChartTitle(
                                          text: "walkin_amt_inr_key".tr() + " ",
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600)),
                                      // legend: Legend(isVisible: true),
                                      tooltipBehavior: _tooltipBehavior,
                                      enableMultiSelection: true,

                                      series: <ChartSeries>[
                                        BarSeries<GDPDatass, String>(
                                            color: ColorPrimary,

                                            // name: '',
                                            dataSource:
                                                getChartDatass(snapshot.data),
                                            xValueMapper: (GDPDatass gdp, _) =>
                                                gdp.continent,
                                            yValueMapper: (GDPDatass gdp, _) =>
                                                gdp.sale,
                                            //  dataLabelSettings: DataLabelSettings(isVisible: true),
                                            enableTooltip: false)
                                      ],
                                      primaryXAxis: CategoryAxis(
                                          majorGridLines:
                                              MajorGridLines(width: 0),
                                          interval: 1,
                                          labelStyle: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                          desiredIntervals: 1),
                                      primaryYAxis: NumericAxis(
                                        edgeLabelPlacement:
                                            EdgeLabelPlacement.shift,
                                        // desiredIntervals: 6,
                                        // interval: 2000,

                                        //numberFormat: NumberFormat.currency(),
                                        title: AxisTitle(
                                            alignment: ChartAlignment.center,
                                            text:
                                                "walkin_amt_inr_key".tr() + " ",
                                            textStyle: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600)),
                                      ),
                                    ),
                                  )
                                ]));
                      })),
              SingleChildScrollView(
                  child: FutureBuilder<DailyWalkinAmountData>(
                      future: getDhabasDay(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: ColorPrimary));
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("data_not_found_key".tr()),
                          );
                        }
                        return Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Checkbox(
                                  //     value: checked,
                                  //     onChanged: (check) => saleAmountBloc
                                  //         .add(CheckBoxEvent(checked: check!))),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    defaultColumnWidth:
                                        FixedColumnWidth(deviceWidth * 0.44),
                                    border: TableBorder.all(
                                        color: Colors.black12,
                                        style: BorderStyle.solid,
                                        width: 1),
                                    children: [
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: TabBarColor,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        "  " + "day_key".tr(),
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            color:
                                                                ColorPrimary)),
                                                  ))
                                            ]),
                                        Container(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    height: 50,
                                                    width: deviceWidth * 0.44,
                                                    color: TabBarColor,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: AutoSizeText(
                                                          " " +
                                                              "walkin_key".tr(),
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color:
                                                                  ColorPrimary)),
                                                    ))
                                              ]),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: AutoSizeText(
                                                      '  ${snapshot.data!.date}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                      maxFontSize: 14,
                                                      minFontSize: 12,
                                                    ),
                                                  ))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '  ${(double.parse(snapshot.data!.walkIns)).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15.0,
                                                            color:
                                                                Colors.black)),
                                                  ))
                                            ]),
                                      ]),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 200,
                                    child: SfCartesianChart(
                                      plotAreaBorderWidth: 2,
                                      plotAreaBorderColor: Colors.transparent,
                                      //palette: <Color>[ColorPrimary],
                                      borderColor: Colors.grey.shade500,

                                      title: ChartTitle(
                                          text: "walkin_amt_inr_key".tr() + " ",
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600)),
                                      // legend: Legend(isVisible: true),
                                      tooltipBehavior: _tooltipBehavior,
                                      enableMultiSelection: true,

                                      series: <ChartSeries>[
                                        BarSeries<GDPData, String>(
                                            color: ColorPrimary,

                                            // name: '',
                                            dataSource:
                                                getChartData(snapshot.data),
                                            xValueMapper: (GDPData gdp, _) =>
                                                gdp.continent,
                                            yValueMapper: (GDPData gdp, _) =>
                                                gdp.sale,
                                            //  dataLabelSettings: DataLabelSettings(isVisible: true),
                                            enableTooltip: false)
                                      ],
                                      primaryXAxis: CategoryAxis(
                                          majorGridLines:
                                              MajorGridLines(width: 0),
                                          labelStyle: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                          desiredIntervals: 1),
                                      primaryYAxis: NumericAxis(
                                        edgeLabelPlacement:
                                            EdgeLabelPlacement.shift,
                                        // desiredIntervals: 6,
                                        // interval: 2000,

                                        //numberFormat: NumberFormat.currency(),
                                        title: AxisTitle(
                                            alignment: ChartAlignment.center,
                                            text:
                                                "walkin_amt_inr_key".tr() + " ",
                                            textStyle: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600)),
                                      ),
                                    ),
                                  )
                                ]));
                      })),
              SingleChildScrollView(
                  child: FutureBuilder<MonthlyWalkinAmountData>(
                      future: getDhabasMonthly(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: ColorPrimary));
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("data_not_found_key".tr()),
                          );
                        }
                        return Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Checkbox(
                                  //     value: checked,
                                  //     onChanged: (check) => saleAmountBloc
                                  //         .add(CheckBoxEvent(checked: check!))),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    defaultColumnWidth:
                                        FixedColumnWidth(deviceWidth * 0.44),
                                    border: TableBorder.all(
                                        color: Colors.black12,
                                        style: BorderStyle.solid,
                                        width: 1),
                                    children: [
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: TabBarColor,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        "  " +
                                                            "monthly_key".tr(),
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            color:
                                                                ColorPrimary)),
                                                  ))
                                            ]),
                                        Container(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    height: 50,
                                                    width: deviceWidth * 0.44,
                                                    color: TabBarColor,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: AutoSizeText(
                                                          " " +
                                                              "walkin_key".tr(),
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color:
                                                                  ColorPrimary)),
                                                    ))
                                              ]),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: AutoSizeText(
                                                      '  ${snapshot.data!.month}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                      maxFontSize: 14,
                                                      minFontSize: 12,
                                                    ),
                                                  ))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: deviceWidth * 0.44,
                                                  color: Colors.white,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '  ${(double.parse(snapshot.data!.monthlyWalkIns)).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15.0,
                                                            color:
                                                                Colors.black)),
                                                  ))
                                            ]),
                                      ]),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 200,
                                    child: SfCartesianChart(
                                      plotAreaBorderWidth: 2,
                                      plotAreaBorderColor: Colors.transparent,
                                      //palette: <Color>[ColorPrimary],
                                      borderColor: Colors.grey.shade500,

                                      title: ChartTitle(
                                          text: "walkin_amt_inr_key".tr() + " ",
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600)),
                                      // legend: Legend(isVisible: true),
                                      tooltipBehavior: _tooltipBehavior,
                                      enableMultiSelection: true,

                                      series: <ChartSeries>[
                                        BarSeries<GDPDatas, String>(
                                            color: ColorPrimary,

                                            // name: '',
                                            dataSource:
                                                getChartDatas(snapshot.data),
                                            xValueMapper: (GDPDatas gdp, _) =>
                                                gdp.continent,
                                            yValueMapper: (GDPDatas gdp, _) =>
                                                gdp.sale,
                                            //  dataLabelSettings: DataLabelSettings(isVisible: true),
                                            enableTooltip: false)
                                      ],
                                      primaryXAxis: CategoryAxis(
                                          majorGridLines:
                                              MajorGridLines(width: 0),
                                          labelStyle: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                          desiredIntervals: 1),
                                      primaryYAxis: NumericAxis(
                                        edgeLabelPlacement:
                                            EdgeLabelPlacement.shift,
                                        // desiredIntervals: 6,
                                        // interval: 2000,

                                        //numberFormat: NumberFormat.currency(),
                                        title: AxisTitle(
                                            alignment: ChartAlignment.center,
                                            text:
                                                "walkin_amt_inr_key".tr() + " ",
                                            textStyle: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600)),
                                      ),
                                    ),
                                  )
                                ]));
                      })),
            ],
          ),
        ),
      ),
    );
  }

  List<GDPData> getChartData(DailyWalkinAmountData? data) {
    final List<GDPData> chartData = [
      GDPData(
        'today_key'.tr(),
        double.parse(data!.walkIns.toString()),
      ),
      GDPData(' ', 0),
      GDPData("", 0),
    ];
    return chartData;
  }

  List<GDPDatas> getChartDatas(MonthlyWalkinAmountData? data) {
    final List<GDPDatas> chartData = [
      GDPDatas(
        '${data!.month}',
        double.parse(data.monthlyWalkIns.toString()),
      ),
      GDPDatas(' ', 0),
      GDPDatas(
        "",
        0,
      ),
    ];
    return chartData;
  }

  List<GDPDatass> getChartDatass(Map<String, String>? data) {
    final List<GDPDatass> chartData = [
      GDPDatass(
        '${data!.keys.toList()[0]}',
        double.parse(data.values.toList()[0]),
      ),
      GDPDatass(
        '${data.keys.toList()[1]}',
        double.parse(data.values.toList()[1]),
      ),
      GDPDatass(
        '${data.keys.toList()[2]}',
        double.parse(data.values.toList()[2]),
      ),
      GDPDatass(
        '${data.keys.toList()[3]}',
        double.parse(data.values.toList()[3]),
      ),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.sale);

  final String continent;
  final double sale;
}

class GDPDatas {
  GDPDatas(this.continent, this.sale);

  final String continent;
  final double sale;
}

class GDPDatass {
  GDPDatass(this.continent, this.sale);

  final String continent;
  final double sale;
}

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/daily_earning.dart';
import 'package:vendor/model/hourly_earning.dart';
import 'package:vendor/model/monthly_earning.dart';
import 'package:vendor/utility/color.dart';

class EarningAmount extends StatefulWidget {
  EarningAmount({Key? key}) : super(key: key);

  @override
  _EarningAmountState createState() => _EarningAmountState();
}

class _EarningAmountState extends State<EarningAmount> {
  TooltipBehavior? _tooltipBehavior;
  DailyEarningAmountResponse? resultDaily;
  MonthlyEarningAmountResponse? resultMonthly;

  HourlyEarningAmountResponse? resultHourly;
  Map<String, String>? resultHourlyMap;

  Future<DailyEarningAmountData> getDhabasDay() async {
    resultDaily = await ApiProvider().getDailyEarningAmount();
    log('${resultDaily!.data}');
    return resultDaily!.data!;
  }

  Future<MonthlyEarningAmountData> getDhabasMonthly() async {
    resultMonthly = await ApiProvider().getMonthlyEarningAmount();
    log('${resultMonthly!.data}');
    return resultMonthly!.data!;
  }

  Future<Map<String, String>> getDhabasHourly() async {
    resultHourly = (await ApiProvider().getHourlyEarningAmount());
    log('${resultHourly!.data}');
    return resultHourly!.data!;
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
                  indicator: BoxDecoration(
                      color: TabBarColor,
                      border: Border(
                          bottom: BorderSide(color: ColorPrimary, width: 3))),
                  onTap: (index) {
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
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                  child: FutureBuilder<Map<String, String>>(
                      future: getDhabasHourly(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Data_Not_Found_key".tr()),
                          );
                        }
                        if (snapshot.hasData) {
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
                                                          "  hourly_key".tr(),
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
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: AutoSizeText(
                                                            "  Earning_key"
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
                                                            color:
                                                                Colors.black),
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
                                                          '  ${snapshot.data!.values.toList()[0]}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15.0,
                                                              color: Colors
                                                                  .black)),
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
                                                            color:
                                                                Colors.black),
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
                                                          '  ${snapshot.data!.values.toList()[1]}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15.0,
                                                              color: Colors
                                                                  .black)),
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
                                                            color:
                                                                Colors.black),
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
                                                          '  ${snapshot.data!.values.toList()[2]}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15.0,
                                                              color: Colors
                                                                  .black)),
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
                                                            color:
                                                                Colors.black),
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
                                                          '  ${snapshot.data!.values.toList()[3]}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15.0,
                                                              color: Colors
                                                                  .black)),
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
                                            text: "earning_amt_inr_key".tr(),
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
                                              xValueMapper:
                                                  (GDPDatass gdp, _) =>
                                                      gdp.continent,
                                              yValueMapper:
                                                  (GDPDatass gdp, _) =>
                                                      gdp.sale,
                                              //  dataLabelSettings: DataLabelSettings(isVisible: true),
                                              enableTooltip: false)
                                        ],
                                        primaryXAxis: CategoryAxis(
                                            interval: 1,
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
                                              text: "earning_amt_inr_key ".tr(),
                                              textStyle: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade600)),
                                        ),
                                      ),
                                    )
                                  ]));
                        }
                        return Container();
                      })),
              SingleChildScrollView(
                  child: FutureBuilder<DailyEarningAmountData>(
                      future: getDhabasDay(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Data_Not_Found_key".tr()),
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
                                                        "  day_key".tr(),
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
                                                          "  Earning_key".tr(),
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
                                                      '  ${snapshot.data!.today}',
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
                                                        '  ${snapshot.data!.dailyEarning}',
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
                                                      '  ${snapshot.data!.yesterday}',
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
                                                        '  ${snapshot.data!.yesterdayEarning}',
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
                                          text: "earning_amt_inr_key ".tr(),
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
                                            text: "earning_amt_inr_key ".tr(),
                                            textStyle: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600)),
                                      ),
                                    ),
                                  )
                                ]));
                      })),
              SingleChildScrollView(
                  child: FutureBuilder<MonthlyEarningAmountData>(
                      future: getDhabasMonthly(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Data_Not_Found_key".tr()),
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
                                                        "  day_key".tr(),
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
                                                          "  Earning_key".tr(),
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
                                                        '  ${snapshot.data!.monthlyEarning}',
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
                                          text: "earning_amt_inr_key ".tr(),
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
                                            text: "earning_amt_inr_key ".tr(),
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

  List<GDPData> getChartData(DailyEarningAmountData? data) {
    final List<GDPData> chartData = [
      GDPData(
        'today_key'.tr(),
        double.parse(data!.dailyEarning.toString()),
      ),
      GDPData(' ', 0),
      GDPData(
          "yesterdat_key".tr(), double.parse(data.yesterdayEarning.toString())),
    ];
    return chartData;
  }

  List<GDPDatas> getChartDatas(MonthlyEarningAmountData? data) {
    final List<GDPDatas> chartData = [
      GDPDatas(
        '${data!.month}',
        double.parse(data.monthlyEarning.toString()),
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

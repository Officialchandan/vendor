import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Daily_walkin.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Hourly_walkin.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Monthly_walkin.dart';

import 'package:vendor/provider/api_provider.dart';
import 'package:vendor/utility/color.dart';

class WalkInAmount extends StatefulWidget {
  WalkInAmount({Key? key}) : super(key: key);

  @override
  _WalkInAmountState createState() => _WalkInAmountState();
}

class _WalkInAmountState extends State<WalkInAmount> {
  TooltipBehavior? _tooltipBehavior;
  WithoutInventoryDailyWalkinResponse? resultDaily;
  WithoutInventoryMonthlyWalkinResponse? resultMonthly;

  WithoutInventoryHourlyWalkinResponse? resultHourly;

  Future<WithoutInventoryDailyWalkinData> getDhabasDay() async {
    resultDaily = await ApiProvider().getChatPapdiDailyWalkinAmount();
    log('${resultDaily!.data}');
    return resultDaily!.data!;
  }

  Future<WithoutInventoryMonthlyWalkinData> getDhabasMonthly() async {
    resultMonthly = await ApiProvider().getChatPapdiMonthlyWalkinAmount();
    log('${resultMonthly!.data}');
    return resultMonthly!.data!;
  }

  Future<Map<String, String>> getDhabasHourly() async {
    resultHourly = (await ApiProvider().getChatPapdiHourlyWalkinAmount());
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
                        "Hourly",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Daily",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Monthly",
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
                            child: Text("Data Not Found"),
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
                                                    child: Text("  Hourly",
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
                                                          "  Earning",
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
                                                        '  ${snapshot.data!.values.toList()[0]} ',
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
                                                        '  ${snapshot.data!.values.toList()[1]}',
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
                                                        '  ${snapshot.data!.values.toList()[2]}',
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
                                                        '  ${snapshot.data!.values.toList()[3]}',
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
                                          text: "Walkin AMT (INR) ",
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
                                            text: "Walkin AMT (INR) ",
                                            textStyle: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600)),
                                      ),
                                    ),
                                  )
                                ]));
                      })),
              SingleChildScrollView(
                  child: FutureBuilder<WithoutInventoryDailyWalkinData>(
                      future: getDhabasDay(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Data Not Found"),
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
                                                    child: Text("  Day",
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
                                                          "  Walkin",
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
                                                        '  ${snapshot.data!.todayWalkIns}',
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
                                                        '  ${snapshot.data!.yesterdayWalkIns}',
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
                                          text: "Walkin AMT (INR) ",
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
                                            text: "Walkin AMT (INR) ",
                                            textStyle: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600)),
                                      ),
                                    ),
                                  )
                                ]));
                      })),
              SingleChildScrollView(
                  child: FutureBuilder<WithoutInventoryMonthlyWalkinData>(
                      future: getDhabasMonthly(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Data Not Found"),
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
                                                    child: Text("  Day",
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
                                                          "  Walkin",
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
                                                        '  ${snapshot.data!.monthlyWalkIns}',
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
                                          text: "Walkin AMT (INR) ",
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
                                            text: "Walkin AMT (INR) ",
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

  List<GDPData> getChartData(WithoutInventoryDailyWalkinData? data) {
    final List<GDPData> chartData = [
      GDPData(
        'TODAY',
        double.parse(data!.todayWalkIns.toString()),
      ),
      GDPData(' ', 0),
      GDPData("YESTERDAY", double.parse(data.yesterdayWalkIns.toString())),
    ];
    return chartData;
  }

  List<GDPDatas> getChartDatas(WithoutInventoryMonthlyWalkinData? data) {
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

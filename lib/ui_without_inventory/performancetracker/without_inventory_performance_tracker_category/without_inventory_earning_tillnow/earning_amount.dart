import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Daily_Earning.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Hourly_Earning.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Monthly_Earning.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/widget/progress_indecator.dart';

class EarningAmount extends StatefulWidget {
  EarningAmount({Key? key}) : super(key: key);

  @override
  _EarningAmountState createState() => _EarningAmountState();
}

class _EarningAmountState extends State<EarningAmount> {
  TooltipBehavior? _tooltipBehavior;
  WithoutInventoryDailyEarningResponse? resultDaily;
  WithoutInventoryMonthlyEarningResponse? resultMonthly;
  StreamController<WithoutInventoryMonthlyEarningData> controller = StreamController.broadcast();
  WithoutInventoryHourlyEarningResponse? resultHourly;
  Map<String, String>? resultHourlyMap;

  Future<WithoutInventoryDailyEarningData> getDhabasDay() async {
    resultDaily = await ApiProvider().getChatPapdiDailyEarningAmount();
    log('${resultDaily!.data}');
    return resultDaily!.data!;
  }

  Future<WithoutInventoryMonthlyEarningData> getDhabasMonthly() async {
    resultMonthly = await ApiProvider().getChatPapdiMonthlyEarningAmount();
    //controller.sink.add(resultMonthly!.data!);
    //log('${resultMonthly!.data!}');
    return resultMonthly!.data!;
  }

  Future<Map<String, String>> getDhabasHourly() async {
    resultHourly = (await ApiProvider().getChatPapdiHourlyEarningAmount());
    log('${resultHourly!.data}');

    return resultHourly!.data!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDhabasMonthly();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

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
                  indicator: BoxDecoration(
                      color: TabBarColor, border: Border(bottom: BorderSide(color: ColorPrimary, width: 3))),
                  onTap: (index) {
                    // Tab index when user select it, it start from zero
                  },
                  tabs: [
                    // Tab(
                    //   child: Text(
                    //     "hourly_key".tr(),
                    //     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    //   ),
                    // ),
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
              // SingleChildScrollView(
              //     child: FutureBuilder<Map<String, String>>(
              //         future: getDhabasHourly(),
              //         builder: (context, snapshot) {
              //           if (snapshot.connectionState == ConnectionState.waiting) {
              //             return Center(child: CircularLoader());
              //           }
              //           if (snapshot.hasError) {
              //             return Container(
              //               height: MediaQuery.of(context).size.height * 0.70,
              //               child: Center(
              //                 child: Image.asset("assets/images/no_data.gif"),
              //               ),
              //             );
              //           }
              //           if (snapshot.hasData) {
              //             return Container(
              //                 padding: EdgeInsets.all(20),
              //                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                   // Checkbox(
              //                   //     value: checked,
              //                   //     onChanged: (check) => saleAmountBloc
              //                   //         .add(CheckBoxEvent(checked: check!))),
              //
              //                   SizedBox(
              //                     height: 10,
              //                   ),
              //                   Table(
              //                     defaultColumnWidth: FixedColumnWidth(deviceWidth * 0.44),
              //                     border: TableBorder.all(color: Colors.black12, style: BorderStyle.solid, width: 1),
              //                     children: [
              //                       TableRow(children: [
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: TabBarColor,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: Text("  " + "hourly_key".tr(),
              //                                     style: TextStyle(fontSize: 20.0, color: ColorPrimary)),
              //                               ))
              //                         ]),
              //                         Container(
              //                           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                             Container(
              //                                 height: 50,
              //                                 width: deviceWidth * 0.44,
              //                                 color: TabBarColor,
              //                                 child: Align(
              //                                   alignment: Alignment.centerLeft,
              //                                   child: AutoSizeText("  " + "earning_key".tr(),
              //                                       style: TextStyle(fontSize: 18.0, color: ColorPrimary)),
              //                                 ))
              //                           ]),
              //                         ),
              //                       ]),
              //                       TableRow(children: [
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: Colors.white,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: AutoSizeText(
              //                                   '  ${snapshot.data!.keys.toList()[0]}',
              //                                   style: TextStyle(
              //                                       fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
              //                                   maxFontSize: 14,
              //                                   minFontSize: 12,
              //                                 ),
              //                               ))
              //                         ]),
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: Colors.white,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: Text('  ${snapshot.data!.values.toList()[0]}',
              //                                     style: TextStyle(
              //                                         fontWeight: FontWeight.w600,
              //                                         fontSize: 15.0,
              //                                         color: Colors.black)),
              //                               ))
              //                         ]),
              //                       ]),
              //                       TableRow(children: [
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: Colors.white,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: AutoSizeText(
              //                                   '  ${snapshot.data!.keys.toList()[1]}',
              //                                   style: TextStyle(
              //                                       fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
              //                                   maxFontSize: 14,
              //                                   minFontSize: 12,
              //                                 ),
              //                               ))
              //                         ]),
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: Colors.white,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: Text('  ${snapshot.data!.values.toList()[1]}',
              //                                     style: TextStyle(
              //                                         fontWeight: FontWeight.w600,
              //                                         fontSize: 15.0,
              //                                         color: Colors.black)),
              //                               ))
              //                         ]),
              //                       ]),
              //                       TableRow(children: [
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: Colors.white,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: AutoSizeText(
              //                                   '  ${snapshot.data!.keys.toList()[2]}',
              //                                   style: TextStyle(
              //                                       fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
              //                                   maxFontSize: 14,
              //                                   minFontSize: 12,
              //                                 ),
              //                               ))
              //                         ]),
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: Colors.white,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: Text('  ${snapshot.data!.values.toList()[2]}',
              //                                     style: TextStyle(
              //                                         fontWeight: FontWeight.w600,
              //                                         fontSize: 15.0,
              //                                         color: Colors.black)),
              //                               ))
              //                         ]),
              //                       ]),
              //                       TableRow(children: [
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: Colors.white,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: AutoSizeText(
              //                                   '  ${snapshot.data!.keys.toList()[3]}',
              //                                   style: TextStyle(
              //                                       fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
              //                                   maxFontSize: 14,
              //                                   minFontSize: 12,
              //                                 ),
              //                               ))
              //                         ]),
              //                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                           Container(
              //                               height: 50,
              //                               width: deviceWidth * 0.44,
              //                               color: Colors.white,
              //                               child: Align(
              //                                 alignment: Alignment.centerLeft,
              //                                 child: Text('  ${snapshot.data!.values.toList()[3]}',
              //                                     style: TextStyle(
              //                                         fontWeight: FontWeight.w600,
              //                                         fontSize: 15.0,
              //                                         color: Colors.black)),
              //                               ))
              //                         ]),
              //                       ]),
              //                     ],
              //                   ),
              //                   SizedBox(
              //                     height: 30,
              //                   ),
              //                   Container(
              //                     height: 200,
              //                     child: SfCartesianChart(
              //                       plotAreaBorderWidth: 2,
              //                       plotAreaBorderColor: Colors.transparent,
              //                       //palette: <Color>[ColorPrimary],
              //                       borderColor: Colors.grey.shade500,
              //
              //                       title: ChartTitle(
              //                           text: "earning_amt_inr_key".tr() + " ",
              //                           textStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              //                       // legend: Legend(isVisible: true),
              //                       tooltipBehavior: _tooltipBehavior,
              //                       enableMultiSelection: true,
              //
              //                       series: <ChartSeries>[
              //                         BarSeries<GDPDatass, String>(
              //                             color: ColorPrimary,
              //
              //                             // name: '',
              //                             dataSource: getChartDatass(snapshot.data),
              //                             xValueMapper: (GDPDatass gdp, _) => gdp.continent,
              //                             yValueMapper: (GDPDatass gdp, _) => gdp.sale,
              //                             //  dataLabelSettings: DataLabelSettings(isVisible: true),
              //                             enableTooltip: false)
              //                       ],
              //                       primaryXAxis: CategoryAxis(
              //                           interval: 1,
              //                           majorGridLines: MajorGridLines(width: 0),
              //                           labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              //                           desiredIntervals: 1),
              //                       primaryYAxis: NumericAxis(
              //                         edgeLabelPlacement: EdgeLabelPlacement.shift,
              //                         // desiredIntervals: 6,
              //                         // interval: 2000,
              //
              //                         //numberFormat: NumberFormat.currency(),
              //                         title: AxisTitle(
              //                             alignment: ChartAlignment.center,
              //                             text: "earning_amt_inr_key".tr() + " ",
              //                             textStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              //                       ),
              //                     ),
              //                   )
              //                 ]));
              //           }
              //           return Container();
              //         })),
              SingleChildScrollView(
                  child: FutureBuilder<WithoutInventoryDailyEarningData>(
                      future: getDhabasDay(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularLoader());
                        }
                        if (snapshot.hasError) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.70,
                            child: Center(
                              child: Image.asset("assets/images/no_data.gif"),
                            ),
                          );
                        }
                        return Container(
                            padding: EdgeInsets.all(20),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              // Checkbox(
                              //     value: checked,
                              //     onChanged: (check) => saleAmountBloc
                              //         .add(CheckBoxEvent(checked: check!))),

                              SizedBox(
                                height: 10,
                              ),
                              Table(
                                defaultColumnWidth: FixedColumnWidth(deviceWidth * 0.44),
                                border: TableBorder.all(color: Colors.black12, style: BorderStyle.solid, width: 1),
                                children: [
                                  TableRow(children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                          height: 50,
                                          width: deviceWidth * 0.44,
                                          color: TabBarColor,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("  " + "day_key".tr(),
                                                style: TextStyle(fontSize: 20.0, color: ColorPrimary)),
                                          ))
                                    ]),
                                    Container(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Container(
                                            height: 50,
                                            width: deviceWidth * 0.44,
                                            color: TabBarColor,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText("  " + "earning_key".tr(),
                                                  style: TextStyle(fontSize: 18.0, color: ColorPrimary)),
                                            ))
                                      ]),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                          height: 50,
                                          width: deviceWidth * 0.44,
                                          color: Colors.white,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              '  ${snapshot.data!.today}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
                                              maxFontSize: 14,
                                              minFontSize: 12,
                                            ),
                                          ))
                                    ]),
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                          height: 50,
                                          width: deviceWidth * 0.44,
                                          color: Colors.white,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('  ${snapshot.data!.todayEarning}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.black)),
                                          ))
                                    ]),
                                  ]),
                                  TableRow(children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                          height: 50,
                                          width: deviceWidth * 0.44,
                                          color: Colors.white,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              '  ${snapshot.data!.yesterday}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
                                              maxFontSize: 14,
                                              minFontSize: 12,
                                            ),
                                          ))
                                    ]),
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                          height: 50,
                                          width: deviceWidth * 0.44,
                                          color: Colors.white,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('  ${snapshot.data!.yesterdayEarning}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.black)),
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
                                      text: "earning_amt_inr_key".tr() + " ",
                                      textStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                  tooltipBehavior: _tooltipBehavior,
                                  // enableMultiSelection: true,
                                  zoomPanBehavior: ZoomPanBehavior(
                                    enablePanning: true,
                                    enablePinching: true,
                                    zoomMode: ZoomMode.x,
                                  ),
                                  series: <ChartSeries>[
                                    LineSeries<GDPData, String>(
                                        color: ColorPrimary,

                                        // name: '',
                                        dataSource: getChartData(snapshot.data),
                                        xValueMapper: (GDPData gdp, _) => gdp.continent,
                                        yValueMapper: (GDPData gdp, _) => gdp.sale,
                                        //  dataLabelSettings: DataLabelSettings(isVisible: true),
                                        enableTooltip: false)
                                  ],
                                  primaryXAxis: CategoryAxis(
                                      majorGridLines: MajorGridLines(width: 0),
                                      labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                      desiredIntervals: 8),
                                  primaryYAxis: NumericAxis(
                                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                                    // desiredIntervals: 6,
                                    // interval: 2000,

                                    //numberFormat: NumberFormat.currency(),
                                    title: AxisTitle(
                                        alignment: ChartAlignment.center,
                                        text: "earning_amt_inr_key".tr() + " ",
                                        textStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                  ),
                                ),
                              )
                            ]));
                      })),
              SingleChildScrollView(
                  child:FutureBuilder<WithoutInventoryMonthlyEarningData>(
                         future: getDhabasMonthly(),
                  //    stream: controller.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularLoader());
                        }
                        if (snapshot.hasError) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.70,
                            child: Center(
                              child: Image.asset("assets/images/no_data.gif"),
                            ),
                          );
                        }
                        if (snapshot.hasData == null) {
                          return Center(
                            child: Image.asset("assets/images/no_data.gif"),
                          );
                        }
                        if (snapshot.hasData) {
                          return Container(
                              padding: EdgeInsets.all(20),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                // Checkbox(
                                //     value: checked,
                                //     onChanged: (check) => saleAmountBloc
                                //         .add(CheckBoxEvent(checked: check!))),

                                SizedBox(
                                  height: 10,
                                ),
                                Table(
                                  defaultColumnWidth: FixedColumnWidth(deviceWidth * 0.44),
                                  border: TableBorder.all(color: Colors.black12, style: BorderStyle.solid, width: 1),
                                  children: [
                                    TableRow(children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Container(
                                            height: 50,
                                            width: deviceWidth * 0.44,
                                            color: TabBarColor,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("  " + "day_key".tr(),
                                                  style: TextStyle(fontSize: 20.0, color: ColorPrimary)),
                                            ))
                                      ]),
                                      Container(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Container(
                                              height: 50,
                                              width: deviceWidth * 0.44,
                                              color: TabBarColor,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: AutoSizeText("  " + "earning_key".tr(),
                                                    style: TextStyle(fontSize: 18.0, color: ColorPrimary)),
                                              ))
                                        ]),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Container(
                                            height: 50,
                                            width: deviceWidth * 0.44,
                                            color: Colors.white,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                '  ${snapshot.data!.month}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
                                                maxFontSize: 14,
                                                minFontSize: 12,
                                              ),
                                            ))
                                      ]),
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Container(
                                            height: 50,
                                            width: deviceWidth * 0.44,
                                            color: Colors.white,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('  ${snapshot.data!.monthlyEarning}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15.0,
                                                      color: Colors.black)),
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
                                        text: "earning_amt_inr_key".tr() + " ",
                                        textStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                    tooltipBehavior: _tooltipBehavior,
                                    // enableMultiSelection: true,
                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePanning: true,
                                      enablePinching: true,
                                      zoomMode: ZoomMode.x,
                                    ),
                                    series: <ChartSeries>[
                                      BarSeries<GDPDatas, String>(
                                          color: ColorPrimary,

                                          // name: '',
                                          dataSource: getChartDatas(snapshot.data),
                                          xValueMapper: (GDPDatas gdp, _) => gdp.continent,
                                          yValueMapper: (GDPDatas gdp, _) => gdp.sale,
                                          //  dataLabelSettings: DataLabelSettings(isVisible: true),
                                          enableTooltip: false)
                                    ],
                                    primaryXAxis: CategoryAxis(
                                        majorGridLines: MajorGridLines(width: 0),
                                        labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                        desiredIntervals: 8),
                                    primaryYAxis: NumericAxis(
                                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                                      // desiredIntervals: 6,
                                      // interval: 2000,

                                      //numberFormat: NumberFormat.currency(),
                                      title: AxisTitle(
                                          alignment: ChartAlignment.center,
                                          text: "earning_amt_inr_key".tr() + " ",
                                          textStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                    ),
                                  ),
                                )
                              ]));
                        }
                        return Center(
                          child: Text("data_not_found_key".tr()),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }

  List<GDPData> getChartData(WithoutInventoryDailyEarningData? data) {
    final List<GDPData> chartData = [
      GDPData(
        'today_key'.tr(),
        double.parse(data!.todayEarning.toString()),
      ),
      GDPData(' ', 0),
      GDPData("yesterday_key".tr(), double.parse(data.yesterdayEarning.toString())),
    ];
    return chartData;
  }

  List<GDPDatas> getChartDatas(WithoutInventoryMonthlyEarningData? data) {
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

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Daily_Sale.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Hourly_Sale.dart';
import 'package:vendor/model/chat_papdi_module/without_inventory_Monthly_Sale.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/widget/progress_indecator.dart';

class SaleAmount extends StatefulWidget {
  SaleAmount({Key? key}) : super(key: key);

  @override
  _SaleAmountState createState() => _SaleAmountState();
}

class _SaleAmountState extends State<SaleAmount> {
  TooltipBehavior? _tooltipBehavior;
  WithoutInventoryDailySaleResponse? resultDaily;
  WithoutInventoryMonthlySaleResponse? resultMonthly;
  Map<String, String>? resultHourlyMap = {};

  WithoutInventoryHourlySaleResponse? resultHourly;
  List<String> demo = [];

  Future<WithoutInventoryDailySaleData> getDhabasDay() async {
    resultDaily = await ApiProvider().getChatPapdiDailySaleAmount();
    log('${resultDaily!.data}');
    return resultDaily!.data!;
  }

  Future<WithoutInventoryMonthlySaleData> getDhabasMonthly() async {
    resultMonthly = await ApiProvider().getChatPapdiMonthlySaleAmount();
    log('${resultMonthly!.data}');
    return resultMonthly!.data!;
  }

  Future<Map<String, String>> getDhabasHourly() async {
    resultHourly = (await ApiProvider().getChatPapdiHourlySaleAmount());
    log('${resultHourly!.data}');
    //resultHourlyMap = resultHourly!.data!;
    //for (var i = 0; i < resultHourly!.data!.length; i++) {
    demo = resultHourly!.data!.keys.toList();
    //}

    return resultHourly!.data!;
  }

  @override
  void initState() {
    // TODO: implement initState
    // getDhabasHourly();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeigth = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
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
            title: Text('sale_amount_key'.tr()),
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
              //           //  for (var i = 0; i < snapshot.data.length; i++) {
              //
              //           //  }
              //
              //           if (snapshot.connectionState == ConnectionState.waiting) {
              //             return Center(child: CircularLoader());
              //           }
              //           if (snapshot.hasError) {
              //             log("snapshot==>${snapshot.error}");
              //             return Container(
              //               height: MediaQuery.of(context).size.height * 0.70,
              //               child: Center(
              //                 child: Image.asset("assets/images/no_data.gif"),
              //               ),
              //             );
              //           }
              //           if (snapshot.hasData) {
              //             log("snapshot==>${snapshot.data}");
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
              //                                   child: AutoSizeText("  " + "sale_key".tr(),
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
              //
              //                       //palette: <Color>[ColorPrimary],
              //                       borderColor: Colors.grey.shade500,
              //
              //                       title: ChartTitle(
              //                           text: "sale_amt_inr_key".tr(),
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
              //                         edgeLabelPlacement: EdgeLabelPlacement.none,
              //                         // desiredIntervals: 6,
              //                         // interval: 2000,
              //
              //                         //numberFormat: NumberFormat.currency(),
              //                         title: AxisTitle(
              //                             alignment: ChartAlignment.center,
              //                             text: "sale_amt_inr_key".tr(),
              //                             textStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              //                       ),
              //                     ),
              //                   )
              //                 ]));
              //           }
              //           return Container();
              //         })),
              SingleChildScrollView(
                  child: FutureBuilder<WithoutInventoryDailySaleData>(
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
                                              child: AutoSizeText("  " + "sale_key".tr(),
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
                                            child: Text('  ${snapshot.data!.todaySaleAmount}',
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
                                            child: Text('  ${snapshot.data!.yesterdaySaleAmount}',
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
                                height: 250,
                                child: SfCartesianChart(
                                  plotAreaBorderWidth: 2,
                                  plotAreaBorderColor: Colors.transparent,
                                  //palette: <Color>[ColorPrimary],
                                  borderColor: Colors.grey.shade500,

                                  title: ChartTitle(
                                      text: "sale_amt_inr_key".tr(),
                                      textStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                  // legend: Legend(isVisible: true),
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
                                        text: "sale_amt_inr_key".tr(),
                                        textStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                  ),
                                ),
                              )
                            ]));
                      })),
              SingleChildScrollView(
                  child: FutureBuilder<WithoutInventoryMonthlySaleData>(
                      future: getDhabasMonthly(),
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
                                              child: AutoSizeText("  " + "sale_key".tr(),
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
                                            child: Text('  ${snapshot.data!.saleAmount}',
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
                                height: 250,
                                child: SfCartesianChart(
                                  plotAreaBorderWidth: 2,
                                  plotAreaBorderColor: Colors.transparent,
                                  //palette: <Color>[ColorPrimary],
                                  borderColor: Colors.grey.shade500,

                                  title: ChartTitle(
                                      text: "sale_amt_inr_key".tr(),
                                      textStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                  tooltipBehavior: _tooltipBehavior,
                                  // enableMultiSelection: true,
                                  zoomPanBehavior: ZoomPanBehavior(
                                    enablePanning: true,
                                    enablePinching: true,
                                    zoomMode: ZoomMode.x,
                                  ),

                                  series: <ChartSeries>[
                                    LineSeries<GDPDatas, String>(
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
                                        text: "sale_amt_inr_key".tr(),
                                        textStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
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

  List<GDPData> getChartData(WithoutInventoryDailySaleData? data) {
    final List<GDPData> chartData = [
      GDPData(
        'today_key'.tr(),
        double.parse(data!.todaySaleAmount.toString()),
      ),
      GDPData(' ', 0),
      GDPData(
        "yesterday_key".tr(),
        double.parse(data.yesterdaySaleAmount.toString()),
      ),
    ];
    return chartData;
  }

  List<GDPDatas> getChartDatas(WithoutInventoryMonthlySaleData? data) {
    final List<GDPDatas> chartData = [
      GDPDatas(
        '${data!.month}',
        double.parse(data.saleAmount.toString()),
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
      GDPDatass('${data.keys.toList()[2]}', double.parse(data.values.toList()[2])),
      GDPDatass('${data.keys.toList()[3]}', double.parse(data.values.toList()[3])),
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

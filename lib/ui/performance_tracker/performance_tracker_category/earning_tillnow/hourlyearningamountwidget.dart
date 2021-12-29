import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/hourly_earning.dart';
import 'package:vendor/ui/performance_tracker/listner/performancetrackerlistner.dart';
import 'package:vendor/utility/color.dart';

class HourlyEarningAmount extends StatefulWidget {
  final Function(PerformanceTrackerListner hourlyListner) onInit;
  HourlyEarningAmount({Key? key, required this.onInit}) : super(key: key);

  @override
  _HourlyEarningAmountState createState() => _HourlyEarningAmountState();
}

class _HourlyEarningAmountState extends State<HourlyEarningAmount>
    implements PerformanceTrackerListner {
  TooltipBehavior? _tooltipBehavior;
  HourlyEarningAmountResponse? resultHourly;
  StreamController<Map<String, String>> controller = StreamController();
  Future<Map<String, String>> getDhabasHourly({catid}) async {
    resultHourly = (await ApiProvider()
        .getHourlyEarningAmount(catid == null ? "" : catid));
    log('${resultHourly!.data}');
    controller.add(resultHourly!.data!);
    return resultHourly!.data!;
  }

  void initState() {
    widget.onInit(this);
    super.initState();
    getDhabasHourly();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        child: StreamBuilder<Map<String, String>>(
            stream: controller.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(color: ColorPrimary));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("data_not_found_key".tr()),
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
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "  " + "hourly_key".tr(),
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: ColorPrimary)),
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
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                  "  " + "earning_key".tr(),
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: ColorPrimary)),
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
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              '  ${snapshot.data!.keys.toList()[0]}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
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
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                '  ${(double.parse(snapshot.data!.values.toList()[0]).toStringAsFixed(2))}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15.0,
                                                    color: Colors.black)),
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
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              '  ${snapshot.data!.keys.toList()[1]}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
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
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                '  ${(double.parse(snapshot.data!.values.toList()[1]).toStringAsFixed(2))}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15.0,
                                                    color: Colors.black)),
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
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              '  ${snapshot.data!.keys.toList()[2]}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
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
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                '  ${(double.parse(snapshot.data!.values.toList()[2]).toStringAsFixed(2))}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15.0,
                                                    color: Colors.black)),
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
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              '  ${snapshot.data!.keys.toList()[3]}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
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
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                '  ${(double.parse(snapshot.data!.values.toList()[3]).toStringAsFixed(2))}',
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
                                    dataSource: getChartDatass(snapshot.data),
                                    xValueMapper: (GDPDatass gdp, _) =>
                                        gdp.continent,
                                    yValueMapper: (GDPDatass gdp, _) =>
                                        gdp.sale,
                                    //  dataLabelSettings: DataLabelSettings(isVisible: true),
                                    enableTooltip: false)
                              ],
                              primaryXAxis: CategoryAxis(
                                  interval: 1,
                                  majorGridLines: MajorGridLines(width: 0),
                                  labelStyle: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                  desiredIntervals: 1),
                              primaryYAxis: NumericAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                // desiredIntervals: 6,
                                // interval: 2000,

                                //numberFormat: NumberFormat.currency(),
                                title: AxisTitle(
                                    alignment: ChartAlignment.center,
                                    text: "earning_amt_inr_key".tr() + " ",
                                    textStyle: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600)),
                              ),
                            ),
                          )
                        ]));
              }
              return Container();
            }));
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

  @override
  void onFiterSelect(String? catid, String? productid, String? date) {
    getDhabasHourly(catid: catid ?? "");
  }
}

class GDPDatass {
  GDPDatass(this.continent, this.sale);

  final String continent;
  final double sale;
}

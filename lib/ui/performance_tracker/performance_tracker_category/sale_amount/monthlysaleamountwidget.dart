import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/monthly_sale_amount.dart';
import 'package:vendor/ui/performance_tracker/listner/performancetrackerlistner.dart';
import 'package:vendor/utility/color.dart';

class MonthlySaleAmount extends StatefulWidget {
  final Function(PerformanceTrackerListner monthlyListner) onInit;
  MonthlySaleAmount({Key? key, required this.onInit}) : super(key: key);

  @override
  _MonthlySaleAmountState createState() => _MonthlySaleAmountState();
}

class _MonthlySaleAmountState extends State<MonthlySaleAmount> implements PerformanceTrackerListner {
  StreamController<MonthlySellAmountData> controller = StreamController();
  TooltipBehavior? _tooltipBehavior;
  MonthlySellAmountResponse? resultMonthly;
  getDhabasMonthly({catid, productid, month}) async {
    resultMonthly = await ApiProvider().getMonthlySaleAmount(
      catid == null ? "" : catid,
      productid == null ? "" : productid,
      month == null ? "" : month,
    );
    log('${resultMonthly!.data}');
    controller.add(resultMonthly!.data!);
    return resultMonthly!.data!;
  }

  @override
  void initState() {
    widget.onInit(this);
    super.initState();
    getDhabasMonthly();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<MonthlySellAmountData>(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: ColorPrimary));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("data_not_found_key".tr()),
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
                              child: Text("  " + "monthly_key".tr(),
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
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
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
                              child: Text('  ${(double.parse(snapshot.data!.saleAmount)).toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.black)),
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
                    title: ChartTitle(
                        text: "sale_amt_inr_key".tr(), textStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    // legend: Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,

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
                        desiredIntervals: 1),
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
        });
  }

  List<GDPDatas> getChartDatas(MonthlySellAmountData? data) {
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

  @override
  void onFiterSelect(String? catid, String? productid, String? date) {
    getDhabasMonthly(catid: catid ?? "", productid: productid ?? "", month: date ?? "");
  }
}

class GDPDatas {
  GDPDatas(this.continent, this.sale);
  final String continent;
  final double sale;
}

import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/daily_sale_amount.dart';

import 'package:vendor/utility/color.dart';

class DailySaleAmount extends StatefulWidget {
  DailySaleAmount({Key? key}) : super(key: key);

  @override
  _DailySaleAmountState createState() => _DailySaleAmountState();
}

class _DailySaleAmountState extends State<DailySaleAmount> {
  StreamController<DailySellAmountData> controller = StreamController();
  TooltipBehavior? _tooltipBehavior;
  DailySellAmountResponse? resultDaily;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDhabasDay();
  }

  getDhabasDay({catid, productid, date}) async {
    resultDaily = (await ApiProvider().getDailySaleAmount(
        catid == null ? "" : catid,
        productid == null ? "" : productid,
        date == null ? "" : date));
    log('${resultDaily!.data}');
    controller.add(resultDaily!.data!);
    return resultDaily!.data!;
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeigth = MediaQuery.of(context).size.height;
    return StreamBuilder<DailySellAmountData>(
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
                      defaultColumnWidth: FixedColumnWidth(deviceWidth * 0.44),
                      border: TableBorder.all(
                          color: Colors.black12,
                          style: BorderStyle.solid,
                          width: 1),
                      children: [
                        TableRow(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 50,
                                    width: deviceWidth * 0.44,
                                    color: TabBarColor,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("  " + "day_key".tr(),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: ColorPrimary)),
                                    ))
                              ]),
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 50,
                                      width: deviceWidth * 0.44,
                                      color: TabBarColor,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                            "  " + "sale_key".tr(),
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: ColorPrimary)),
                                      ))
                                ]),
                          ),
                        ]),
                        TableRow(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 50,
                                    width: deviceWidth * 0.44,
                                    color: Colors.white,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        '  ${snapshot.data!.date}',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 50,
                                    width: deviceWidth * 0.44,
                                    color: Colors.white,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          '  ${(double.parse(snapshot.data!.todaySaleAmount)).toStringAsFixed(2)}',
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
                            text: "sale_amt_inr_key".tr(),
                            textStyle: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600)),
                        // legend: Legend(isVisible: true),
                        tooltipBehavior: _tooltipBehavior,
                        enableMultiSelection: true,

                        series: <ChartSeries>[
                          BarSeries<GDPData, String>(
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
                            labelStyle: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                            desiredIntervals: 1),
                        primaryYAxis: NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          // desiredIntervals: 6,
                          // interval: 2000,

                          //numberFormat: NumberFormat.currency(),
                          title: AxisTitle(
                              alignment: ChartAlignment.center,
                              text: "sale_amt_inr_key".tr(),
                              textStyle: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade600)),
                        ),
                      ),
                    )
                  ]));
        });
  }

  List<GDPData> getChartData(DailySellAmountData? data) {
    final List<GDPData> chartData = [
      GDPData(
        'TODAY',
        double.parse(data!.todaySaleAmount.toString()),
      ),
      GDPData(' ', 0),
      GDPData(
        "",
        0,
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

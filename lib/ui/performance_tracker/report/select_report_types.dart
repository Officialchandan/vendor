import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:vendor/main.dart';
import 'package:vendor/provider/Endpoint.dart';
import 'package:vendor/provider/server_error.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/performance_tracker/report/daily_report.dart';
import 'package:vendor/ui/performance_tracker/report/generated_coin_report.dart';
import 'package:vendor/ui/performance_tracker/report/product_redeem_report.dart';
import 'package:vendor/ui/performance_tracker/report/sale_return_report.dart';
import 'package:vendor/ui/performance_tracker/report/view_report_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import 'coin_redeem_report.dart';

class SelectReportTypeScreen extends StatefulWidget {
  const SelectReportTypeScreen({Key? key}) : super(key: key);

  @override
  _SelectReportTypeScreenState createState() => _SelectReportTypeScreenState();
}

class _SelectReportTypeScreenState extends State<SelectReportTypeScreen> {
  List<Map<String, dynamic>> reportList = [];
  final options = [
    {"title": "Daily Sales", "subTitle": "click here to add product", "image": "assets/images/tr-ic1.png", "id": 1},
    {"title": "Coin Generated", "subTitle": "click here to add product", "image": "assets/images/tr-ic2.png", "id": 2},
    {"title": "Sales Return", "subTitle": "click here to add product", "image": "assets/images/tr-ic3.png", "id": 3},
    {"title": "Ready Stock", "subTitle": "click here to add product", "image": "assets/images/tr-ic3.png", "id": 4},
    // {"title": "Purchase return", "subTitle": "click here to add product", "image": "assets/images/tr-ic3.png", "id": 5},
    // {"title": "Purchase order entry", "subTitle": "click here to add product", "image": "assets/images/tr-ic3.png", "id": 6},
    {"title": "Product Redeemed", "subTitle": "click here to add product", "image": "assets/images/tr-ic3.png", "id": 7},
    {"title": "Coin Redeemed", "subTitle": "click here to add product", "image": "assets/images/tr-ic3.png", "id": 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Report Types",
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Stack(
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      if (options[index]["id"] == 1) {
                        Navigator.push(context, PageTransition(child: DailyReport(), type: PageTransitionType.fade));
                      } else if (options[index]["id"] == 2) {
                        Navigator.push(context, PageTransition(child: GeneratedCoinReport(), type: PageTransitionType.fade));
                      } else if (options[index]["id"] == 3) {
                        Navigator.push(context, PageTransition(child: SaleReturnReport(), type: PageTransitionType.fade));
                      } else if (options[index]["id"] == 4) {
                        getReport(context);
                      } else if (options[index]["id"] == 7) {
                        Navigator.push(context, PageTransition(child: ProductRedeemReport(), type: PageTransitionType.fade));
                      } else if (options[index]["id"] == 8) {
                        Navigator.push(context, PageTransition(child: CoinRedeemReport(), type: PageTransitionType.fade));
                      } else {
                        Navigator.push(
                            context, PageTransition(child: ViewReportScreen(options[index]), type: PageTransitionType.fade));
                      }
                    },
                    title: Text("${options[index]["title"]}"),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                ),
                Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 5,
                      decoration: BoxDecoration(
                          color: ColorPrimary,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                    ))
              ],
            ),
          );
        },
        itemCount: options.length,
      ),
    );
  }

  void getReport(BuildContext context) async {
    if (await Network.isConnected()) {
      Map input = HashMap<String, dynamic>();
      // input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["vendor_id"] = "1";
      String url = Endpoint.GET_READY_STOCK_REPORT;

      EasyLoading.show();

      try {
        Response response = await dio.post(url, data: input);
        Map<String, dynamic> result = json.decode(response.toString());
        EasyLoading.dismiss();
        print("result-->$result");
        if (result["success"]) {
          List<Map<String, dynamic>> report = List<Map<String, dynamic>>.from(result["data"]!.map((x) => x));
          reportList = report;
          print("report-->$report");
          exportReport(context);
        } else {
          EasyLoading.dismiss();
          Utility.showToast(response.data["message"]);
        }
      } catch (exception) {
        print("exception-->$exception");
        if (exception is DioError) {
          ServerError e = ServerError.withError(error: exception);
        }
        EasyLoading.dismiss();
      }
    } else {
      Utility.showToast("Please check your internet connection");
    }
  }

  void exportReport(BuildContext context) async {
    print("exportReport");
    final xls.Workbook workbook = xls.Workbook(0);
    //Adding a Sheet with name to workbook.
    final xls.Worksheet sheet1 = workbook.worksheets.addWithName('Coin Redeem Report');
    sheet1.showGridlines = true;

    int columnIndex = 1;
    int rowIndex = 1;

    double total = 0.0;

    sheet1.getRangeByIndex(1, 1, 1, reportList.first.keys.length).merge();

    sheet1.getRangeByIndex(rowIndex, columnIndex).value = "Ready Stock Report";

    sheet1.getRangeByIndex(rowIndex, columnIndex).rowHeight = 30;
    sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.hAlign = xls.HAlignType.center;
    sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.vAlign = xls.VAlignType.center;
    rowIndex = rowIndex + 1;

    reportList.first.keys.forEach((element) {
      sheet1.getRangeByIndex(rowIndex, columnIndex).value = element.toString();
      sheet1.getRangeByIndex(rowIndex, columnIndex).columnWidth = 25;
      sheet1.getRangeByIndex(rowIndex, columnIndex).rowHeight = 20;
      sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.hAlign = xls.HAlignType.center;
      sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.vAlign = xls.VAlignType.center;
      columnIndex = columnIndex + 1;
    });

    reportList.forEach((element) {
      columnIndex = 1;
      rowIndex = rowIndex + 1;
      element.forEach((key, value) {
        sheet1.getRangeByIndex(rowIndex, columnIndex).value = value;
        sheet1.getRangeByIndex(rowIndex, columnIndex).columnWidth = 25;
        sheet1.getRangeByIndex(rowIndex, columnIndex).rowHeight = 20;
        sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.hAlign = xls.HAlignType.center;
        sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.vAlign = xls.VAlignType.center;
        columnIndex = columnIndex + 1;

        if (key == "stock") {
          print("value - >$value");
          print("total - >$total");
          total = double.parse(value.toString()) + total;
        }
      });
    });

    print("total - >$total");

    sheet1.getRangeByIndex(rowIndex + 1, 1).value = "Total";
    sheet1.getRangeByIndex(rowIndex + 1, 1).cellStyle.hAlign = xls.HAlignType.center;
    sheet1.getRangeByIndex(rowIndex + 1, 1).cellStyle.vAlign = xls.VAlignType.center;

    final xls.Style style = workbook.styles.add('Style1');
    style.backColorRgb = Colors.red;
    style.hAlign = xls.HAlignType.center;
    style.vAlign = xls.VAlignType.center;
    style.fontColorRgb = Colors.white;
    style.bold = true;

    int index = reportList.first.keys.toList().indexWhere((element) => element == "stock");
    if (index != -1) {
      sheet1.getRangeByIndex(rowIndex + 1, index + 1).value = total;
      sheet1.getRangeByIndex(rowIndex + 1, index + 1).cellStyle = style;
    }

    final List<int> bytes = workbook.saveAsStream();
    String? path;
    final Directory? directory;

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationSupportDirectory();
    }

    path = directory!.path;

    var savedDir = Directory(path);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    String fileName = "ready_stock_report" + DateTime.now().millisecondsSinceEpoch.toString() + ".xlsx";

    final File file = File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true).whenComplete(() {
      print("completed");
      Utility.showToast("Report saved at below location \n${file.path}");
    });
    print("savedDir${file.path}");

    workbook.dispose();

    OpenFile.open(file.path);
  }
}

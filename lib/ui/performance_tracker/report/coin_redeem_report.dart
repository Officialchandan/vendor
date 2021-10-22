import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/provider/Endpoint.dart';
import 'package:vendor/provider/server_error.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/category_bottom_sheet.dart';
import 'package:vendor/widget/custom_bottom_sheet.dart';

import '../../../main.dart';

class CoinRedeemReport extends StatefulWidget {
  const CoinRedeemReport({Key? key}) : super(key: key);

  @override
  _CoinRedeemReportState createState() => _CoinRedeemReportState();
}

class _CoinRedeemReportState extends State<CoinRedeemReport> {
  int groupValue = 1;
  String startDate = "";
  String endDate = "";
  CategoryModel? categoryModel;

  Option? days;
  DateRangePickerController dateRangePickerController = DateRangePickerController();

  TextEditingController edtCategory = TextEditingController();
  TextEditingController edtDays = TextEditingController();
  TextEditingController edtProducts = TextEditingController();
  TextEditingController edtReportType = TextEditingController();

  List<Map<String, dynamic>> reportList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Coin Redeemed Reports",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text("View report by"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                      title: Text("Date wise"),
                      value: 1,
                      groupValue: groupValue,
                      onChanged: (value) {
                        groupValue = value as int;
                        setState(() {});
                      }),
                ),
                Expanded(
                  child: RadioListTile(
                      title: Text("Day wise"),
                      value: 2,
                      groupValue: groupValue,
                      onChanged: (value) {
                        groupValue = value as int;
                        setState(() {});
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            groupValue == 1
                ? SfDateRangePicker(
                    maxDate: DateTime.now(),
                    controller: dateRangePickerController,
                    minDate: DateTime(2000),
                    enablePastDates: true,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      enableSwipeSelection: true,
                      showTrailingAndLeadingDates: true,
                      firstDayOfWeek: 1,
                    ),
                    allowViewNavigation: true,
                    todayHighlightColor: Colors.grey.shade300,
                    headerStyle: DateRangePickerHeaderStyle(
                      textStyle: TextStyle(color: ColorPrimary),
                    ),
                    yearCellStyle: DateRangePickerYearCellStyle(textStyle: TextStyle(color: Colors.black)),
                    // showActionButtons: true,
                    showNavigationArrow: false,
                    selectionMode: DateRangePickerSelectionMode.range,
                    endRangeSelectionColor: ColorPrimary,
                    startRangeSelectionColor: ColorPrimary,
                    rangeSelectionColor: Colors.blue.shade50,
                    onSelectionChanged: _onSelectionChanged)
                : TextFormField(
                    controller: edtDays,
                    onTap: () {
                      selectDays(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: "Choose report days",
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: ColorPrimary,
                        ),
                        suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)),
                  ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: edtCategory,
              onTap: () {
                selectCategory(context);
              },
              readOnly: true,
              decoration: InputDecoration(
                  hintText: "Choose category",
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    color: ColorPrimary,
                  ),
                  suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: edtProducts,
              onTap: () {},
              readOnly: true,
              decoration: InputDecoration(
                  hintText: "Choose product",
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    color: ColorPrimary,
                  ),
                  suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          getReport(context);
        },
        height: 50,
        shape: RoundedRectangleBorder(),
        color: ColorPrimary,
        child: Text(
          "Export",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args.value);

    if (args.value is PickerDateRange) {
      startDate = Utility.getFormatDate(args.value.startDate);
      endDate = Utility.getFormatDate(args.value.endDate ?? args.value.startDate);
    }
  }

  void selectDays(BuildContext context) async {
    final List<Option> options = [
      Option(optionName: "1 day", optionId: "1"),
      Option(optionName: "5 days", optionId: "5"),
      Option(optionName: "7 days", optionId: "7"),
      Option(optionName: "15 days", optionId: "15"),
      Option(optionName: "30 days", optionId: "30"),
    ];
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        builder: (context) {
          return CustomBottomSheet(
            onOptionSelect: (Option option) {
              edtDays.text = option.optionName;
              days = option;
            },
            options: options,
          );
        });
  }

  void selectCategory(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        builder: (context) {
          return CategoryBottomSheet(
            onSelect: (CategoryModel option) {
              edtCategory.text = option.categoryName!;
              categoryModel = option;
            },
          );
        });
  }

  void getReport(BuildContext context) async {
    if (await Network.isConnected()) {
      Map input = HashMap<String, dynamic>();
      // input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["vendor_id"] = "1";
      String url = "";

      if (groupValue == 1) {
        url = Endpoint.GET_COIN_REDEEM_REPORT_BY_DATE;
        input["from_date"] = startDate;
        input["to_date"] = endDate;
      } else {
        url = Endpoint.GET_COIN_REDEEM_REPORT_BY_DAY;
        if (days == null) {
          Utility.showToast("Please select days");
          return;
        } else {
          input["days"] = days!.optionId;
        }
      }
      input["category_id"] = categoryModel == null ? "" : categoryModel!.id;
      input["product_id"] = "";
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
    double totalMrp = 0.0;
    double totalPurchasePrice = 0.0;

    sheet1.getRangeByIndex(1, 1, 1, reportList.first.keys.length).merge();
    if (groupValue == 1) {
      sheet1.getRangeByIndex(rowIndex, columnIndex).value = "Coin Redeem Report ($startDate to $endDate)";
    } else {
      sheet1.getRangeByIndex(rowIndex, columnIndex).value = "Coin Redeem Report (${days!.optionName})";
    }

    sheet1.getRangeByIndex(rowIndex, columnIndex).rowHeight = 30;
    sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.hAlign = xls.HAlignType.center;
    sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.vAlign = xls.VAlignType.center;
    rowIndex = rowIndex + 1;

    reportList.first.keys.forEach((element) {
      sheet1.getRangeByIndex(rowIndex, columnIndex).value = element.toString().replaceAll("_", " ").toUpperCase();
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

        if (key == "redeem_coins") {
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
    columnIndex = 1;
    reportList.first.forEach((key, value) {
      sheet1.getRangeByIndex(rowIndex + 1, columnIndex).cellStyle = style;
      columnIndex = columnIndex + 1;
    });

    int index = reportList.first.keys.toList().indexWhere((element) => element == "redeem_coins");
    if (index != -1) {
      sheet1.getRangeByIndex(rowIndex + 1, index + 1).value = total;
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

    String fileName = "coin_redeem_report_";

    if (groupValue == 1) {
      fileName += "$startDate to $endDate" + ".xlsx";
      sheet1.getRangeByIndex(rowIndex, columnIndex).value = "Coin Redeem Report ($startDate to $endDate)";
    } else {
      fileName += "${days!.optionName}" + ".xlsx";
    }

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

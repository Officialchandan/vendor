import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:vendor/main.dart';
import 'package:vendor/provider/Endpoint.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/custom_bottom_sheet.dart';

class ViewReportScreen extends StatefulWidget {
  @override
  _ViewReportScreenState createState() => _ViewReportScreenState();
}

class _ViewReportScreenState extends State<ViewReportScreen> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  int groupValue = 1;
  String startDate = "";
  String endDate = "";

  TextEditingController edtCategory = TextEditingController();
  TextEditingController edtDays = TextEditingController();
  TextEditingController edtProducts = TextEditingController();
  TextEditingController edtReportType = TextEditingController();

  List<Map<String, dynamic>> reportList = [
    {"order_id": 10, "product_id": 2, "product_name": "Oneplus buds", "customer_id": 48, "mobile": "7777777777", "total": "2000.00"},
    {"order_id": 10, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 48, "mobile": "7777777777", "total": "2000.00"},
    {"order_id": 11, "product_id": 2, "product_name": "Oneplus buds", "customer_id": 48, "mobile": "7777777777", "total": "2000.00"},
    {"order_id": 11, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 48, "mobile": "7777777777", "total": "2000.00"},
    {"order_id": 12, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 13, "product_id": 2, "product_name": "Oneplus buds", "customer_id": 48, "mobile": "7777777777", "total": "2000.00"},
    {"order_id": 13, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 48, "mobile": "7777777777", "total": "2000.00"},
    {"order_id": 14, "product_id": 2, "product_name": "Oneplus buds", "customer_id": 48, "mobile": "7777777777", "total": "2000.00"},
    {"order_id": 14, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 48, "mobile": "7777777777", "total": "2000.00"},
    {"order_id": 15, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 16, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 17, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 18, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 19, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 20, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 21, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 22, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 23, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 24, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 25, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 26, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 27, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"},
    {"order_id": 28, "product_id": 1, "product_name": "Reebok Shoe", "customer_id": 86, "mobile": "9999999999", "total": "900.00"}
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Reports",
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
                    minDate: DateTime(2000),
                    enablePastDates: true,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      enableSwipeSelection: true,
                      showTrailingAndLeadingDates: true,
                      firstDayOfWeek: 1,
                    ),

                    // view: DateRangePickerView.century,
                    allowViewNavigation: true,
                    todayHighlightColor: Colors.grey.shade300,
                    // cellBuilder: (context, detail) {
                    //   return Container(
                    //     child: Expanded(child: Text(detail.date.day.toString())),
                    //   );
                    // },
                    headerStyle: DateRangePickerHeaderStyle(
                      textStyle: TextStyle(color: ColorPrimary),
                    ),
                    yearCellStyle: DateRangePickerYearCellStyle(textStyle: TextStyle(color: Colors.black)),
                    // showActionButtons: true,
                    showNavigationArrow: false,
                    selectionMode: DateRangePickerSelectionMode.extendableRange,
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: edtReportType,
              onTap: () {},
              readOnly: true,
              decoration: InputDecoration(
                  hintText: "Choose report type",
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
    print(args);
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = DateFormat('dd/MM/yyyy').format(args.value.startDate).toString();
        endDate = DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate).toString();
        _range = DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
            ' - ' +
            DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate).toString();

        PickerDateRange dateRange = args.value as PickerDateRange;
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }

      print("_range$_range");
      print("_selectedDate$_selectedDate");
      print("_dateCount$_dateCount");
      print("_rangeCount$_rangeCount");
    });
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
            },
            options: options,
          );
        });
  }

  void selectCategory(BuildContext context) async {
    final List<Option> options = [
      Option(optionName: "Footwear", optionId: "1"),
      Option(optionName: "Cloths", optionId: "2"),
      Option(optionName: "Furniture", optionId: "3"),
      Option(optionName: "Electronics", optionId: "4"),
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
              edtCategory.text = option.optionName;
            },
            options: options,
          );
        });
  }

  void getReport(BuildContext context) async {
    if (await Network.isConnected()) {
      Map input = HashMap<String, dynamic>();
      // input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["vendor_id"] = "1";

      if (groupValue == 1) {
        // input["from_date"] = startDate;
        input["from_date"] = "2021-09-30";
        // input["to_date"] = endDate;
        input["to_date"] = "2021-10-01";
      } else {
        input["days"] = "1";
      }

      input["report_type"] = 1;
      EasyLoading.show();

      try {
        Response response = await dio.post(Endpoint.GENERATE_REPORT, data: input);

        if (response.data["success"]) {
          List<Map<String, dynamic>> report = response.data["data"];
          reportList = report;
          print("report-->$report");
          exportReport(context);
        } else {
          EasyLoading.dismiss();
          Utility.showToast(response.data["message"]);
        }
      } catch (exception) {
        print("exception-->$exception");
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
    final xls.Worksheet sheet1 = workbook.worksheets.addWithName('Report');
    sheet1.showGridlines = true;

    // sheet1.enableSheetCalculations();
    // sheet1.getRangeByIndex(1, 1).columnWidth = 19.13;
    // sheet1.getRangeByIndex(1, 2).columnWidth = 13.65;
    // sheet1.getRangeByIndex(1, 3).columnWidth = 12.25;
    // sheet1.getRangeByIndex(1, 4).columnWidth = 11.35;
    // sheet1.getRangeByIndex(1, 5).columnWidth = 8.09;
    //
    // sheet1.getRangeByName('A1:A18').rowHeight = 19.47;

    int columnIndex = 1;
    int rowIndex = 1;

    double total = 0.0;

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
      element.values.forEach((value) {
        sheet1.getRangeByIndex(rowIndex, columnIndex).value = value;
        sheet1.getRangeByIndex(rowIndex, columnIndex).columnWidth = 25;
        sheet1.getRangeByIndex(rowIndex, columnIndex).rowHeight = 20;
        sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.hAlign = xls.HAlignType.center;
        sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.vAlign = xls.VAlignType.center;
        columnIndex = columnIndex + 1;
      });

      ;
      print("value - >${element.values.last}");
      print("total - >$total");
      total = double.parse(element.values.last.toString()) + total;
    });

    print("total - >$total");

    sheet1.getRangeByIndex(rowIndex + 1, 1).value = "Total";
    sheet1.getRangeByIndex(rowIndex + 1, 1).cellStyle.hAlign = xls.HAlignType.center;
    sheet1.getRangeByIndex(rowIndex + 1, 1).cellStyle.vAlign = xls.VAlignType.center;

    sheet1.getRangeByIndex(rowIndex + 1, reportList.first.values.length).value = total;
    sheet1.getRangeByIndex(rowIndex + 1, reportList.first.values.length).cellStyle.hAlign = xls.HAlignType.center;
    sheet1.getRangeByIndex(rowIndex + 1, reportList.first.values.length).cellStyle.vAlign = xls.VAlignType.center;

    final List<int> bytes = workbook.saveAsStream();
    String? path;
    final Directory directory = await getApplicationSupportDirectory();
    path = directory.path;

    var savedDir = Directory(path);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".xlsx";

    final File file = File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true).whenComplete(() {
      print("completed");
    });
    print("savedDir${file.path}");

    workbook.dispose();

    OpenFile.open(file.path);
  }
}

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart' as sf;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:vendor/api/Endpoint.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/performance_tracker/report/product_list_screen.dart';
import 'package:vendor/ui/performance_tracker/report_data_grid/daily_report_data_grid.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/category_bottom_sheet.dart';
import 'package:vendor/widget/custom_bottom_sheet.dart';

import '../../../main.dart';

class DailyReport extends StatefulWidget {
  final int? chatPapdi;

  DailyReport({this.chatPapdi = 0, Key? key}) : super(key: key);

  @override
  _DailyReportState createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  String startDate = '';
  String endDate = '';
  int groupValue = 1;
  Option? days;
  TextEditingController edtCategory = TextEditingController();
  TextEditingController edtProducts = TextEditingController();
  TextEditingController edtDays = TextEditingController();
  DateRangePickerController dateRangePickerController = DateRangePickerController();
  CategoryModel? categoryModel;
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  List<Map<String, dynamic>> reportList = [];
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  late EmployeeDataSource employeeDataSource;
  List<ProductModel> productList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    edtCategory.dispose();
    edtProducts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "sales_report_key".tr(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text("view_report_by_key".tr()),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                      activeColor: ColorPrimary,
                      title: Text("date_wise_key".tr()),
                      value: 1,
                      groupValue: groupValue,
                      onChanged: (value) {
                        groupValue = value as int;
                        setState(() {});
                      }),
                ),
                Expanded(
                  child: RadioListTile(
                      activeColor: ColorPrimary,
                      title: Text("day_wise_key".tr()),
                      value: 2,
                      groupValue: groupValue,
                      onChanged: (value) {
                        groupValue = value as int;
                        setState(() {});
                      }),
                ),
              ],
            ),
            groupValue == 1
                ? SfDateRangePicker(
                    controller: dateRangePickerController,
                    maxDate: DateTime.now(),
                    minDate: DateTime(2000),
                    enablePastDates: true,
                    monthCellStyle: DateRangePickerMonthCellStyle(
                        weekendTextStyle: TextStyle(color: Colors.grey.shade300),
                        disabledDatesTextStyle: TextStyle(color: Colors.grey.shade300)),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      enableSwipeSelection: true,
                      showTrailingAndLeadingDates: true,
                      firstDayOfWeek: 1,
                      weekendDays: [],
                      // showWeekNumber: true
                    ),
                    allowViewNavigation: true,
                    todayHighlightColor: Colors.grey.shade300,
                    headerStyle: DateRangePickerHeaderStyle(
                      textStyle: TextStyle(color: ColorPrimary),
                    ),
                    yearCellStyle: DateRangePickerYearCellStyle(textStyle: TextStyle(color: Colors.black)),
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
                        hintText: "choose_report_days_key".tr(),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: ColorPrimary,
                        ),
                        suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)),
                  ),

            SizedBox(
              height: 10,
            ),
            widget.chatPapdi == 1
                ? Container()
                : TextFormField(
                    controller: edtCategory,
                    onTap: () {
                      selectCategory(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: "Choose_category_key".tr(),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: ColorPrimary,
                        ),
                        suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)),
                  ),
            SizedBox(
              height: 10,
            ),
            widget.chatPapdi == 1
                ? Container()
                : TextFormField(
                    controller: edtProducts,
                    onTap: () {
                      selectProduct(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: "choose_product_key".tr(),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: ColorPrimary,
                        ),
                        suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)),
                  ),
            // reportList.isNotEmpty
            //     ? Container(
            //         height: 300,
            //         child: SfDataGrid(
            //             key: _key,
            //             source: employeeDataSource,
            //             columns: reportList.first.keys
            //                 .map(
            //                   (e) => GridColumn(
            //                       columnName: '$e',
            //                       columnWidthMode: ColumnWidthMode.auto,
            //                       label: Container(
            //                           padding: const EdgeInsets.all(16.0),
            //                           alignment: Alignment.center,
            //                           child: Text(
            //                             '$e',
            //                           ))),
            //                 )
            //                 .toList()))
            //     : Container()
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
          "export_key".tr(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void selectCategory(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        builder: (context) {
          return CategoryBottomSheet(
            onSelect: (CategoryModel option) {
              edtCategory.text = option.categoryName!;
              categoryModel = option;
            },
          );
        });
  }

  void selectProduct(BuildContext context) async {
    productList = await Navigator.push(
        context,
        PageTransition(
            child: ProductListScreen(
              categoryId: categoryModel == null ? "" : categoryModel!.id,
            ),
            type: PageTransitionType.fade));

    String text = "";

    for (int i = 0; i < productList.length; i++) {
      if (i == productList.length - 1) {
        text += productList[i].productName;
      } else {
        text += productList[i].productName + ",";
      }
    }

    edtProducts.text = text;

    print("selected product->$productList");
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = Utility.getFormatDate(args.value.startDate);

        endDate = Utility.getFormatDate(args.value.endDate ?? args.value.startDate);

        // code to disable sunday
        // if (d.weekday == 7) {
        //   dateRangePickerController.selectedDate = DateTime.parse(selectedDate);
        // } else {
        //   dateRangePickerController.selectedDate = d;
        //   selectedDate = Utility.getFormatDate(args.value);
        // }
      }
    });
  }

  void getReport(BuildContext context) async {
    if (await Network.isConnected()) {
      String url = widget.chatPapdi == 1 ? Endpoint.GET_DAILY_REPORT_CHAT_PAPDI : Endpoint.GET_DAILY_REPORT;
      Map input = HashMap<String, dynamic>();
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      // input["vendor_id"] = "1";

      if (groupValue == 1) {
        input["from_date"] = startDate;
        input["to_date"] = endDate;
      } else {
        input["days"] = days!.optionId;
      }

      if (widget.chatPapdi == 0) {
        input["category_id"] = categoryModel == null ? "" : categoryModel!.id;
        if (productList.isEmpty) {
          input["product_id"] = "";
        } else {
          String text = "";

          for (int i = 0; i < productList.length; i++) {
            if (i == productList.length - 1) {
              text += productList[i].id;
            } else {
              text += productList[i].id + ",";
            }
          }
          input["product_id"] = text;
        }
      }

      EasyLoading.show();

      try {
        Response response = await dio.post(url, data: input);
        Map<String, dynamic> result = json.decode(response.toString());
        EasyLoading.dismiss();
        print("result-->$result");
        if (result["success"]) {
          List<Map<String, dynamic>> report = List<Map<String, dynamic>>.from(result["data"]!.map((x) => x));

          report.forEach((element) {
            element.remove("created_at");
            element.remove("time");
            // element["total"] = element["total_pay"];
            element.remove("total_pay");

            debugPrint("element-->$element");

            reportList.add(element);
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DailyReportDataGrid(
                        reportData: reportList,
                      ))).then((value) => reportList.clear());

          // reportList = report;

          // employeeDataSource = EmployeeDataSource(employeeData: reportList);
          //
          // setState(() {});
          //
          // Future.delayed(Duration(seconds: 3), () {
          //   generateReport();
          // });

          // exportExcelReport(context);
          // generateReport(context);
        } else {
          EasyLoading.dismiss();
          Utility.showToast(msg: response.data["message"]);
        }
      } catch (exception) {
        print("exception-->$exception");
        if (exception is DioError) {
          ServerError e = ServerError.withError(error: exception);
        }
        EasyLoading.dismiss();
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  void exportExcelReport(BuildContext context) async {
    final xls.Workbook workbook = xls.Workbook(0);
    //Adding a Sheet with name to workbook.
    final xls.Worksheet sheet1 = workbook.worksheets.addWithName('Sales Report');
    sheet1.showGridlines = true;

    int columnIndex = 1;
    int rowIndex = 1;

    double total = 0.0;
    double totalMrp = 0.0;
    double totalPurchasePrice = 0.0;
    double earningCoins = 0.0;
    double redeemCoins = 0.0;

    sheet1.getRangeByIndex(1, 1, 1, reportList.first.keys.length).merge();
    sheet1.getRangeByIndex(rowIndex, columnIndex).value = "Daily Report ($startDate)";
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

        if (key == "total") {
          total = double.parse(value == null ? "0.0" : value.toString()) + total;
        }
        if (key == "mrp") {
          totalMrp = double.parse(value == null ? "0.0" : value.toString()) + totalMrp;
        }
        if (key == "purchase_price") {
          totalPurchasePrice =
              double.parse(value == null || value == "" ? "0.0" : value.toString()) + totalPurchasePrice;
        }
        if (key == "earning_coins") {
          earningCoins = double.parse(value == null || value == "" ? "0.0" : value.toString()) + earningCoins;
        }
        if (key == "redeem_coins") {
          redeemCoins = double.parse(value == null || value == "" ? "0.0" : value.toString()) + redeemCoins;
        }
      });
    });

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

    int index = reportList.first.keys.toList().indexWhere((element) => element == "total");
    if (index != -1) {
      sheet1.getRangeByIndex(rowIndex + 1, index + 1).value = total;
    }

    int purchaseIndex = reportList.first.keys.toList().indexWhere((element) => element == "purchase_price");
    if (purchaseIndex != -1) {
      sheet1.getRangeByIndex(rowIndex + 1, purchaseIndex + 1).value = totalPurchasePrice;
    }

    int mrpIndex = reportList.first.keys.toList().indexWhere((element) => element == "mrp");
    if (mrpIndex != -1) {
      sheet1.getRangeByIndex(rowIndex + 1, mrpIndex + 1).value = totalMrp;
    }

    int earningCoinsIndex = reportList.first.keys.toList().indexWhere((element) => element == "earning_coins");
    if (earningCoinsIndex != -1) {
      sheet1.getRangeByIndex(rowIndex + 1, earningCoinsIndex + 1).value = earningCoins;
    }

    int redeemCoinsIndex = reportList.first.keys.toList().indexWhere((element) => element == "redeem_coins");
    if (redeemCoinsIndex != -1) {
      sheet1.getRangeByIndex(rowIndex + 1, redeemCoinsIndex + 1).value = redeemCoins;
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

    String fileName = "Daily_Report_$startDate" + ".xlsx";

    final File file = File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true).whenComplete(() {
      print("completed");
      Utility.showToast(msg: "Report saved at below location \n${file.path}");
    });
    print("savedDir${file.path}");

    workbook.dispose();

    OpenFile.open(file.path);
  }

  void generateReport(BuildContext context) async {
    // final PdfDocument document = _key.currentState!.exportToPdfDocument(
    //   autoColumnWidth: true
    // );
    PdfDocument document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    PdfPage pdfPage = document.pages.add();
    PdfGrid pdfGrid = _key.currentState!.exportToPdfGrid(excludeColumns: ["created_at", "product_id", "category_id"]);
    pdfGrid.draw(page: pdfPage, bounds: Rect.fromLTWH(0, 0, 0, 0));

    final List<int> bytes = document.save();

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

    String fileName = "daily_report_key$startDate".tr() + ".pdf";

    final File file = File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true).whenComplete(() {
      print("completed");
      Utility.showToast(msg: "report_saved_at_below_location_key \n${file.path}".tr());
    });
    print("savedDir${file.path}");
    // await helper.saveAndLaunchFile(bytes, 'DataGrid.pdf');
    document.dispose();
  }

  void selectDays(BuildContext context) async {
    final List<Option> options = [
      Option(optionName: "1" + "day_key".tr(), optionId: "1"),
      Option(optionName: "5" + "days_key".tr(), optionId: "5"),
      Option(optionName: "7" + "days_key".tr(), optionId: "7"),
      Option(optionName: "15" + "days_key".tr(), optionId: "15"),
      Option(optionName: "30" + "days_key".tr(), optionId: "30"),
    ];
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
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
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Map<String, dynamic>> employeeData}) {
    // _employeeData = employeeData
    //     .map<DataGridRow>((e) => DataGridRow(cells: [
    //   DataGridCell<int>(columnName: 'id', value: e.id),
    //   DataGridCell<String>(columnName: 'name', value: e.name),
    //   DataGridCell<String>(
    //       columnName: 'designation', value: e.designation),
    //   DataGridCell<int>(columnName: 'salary', value: e.salary),
    // ]))
    //     .toList();

    List<DataGridRow> gridList = [];
    employeeData.forEach((element) {
      List<DataGridCell<dynamic>> gridRow = [];
      element.forEach((key, value) {
        gridRow.add(DataGridCell<String>(columnName: '$key', value: value.toString()));
        // sheet1.getRangeByIndex(rowIndex, columnIndex).value = value;
        // sheet1.getRangeByIndex(rowIndex, columnIndex).columnWidth = 25;
        // sheet1.getRangeByIndex(rowIndex, columnIndex).rowHeight = 20;
        // sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.hAlign = xls.HAlignType.center;
        // sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle.vAlign = xls.VAlignType.center;
        // columnIndex = columnIndex + 1;

        // if (key == "total") {
        //   print("value - >$value");
        //   print("total - >$total");
        //   total = double.parse(value == null ? "0.0" : value.toString()) + total;
        // }
        // if (key == "mrp") {
        //   print("mrp - >$value");
        //   print("totalMrp - >$totalMrp");
        //   totalMrp = double.parse(value == null ? "0.0" : value.toString()) + totalMrp;
        // }
        // if (key == "purchase_price") {
        //   print("purchase_price - >$value");
        //   print("totalPurchasePrice - >$totalPurchasePrice");
        //   totalPurchasePrice = double.parse(value == null ? "0.0" : value.toString()) + totalPurchasePrice;
        // }
      });
      gridList.add(DataGridRow(cells: gridRow));
    });
    _employeeData = gridList;
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

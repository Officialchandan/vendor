import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:vendor/api/Endpoint.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/performance_tracker/report/product_list_screen.dart';
import 'package:vendor/ui/performance_tracker/report_data_grid/sales_return_report_data_grid.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/category_bottom_sheet.dart';
import 'package:vendor/widget/custom_bottom_sheet.dart';

class SaleReturnReport extends StatefulWidget {
  const SaleReturnReport({Key? key}) : super(key: key);

  @override
  _SaleReturnReportState createState() => _SaleReturnReportState();
}

class _SaleReturnReportState extends State<SaleReturnReport> {
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
  List<ProductModel> productList = [];
  List<Map<String, dynamic>> reportList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "sale_return_reports_key".tr(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
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
            TextFormField(
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
            TextFormField(
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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

  void getReport(BuildContext context) async {
    if (await Network.isConnected()) {
      Map input = HashMap<String, dynamic>();
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["vendor_id"] = "1";
      String url = "";

      if (groupValue == 1) {
        url = Endpoint.GET_SALE_RETURN_REPORT_BY_DATE;
        input["from_date"] = startDate;
        input["to_date"] = endDate;
      } else {
        url = Endpoint.GET_SALE_RETURN_REPORT_BY_DAY;
        if (days == null) {
          Utility.showToast(msg: "please_select_days_key".tr());
          return;
        } else {
          input["days"] = days!.optionId;
        }
      }
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
      EasyLoading.show();

      try {
        Response response = await dio.post(url, data: input);
        Map<String, dynamic> result = json.decode(response.toString());
        EasyLoading.dismiss();

        if (result["success"]) {
          List<Map<String, dynamic>> report =
              result["data"] == null ? [] : List<Map<String, dynamic>>.from(result["data"]!.map((x) => x));
          List<Map<String, dynamic>> reportDirect = result["direct_billing"] == null
              ? []
              : List<Map<String, dynamic>>.from(result["direct_billing"]!.map((x) => x));
          report.forEach((element) {
            debugPrint("element-->$element");

            reportList.add(element);
          });
          reportDirect.forEach((element) {
            debugPrint("element-->$element");

            reportList.add(element);
          });
          reportList.sort((a, b) => b["date"].compareTo(a["date"]));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SalesReturnReportDataGrid(
                        reportData: reportList,
                      ))).then((value) => reportList.clear());
          // exportReport(context);
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

  void exportReport(BuildContext context) async {
    print("exportReport");
    final xls.Workbook workbook = xls.Workbook(0);
    //Adding a Sheet with name to workbook.
    final xls.Worksheet sheet1 = workbook.worksheets.addWithName('Sale Return Report');
    sheet1.showGridlines = true;

    int columnIndex = 1;
    int rowIndex = 1;

    double total = 0.0;
    double totalMrp = 0.0;
    double totalPurchasePrice = 0.0;
    double qty = 0;
    double returnCoins = 0.0;

    sheet1.getRangeByIndex(1, 1, 1, reportList.first.keys.length).merge();
    if (groupValue == 1) {
      sheet1.getRangeByIndex(rowIndex, columnIndex).value = "Sale Return Report ($startDate to $endDate)";
    } else {
      sheet1.getRangeByIndex(rowIndex, columnIndex).value = "Sale Return Report (${days!.optionName})";
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

        if (key == "total") {
          print("value - >$value");
          print("total - >$total");
          total = double.parse(value == null || value == "" ? "0" : value.toString()) + total;
        }
        if (key == "mrp") {
          print("mrp - >$value");
          print("totalMrp - >$totalMrp");
          totalMrp = double.parse(value == null || value == "" ? "0" : value.toString()) + totalMrp;
        }
        if (key == "purchase_price") {
          print("purchase_price - >$value");
          print("totalPurchasePrice - >$totalPurchasePrice");
          totalPurchasePrice = double.parse(value == null || value == "" ? "0" : value.toString()) + totalPurchasePrice;
        }
        if (key == "qty") {
          print("qty - >$value");
          print("qty - >$qty");
          qty = double.parse(value == null || value == "" ? "0" : value.toString()) + qty;
        }
        if (key == "return_coins") {
          print("qty - >$value");
          print("returnCoins - >$returnCoins");
          returnCoins = double.parse(value == null || value == "" ? "0" : value.toString()) + returnCoins;
        }
      });
    });

    print("total - >$total");
    print("totalPurchasePrice - >$totalPurchasePrice");
    print("totalMrp - >$totalMrp");
    print("qty - >$qty");
    print("returnCoins - >$returnCoins");

    final xls.Style style = workbook.styles.add('Style1');
    style.backColorRgb = Colors.red;
    style.hAlign = xls.HAlignType.center;
    style.vAlign = xls.VAlignType.center;
    style.fontColorRgb = Colors.white;
    style.bold = true;

    columnIndex = 1;
    rowIndex = rowIndex + 1;
    reportList.first.forEach((key, value) {
      sheet1.getRangeByIndex(rowIndex, columnIndex).cellStyle = style;
      if (columnIndex == 1) {
        sheet1.getRangeByIndex(rowIndex, 1).value = "Total";
      }
      if (key == "total") {
        sheet1.getRangeByIndex(rowIndex, columnIndex).value = total;
      }
      if (key == "purchase_price") {
        sheet1.getRangeByIndex(rowIndex, columnIndex).value = totalPurchasePrice;
      }
      if (key == "mrp") {
        sheet1.getRangeByIndex(rowIndex, columnIndex).value = totalMrp;
      }
      if (key == "return_coins") {
        sheet1.getRangeByIndex(rowIndex, columnIndex).value = returnCoins;
      }
      if (key == "qty") {
        sheet1.getRangeByIndex(rowIndex, columnIndex).value = qty;
      }
      // if (key == "redeem_coins") {
      //   sheet1.getRangeByIndex(rowIndex, columnIndex).value = redeemCoins;
      // }
      columnIndex = columnIndex + 1;
    });

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

    String fileName = "sale_return_report_" + DateTime.now().millisecondsSinceEpoch.toString() + ".xlsx";

    final File file = File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true).whenComplete(() {
      print("completed");
      Utility.showToast(msg: "Report saved at below location \n${file.path}");
    });
    print("savedDir${file.path}");

    workbook.dispose();

    OpenFile.open(file.path);
  }
}

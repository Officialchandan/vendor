import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
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

  TextEditingController edtCategory = TextEditingController();
  TextEditingController edtDays = TextEditingController();
  TextEditingController edtProducts = TextEditingController();
  TextEditingController edtReportType = TextEditingController();

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
          exportReport(context);
        },
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

  void exportReport(BuildContext context) async {
// Create a new Excel document.
//     final xls.Workbook workbook = new xls.Workbook();
// //Accessing worksheet via index.
//     final xls.Worksheet sheet = workbook.worksheets[0];
// //Add Text.
//     sheet.getRangeByName('A1').setText('Hello World');
// //Add Number
//     sheet.getRangeByName('A3').setNumber(44);
// //Add DateTime
//     sheet.getRangeByName('A5').setDateTime(DateTime(2020, 12, 12, 1, 10, 20));
// Save the document.

    final xls.Workbook workbook = xls.Workbook(0);
    //Adding a Sheet with name to workbook.
    final xls.Worksheet sheet1 = workbook.worksheets.addWithName('Budget');
    sheet1.showGridlines = false;

    sheet1.enableSheetCalculations();
    sheet1.getRangeByIndex(1, 1).columnWidth = 19.13;
    sheet1.getRangeByIndex(1, 2).columnWidth = 13.65;
    sheet1.getRangeByIndex(1, 3).columnWidth = 12.25;
    sheet1.getRangeByIndex(1, 4).columnWidth = 11.35;
    sheet1.getRangeByIndex(1, 5).columnWidth = 8.09;
    sheet1.getRangeByName('A1:A18').rowHeight = 19.47;

    //Adding cell style.
    final xls.Style style1 = workbook.styles.add('Style1');
    style1.backColor = '#D9E1F2';
    style1.hAlign = xls.HAlignType.left;
    style1.vAlign = xls.VAlignType.center;
    style1.bold = true;

    final xls.Style style2 = workbook.styles.add('Style2');
    style2.backColor = '#8EA9DB';
    style2.vAlign = xls.VAlignType.center;
    style2.numberFormat = r'[Red]($#,###)';
    style2.bold = true;

    sheet1.getRangeByName('A10').cellStyle = style1;
    sheet1.getRangeByName('B10:D10').cellStyle.backColor = '#D9E1F2';
    sheet1.getRangeByName('B10:D10').cellStyle.hAlign = xls.HAlignType.right;
    sheet1.getRangeByName('B10:D10').cellStyle.vAlign = xls.VAlignType.center;
    sheet1.getRangeByName('B10:D10').cellStyle.bold = true;

    sheet1.getRangeByName('A11:A17').cellStyle.vAlign = xls.VAlignType.center;
    sheet1.getRangeByName('A11:D17').cellStyle.borders.bottom.lineStyle = xls.LineStyle.thin;
    sheet1.getRangeByName('A11:D17').cellStyle.borders.bottom.color = '#BFBFBF';

    sheet1.getRangeByName('D18').cellStyle = style2;
    sheet1.getRangeByName('D18').cellStyle.vAlign = xls.VAlignType.center;
    sheet1.getRangeByName('A18:C18').cellStyle.backColor = '#8EA9DB';
    sheet1.getRangeByName('A18:C18').cellStyle.vAlign = xls.VAlignType.center;
    sheet1.getRangeByName('A18:C18').cellStyle.bold = true;
    sheet1.getRangeByName('A18:C18').numberFormat = r'$#,###';

    sheet1.getRangeByIndex(10, 1).text = 'Category';
    sheet1.getRangeByIndex(10, 2).text = 'Expected cost';
    sheet1.getRangeByIndex(10, 3).text = 'Actual Cost';
    sheet1.getRangeByIndex(10, 4).text = 'Difference';
    sheet1.getRangeByIndex(11, 1).text = 'Venue';
    sheet1.getRangeByIndex(12, 1).text = 'Seating & Decor';
    sheet1.getRangeByIndex(13, 1).text = 'Technical team';
    sheet1.getRangeByIndex(14, 1).text = 'Performers';
    sheet1.getRangeByIndex(15, 1).text = 'Performer\'s transport';
    sheet1.getRangeByIndex(16, 1).text = 'Performer\'s stay';
    sheet1.getRangeByIndex(17, 1).text = 'Marketing';
    sheet1.getRangeByIndex(18, 1).text = 'Total';

    sheet1.getRangeByName('B11:D17').numberFormat = r'$#,###';
    sheet1.getRangeByName('D11').numberFormat = r'[Red]($#,###)';
    sheet1.getRangeByName('D12').numberFormat = r'[Red]($#,###)';
    sheet1.getRangeByName('D14').numberFormat = r'[Red]($#,###)';

    sheet1.getRangeByName('B11').number = 16250;
    sheet1.getRangeByName('B12').number = 1600;
    sheet1.getRangeByName('B13').number = 1000;
    sheet1.getRangeByName('B14').number = 12400;
    sheet1.getRangeByName('B15').number = 3000;
    sheet1.getRangeByName('B16').number = 4500;
    sheet1.getRangeByName('B17').number = 3000;
    sheet1.getRangeByName('B18').formula = '=SUM(B11:B17)';

    sheet1.getRangeByName('C11').number = 17500;
    sheet1.getRangeByName('C12').number = 1828;
    sheet1.getRangeByName('C13').number = 800;
    sheet1.getRangeByName('C14').number = 14000;
    sheet1.getRangeByName('C15').number = 2600;
    sheet1.getRangeByName('C16').number = 4464;
    sheet1.getRangeByName('C17').number = 2700;
    sheet1.getRangeByName('C18').formula = '=SUM(C11:C17)';

    sheet1.getRangeByName('D11').formula = '=IF(C11>B11,C11-B11,B11-C11)';
    sheet1.getRangeByName('D12').formula = '=IF(C12>B12,C12-B12,B12-C12)';
    sheet1.getRangeByName('D13').formula = '=IF(C13>B13,C13-B13,B13-C13)';
    sheet1.getRangeByName('D14').formula = '=IF(C14>B14,C14-B14,B14-C14)';
    sheet1.getRangeByName('D15').formula = '=IF(C15>B15,C15-B15,B15-C15)';
    sheet1.getRangeByName('D16').formula = '=IF(C16>B16,C16-B16,B16-C16)';
    sheet1.getRangeByName('D17').formula = '=IF(C17>B17,C17-B17,B17-C17)';
    sheet1.getRangeByName('D18').formula = '=IF(C18>B18,C18-B18,B18-C18)';

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

    // var raf = file.openSync(mode: FileMode.write);
    // raf.writeFromSync(bytes);
    // await raf.close();
    // final Directory directory = await getApplicationSupportDirectory();
    // String path = directory.path;
    // var savedDir = Directory(path);
    // bool hasExisted = await savedDir.exists();
    // if (!hasExisted) {
    //   savedDir.create();
    // }
    // final File file = File('$path\\"AddingTextNumberDateTime.xlsx');
    // file.writeAsBytes(bytes).whenComplete(() {
    //   print("completed");
    // });

    workbook.dispose();

    OpenFile.open(file.path);
  }
}

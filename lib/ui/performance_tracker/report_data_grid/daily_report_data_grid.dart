import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/utility.dart';

class DailyReportDataGrid extends StatefulWidget {
  List<Map<String, dynamic>>? reportData;
  DailyReportDataGrid({Key? key, this.reportData}) : super(key: key);

  @override
  _DailyReportDataGridState createState() => _DailyReportDataGridState();
}

class _DailyReportDataGridState extends State<DailyReportDataGrid> {
  ReportDataSource? reportDataSource;
  String? reportType;

  final GlobalKey<SfDataGridState> dataGridKey = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    reportDataSource = ReportDataSource(reportData: widget.reportData!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sales Report"),
          actions: [
            IconButton(
                onPressed: () {
                  showType();
                },
                icon: Icon(Icons.download))
          ],
        ),
        body: SfDataGrid(
          key: dataGridKey,
          source: reportDataSource!,
          allowColumnsResizing: true,
          highlightRowOnHover: true,
          isScrollbarAlwaysShown: false,
          columnWidthMode: ColumnWidthMode.auto,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columns: <GridColumn>[
            GridColumn(
                columnName: 'Order ID',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Order ID",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Product ID',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Product ID",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Category ID',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Category ID",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Product Name',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Product Name",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Customer ID',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Customer ID",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Mobile',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Mobile",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Purchase Price',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Purchase Price",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'MRP',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "MRP",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Total',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Total",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Earning Coins',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Earning Coins",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Redeem Coins',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Redeem Coins",
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'Date',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Date",
                      overflow: TextOverflow.ellipsis,
                    ))),
          ],
        ),
      ),
    );
  }

  void showType() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
          height: 185,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 135,
                width: MediaQuery.of(context).size.width,
                child: RadioListBuilder(
                  onFormatSelect: (type) {
                    reportType = type;
                  },
                ),
              ),
              Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(left: 45, right: 45),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (reportType == "0") {
                            exportDataGridToExcel();
                          }
                          if (reportType == "1") {
                            exportDataGridToPdf();
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Export",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: ColorPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> exportDataGridToExcel() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      Directory? directory;
      directory = await getExternalStorageDirectory();
      String path = directory!.path +
          DateFormat("/dd MMM yyyy").format(DateTime.now()) +
          ".xlsx";

      final xlsio.Workbook workbook =
          dataGridKey.currentState!.exportToExcelWorkbook();
      final List<int> bytes = workbook.saveAsStream();

      File(path).writeAsBytes(bytes);
      workbook.dispose();
      Utility.showToast("File Saved");
    }
    if (permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> exportDataGridToPdf() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      Directory? directory;
      directory = await getExternalStorageDirectory();
      String path = directory!.path +
          DateFormat("/dd MMM yyyy").format(DateTime.now()) +
          ".pdf";
      log(path);
      final PdfDocument document = dataGridKey.currentState!
          .exportToPdfDocument(fitAllColumnsInOnePage: true);
      final List<int> bytes = document.save();
      File(path).writeAsBytes(bytes);
      document.dispose();
      Utility.showToast("File Saved");
    }
    if (permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}

class ReportDataSource extends DataGridSource {
  ReportDataSource({required List<Map<String, dynamic>> reportData}) {
    _reportData = reportData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'Order ID', value: e['order_id']),
              DataGridCell<int>(
                  columnName: 'Product ID', value: e['product_id']),
              DataGridCell<int>(
                  columnName: 'Category ID', value: e['category_id']),
              DataGridCell<String>(
                  columnName: 'Product Name', value: e['product_name']),
              DataGridCell<int>(
                  columnName: 'Customer ID', value: e['customer_id']),
              DataGridCell<String>(columnName: 'Mobile', value: e['mobile']),
              DataGridCell<String>(
                  columnName: 'Purchase Price', value: e['purchase_price']),
              DataGridCell<String>(columnName: 'MRP', value: e['mrp']),
              DataGridCell<String>(columnName: 'Total', value: e['total']),
              DataGridCell<String>(
                  columnName: 'Earning Coins', value: e['earning_coins']),
              DataGridCell<String>(
                  columnName: 'Redeem Coins', value: e['redeem_coins']),
              DataGridCell<String>(columnName: 'Date', value: e['date']),
            ]))
        .toList();
  }

  List<DataGridRow> _reportData = [];

  @override
  List<DataGridRow> get rows => _reportData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

class RadioListBuilder extends StatefulWidget {
  final Function(String format) onFormatSelect;
  const RadioListBuilder({required this.onFormatSelect, Key? key})
      : super(key: key);

  @override
  RadioListBuilderState createState() {
    return RadioListBuilderState();
  }
}

class RadioListBuilderState extends State<RadioListBuilder> {
  Object? value;
  List<String> types = ["Excel", "PDF"];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      padding: const EdgeInsetsDirectional.only(top: 10),
      itemBuilder: (context, index) {
        return RadioListTile(
          contentPadding: const EdgeInsets.only(left: 20),
          value: index,
          groupValue: value,
          onChanged: (currentIndex) {
            setState(
              () {
                value = currentIndex;
                widget.onFormatSelect(value.toString());
              },
            );
          },
          title: Text(
            types[index],
            style: const TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        );
      },
      itemCount: 2,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 8,
          color: Colors.grey,
          thickness: 0.6,
        );
      },
    );
  }
}

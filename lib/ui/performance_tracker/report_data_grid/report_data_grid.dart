import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:syncfusion_flutter_datagrid_export/export.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:vendor/utility/color.dart';

class ReportDataGrid extends StatefulWidget {
  List<Map<String, dynamic>>? reportData;
  ReportDataGrid({Key? key, this.reportData}) : super(key: key);

  @override
  _ReportDataGridState createState() => _ReportDataGridState();
}

class _ReportDataGridState extends State<ReportDataGrid> {
  ReportDataSource? reportDataSource;
  final GlobalKey<SfDataGridState> _dataGridKey = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    reportDataSource = ReportDataSource(
      reportData: widget.reportData!,
    );
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Report Data"),
          actions: [
            IconButton(
                onPressed: () {
                  showType();
                },
                icon: Icon(Icons.download))
          ],
        ),
        body: SfDataGrid(
          key: _dataGridKey,
          source: reportDataSource!,
          highlightRowOnHover: true,
          isScrollbarAlwaysShown: false,
          columnWidthMode: ColumnWidthMode.auto,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columns: <GridColumn>[
            GridColumn(
                columnName: 'Product Name',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text("Product Name"))),
            GridColumn(
                columnName: 'Redeem Coins',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text("Redeem Coins"))),
            GridColumn(
                columnName: 'Created At',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text("Created At"))),
            GridColumn(
                columnName: 'Date',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text("Date"))),
            GridColumn(
                columnName: 'Time',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text("Time"))),
          ],
        ),
      ),
    );
  }

  void showType() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 148,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: RadioListBuilder(onFormatSelect: (reportType) {
            if (reportType == "0") {
              exportDataGridToExcel();
            }
            if (reportType == "1") {
              exportDataGridToPdf();
            }
          }),
        );
      },
    );
  }

  Future<void> exportDataGridToExcel() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      Directory directory = await getTemporaryDirectory();
      String path = directory.path +
          DateFormat("/dd MMM yyyy").format(DateTime.now()) +
          ".xlsx";
      log(path);
      log("${_dataGridKey.currentState.toString()}");

      if (_dataGridKey.currentState == null) {
        print("not null");
      }

      final xlsio.Workbook workbook =
          _dataGridKey.currentState!.exportToExcelWorkbook();
      final List<int> bytes = workbook.saveAsStream();
      File(path).writeAsBytes(bytes);
      workbook.dispose();
      Fluttertoast.showToast(msg: "File Saved " + path);
    }
    if (permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> exportDataGridToPdf() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      Directory directory = await getTemporaryDirectory();
      String path = directory.path +
          DateFormat("/dd MMM yyyy").format(DateTime.now()) +
          ".pdf";
      log(path);
      final PdfDocument document = _dataGridKey.currentState!
          .exportToPdfDocument(fitAllColumnsInOnePage: true);
      final List<int> bytes = document.save();
      File(path).writeAsBytes(bytes);
      document.dispose();
      Fluttertoast.showToast(msg: "File Saved " + path);
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
              DataGridCell<String>(
                  columnName: 'Name', value: e['product_name']),
              DataGridCell<String>(
                  columnName: 'Redeem Coins', value: e['redeem_coins']),
              DataGridCell<String>(
                  columnName: 'Created At', value: e['created_at']),
              DataGridCell<String>(columnName: 'Date', value: e['date']),
              DataGridCell<String>(columnName: 'Time', value: e['time']),
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
          value: index,
          groupValue: value,
          onChanged: (currentIndex) {
            setState(
              () {
                value = currentIndex;
                widget.onFormatSelect(value.toString());
                Timer(
                  const Duration(milliseconds: 200),
                  () => Navigator.pop(context, true),
                );
              },
            );
          },
          title: Text(
            types[index],
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      },
      itemCount: 2,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
        );
      },
    );
  }
}

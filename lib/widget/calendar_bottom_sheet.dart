import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/utility.dart';

class CalendarBottomSheet extends StatefulWidget {
  const CalendarBottomSheet({required this.onSelect, Key? key}) : super(key: key);

  final Function(String startDate, String endDate) onSelect;

  @override
  _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  String startDate = "";
  String endDate = Utility.getFormatDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            child: SfDateRangePicker(
              maxDate: DateTime.now(),
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
              showNavigationArrow: true,
              selectionMode: DateRangePickerSelectionMode.range,
              endRangeSelectionColor: ColorPrimary,
              startRangeSelectionColor: ColorPrimary,
              rangeSelectionColor: Colors.blue.shade50,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  startDate = Utility.getFormatDate(args.value.startDate);
                  endDate = Utility.getFormatDate(args.value.endDate ?? args.value.startDate);
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSelect(startDate, endDate);
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(color: ColorPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

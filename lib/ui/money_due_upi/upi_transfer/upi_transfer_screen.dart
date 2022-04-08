import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ui/money_due_upi/upi_transfer/upi_transfer_bloc/upi_transfer_bloc.dart';
import 'package:vendor/ui/money_due_upi/upi_transfer/upi_transfer_bloc/upi_transfer_event.dart';
import 'package:vendor/ui/money_due_upi/upi_transfer/upi_transfer_bloc/upi_transfer_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../../../model/upi_transfer_history.dart';
import '../../../widget/calendar_bottom_sheet.dart';

class UpiTransferHistory extends StatefulWidget {
  const UpiTransferHistory({Key? key}) : super(key: key);

  @override
  _UpiTransferHistoryState createState() => _UpiTransferHistoryState();
}

class _UpiTransferHistoryState extends State<UpiTransferHistory> {
  String startDate = "";
  String endDate = "";
  List<UpiTansferData> searchList = [];
  List<UpiTansferData> upiList = [];
  int vendorid = 0;
  UpiTansferHistoryBloc upiTansferHistoryBloc = UpiTansferHistoryBloc();
  Future<void> filterApiCall(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["from_date"] = startDate.isEmpty ? "" : startDate.toString();
    input["to_date"] = endDate.isEmpty ? startDate.toString() : endDate.toString();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    log("=====? $input");
    upiTansferHistoryBloc.add(GetUpiTansferHistoryEvent(input: input));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpiTansferHistoryBloc>(
      create: (context) => upiTansferHistoryBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "UPI Transfer",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CalendarBottomSheet(onSelect: (startDate, endDate) {
                        this.startDate = startDate;
                        this.endDate = endDate;
                        print("startDate->$startDate");
                        print("endDate->$endDate");
                        filterApiCall(context);
                        // getCustomer();
                      });
                    });
                print("startDate--->$startDate");
                print("endDate--->$endDate");
              },
              child: Row(children: [
                Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                ),
                Center(child: Text("filter_key".tr() + "   ")),
              ]),
            ),
          ],
        ),
        body: Container(child: BlocBuilder<UpiTansferHistoryBloc, UpiTansferHistoryState>(builder: (context, state) {
          if (state is GetUpiTansferHistoryInitialState) {
            filterApiCall(context);
          }
          if (state is GetUpiTansferHistoryState) {
            log("--->ye estate hai bhiya");
            upiList = state.data!;
            searchList = upiList;
            log("--->ye estate hai bhiya${upiList}");
          }
          if (upiList == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetUpiTansferHistoryFailureState) {
            return Center(
              child: Image.asset("assets/images/no_data.gif"),
            );
          }

          return ListView.builder(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15),
              itemCount: upiList.length,
              itemBuilder: (context, index) {
                return Stack(children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.all(0),
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: Colors.white38),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1.0, spreadRadius: 1)]),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${upiList[index].txnDate}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20), color: Colors.orange.shade50),
                                child: Text(
                                  "  " + "pending_key".tr() + "  ",
                                  style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        width: 90,
                      ),
                    ]),
                  ),
                  Positioned(
                    right: 0,
                    top: 15,
                    child: Container(
                      alignment: Alignment.center,
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius:
                              BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          " \u20B9" + "${upiList[index].txnAmount}  ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ColorPrimary),
                        ),
                      ),
                    ),
                  )
                ]);
              });
        })
            //return ListWidget();

            ),
      ),
    );
  }
}

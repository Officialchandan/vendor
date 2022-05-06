import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider<UpiTansferHistoryBloc>(
      create: (context) => upiTansferHistoryBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "upi_history_key".tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CalendarBottomSheet(
                          endDate: endDate,
                          startDate: startDate,
                          onSelect: (startDate, endDate) {
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
            upiList = state.data!;
            searchList = upiList;
          }
          if (state is GetUpiTansferHistoryLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetUpiTansferHistoryFailureState) {
            return Center(
              child: Image.asset("assets/images/no_data.gif"),
            );
          }

          return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: upiList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  child: Stack(children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(0.0, 0.0), //(x,y)
                            blurRadius: 7.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Padding(
                          padding: EdgeInsets.only(left: 35.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " To: MyProfit",
                                  style: GoogleFonts.openSans(
                                      fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                ),
                                Text(
                                  " ${DateFormat("dd MMM yyyy").format(DateTime.parse(upiList[index].txnDate))}" +
                                      " - ${DateFormat.jm().format(DateTime.parse(upiList[index].txnDate))}",
                                  style: TextStyle(fontSize: 13, color: TextGrey, fontWeight: FontWeight.bold),
                                ),
                                // Container(
                                //   height: 20,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(20), color: Colors.orange.shade50),
                                //   child: upiList[index].status == 0
                                //       ? Container(
                                //           padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                //           decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.circular(20), color: RejectedTextBgColor),
                                //           child: Text(
                                //             "rejected_key".tr(),
                                //             style: TextStyle(
                                //                 color: RejectedTextColor, fontSize: 10, fontWeight: FontWeight.w400),
                                //           ),
                                //         )
                                //       : upiList[index].status == 1
                                //           ? Container(
                                //               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                //               decoration: BoxDecoration(
                                //                   borderRadius: BorderRadius.circular(20), color: ApproveTextBgColor),
                                //               child: Text(
                                //                 "accepted_key".tr(),
                                //                 style: TextStyle(
                                //                     color: ApproveTextColor, fontSize: 10, fontWeight: FontWeight.w400),
                                //               ),
                                //             )
                                //           : upiList[index].status == 2
                                //               ? Container(
                                //                   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                //                   decoration: BoxDecoration(
                                //                       borderRadius: BorderRadius.circular(20), color: PendingTextBgColor),
                                //                   child: Text(
                                //                     "pending_key".tr(),
                                //                     style: TextStyle(
                                //                         color: PendingTextColor,
                                //                         fontSize: 10,
                                //                         fontWeight: FontWeight.w400),
                                //                   ),
                                //                 )
                                //               : Container(
                                //                   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                //                   decoration: BoxDecoration(
                                //                       borderRadius: BorderRadius.circular(20), color: PendingTextBgColor),
                                //                   child: Text(
                                //                     "pending_key".tr(),
                                //                     style: TextStyle(
                                //                         color: PendingTextColor,
                                //                         fontSize: 10,
                                //                         fontWeight: FontWeight.w400),
                                //                   ),
                                //                 ),
                                // ),
                              ]),
                        ),
                        Text(
                          "\u20B9" + " ${upiList[index].txnAmount}  ",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                        ),
                      ]),
                    ),
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          height: 80,
                          width: 28,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: upiList[index].status == 0
                                ? Center(
                                    child: Text(
                                      "failed_key".tr(),
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                                  )
                                : upiList[index].status == 1
                                    ? Center(
                                        child: Text("success_key".tr(),
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                      )
                                    : upiList[index].status == 2
                                        ? Center(
                                            child: Text("pending_key".tr(),
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                          )
                                        : Center(
                                            child: Text("pending_key".tr(),
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
                                          ),
                          ),
                          decoration: BoxDecoration(
                              color: upiList[index].status == 0
                                  ? RejectedTextColor
                                  : upiList[index].status == 1
                                      ? ApproveTextColor
                                      : upiList[index].status == 1
                                          ? PendingTextColor
                                          : PendingTextColor,
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7))),
                        ))
                  ]),
                );
              });
        })
            //return ListWidget();

            ),
      ),
    );
  }
}

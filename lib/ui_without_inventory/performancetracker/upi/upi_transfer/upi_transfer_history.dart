import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/model/upi_transfer_history.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/upi_transfer/upi_transfer_bloc/upi_transfer_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/upi_transfer/upi_transfer_bloc/upi_transfer_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/upi_transfer/upi_transfer_bloc/upi_transfer_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/widget/calendar_bottom_sheet.dart';

class UpiTransferHistoryWithoutInventory extends StatefulWidget {
  const UpiTransferHistoryWithoutInventory({Key? key}) : super(key: key);

  @override
  _UpiTransferHistoryWithoutInventoryState createState() => _UpiTransferHistoryWithoutInventoryState();
}

class _UpiTransferHistoryWithoutInventoryState extends State<UpiTransferHistoryWithoutInventory> {
  String startDate = "";
  String endDate = "";
  List<UpiTansferData> searchList = [];
  List<UpiTansferData> upiList = [];
  int vendorid = 0;
  UpiTansferHistoryBloc upiTansferHistoryBloc = UpiTansferHistoryBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpiTansferHistoryBloc>(
      create: (context) => upiTansferHistoryBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "upi_transfer_key".tr(),
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
              padding: EdgeInsets.only(left: 14, right: 14, top: 14),
              itemCount: upiList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(14),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(0.0, 0.0), //(x,y)
                            blurRadius: 7.0,
                          ),
                        ],
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
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
                          " \u20B9" + "${upiList[index].txnAmount}  ",
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: upiList[index].status == 0
                                  ? RejectedBoxTextColor
                                  : upiList[index].status == 1
                                      ? GreenBoxTextColor
                                      : PendingTextColor),
                        ),
                      ]),
                    ),
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                            alignment: Alignment.center,
                            height: 80,
                            width: 28,
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
                            child: RotatedBox(
                                quarterTurns: 3,
                                child: upiList[index].status == 0
                                    ? Center(
                                        child: Text(
                                          "failed_key".tr(),
                                          style:
                                              TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                                        ),
                                      )
                                    : upiList[index].status == 1
                                        ? Center(
                                            child: Text("accepted_key".tr(),
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
                                          )
                                        : upiList[index].status == 2
                                            ? Center(
                                                child: Text("pending_key".tr(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400)),
                                              )
                                            : Center(
                                                child: Text("pending_key".tr(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400)),
                                              )))),
                  ]),
                );
              });
        })
            //return ListWidget();

            ),
      ),
    );
  }

  Future<void> filterApiCall(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["from_date"] = startDate.isEmpty ? "" : startDate.toString();
    input["to_date"] = endDate.isEmpty ? startDate.toString() : endDate.toString();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

    upiTansferHistoryBloc.add(GetUpiTansferHistoryEvent(input: input));
  }
}

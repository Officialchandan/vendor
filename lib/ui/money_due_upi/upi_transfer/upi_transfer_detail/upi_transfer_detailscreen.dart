import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/model/upi_tansfer_detail_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/widget/progress_indecator.dart';

import 'upi_transfer_detail_bloc/upi_transfer_detail_bloc.dart';
import 'upi_transfer_detail_bloc/upi_transfer_detail_event.dart';
import 'upi_transfer_detail_bloc/upi_transfer_detail_state.dart';

class UpiTransferDetail extends StatefulWidget {
  String orderId;
  double amount;
  DateTime date;
  int status;

  UpiTransferDetail({Key? key, required this.orderId, required this.amount, required this.date, required this.status})
      : super(key: key);

  @override
  State<UpiTransferDetail> createState() => _UpiTransferDetailState();
}

class _UpiTransferDetailState extends State<UpiTransferDetail> {
  UpiTansferHistoryDetailBloc _upiTansferHistoryDetailBloc = UpiTansferHistoryDetailBloc();
  List<UpiHistroyOrdersData> upiList = [];
  Future<void> filterApiCall(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();

    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["order_id"] = widget.orderId;
    log("=====? $input");
    _upiTansferHistoryDetailBloc.add(GetUpiTansferHistoryDetailEvent(input: input));
  }

  String name = "";
  getName() async {
    name = await SharedPref.getStringPreference(SharedPref.OWNERNAME);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return BlocProvider<UpiTansferHistoryDetailBloc>(
      create: (context) => _upiTansferHistoryDetailBloc,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "UPI Tansiction Detail",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          body: BlocConsumer<UpiTansferHistoryDetailBloc, UpiTansferHistoryDetailState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is GetUpiTansferHistoryDetailInitialState) {
                  filterApiCall(context);
                }
                if (state is GetUpiTansferHistoryDetailState) {
                  upiList = state.data!;
                  final ids = <dynamic>{};
                  // upiList.retainWhere((element) => ids.add(element.orderId));
                  // upiList.retainWhere((element) => ids.add(element.billingId));
                  log("message${upiList[0].myProfitVendor}");
                  log("message${upiList[0].vendorMyProfit}");
                }
                if (state is GetUpiTansferHistoryDetailLoadingState) {
                  return Center(child: CircularLoader());
                }
                if (state is GetUpiTansferHistoryDetailFailureState) {
                  return Center(
                    child: Image.asset("assets/images/no_data.gif"),
                  );
                }
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 25, bottom: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(0.0, 0.0), //(x,y)
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Amount".tr(),
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold, fontSize: 20, color: TextBlackLight),
                                  ),
                                  Text(
                                    "  \u20B9 ${widget.amount.toStringAsFixed(2)}",
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              widget.status == 1
                                  ? Text("Status: Succesful",
                                      style: GoogleFonts.openSans(
                                          fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight))
                                  : Text("Status: Failed",
                                      style: GoogleFonts.openSans(
                                          fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight)),
                              SizedBox(
                                height: 25,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "To: MyProfit",
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600, fontSize: 18, color: TextGrey),
                                  ),
                                  Text(
                                    "From: $name",
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600, fontSize: 18, color: TextGrey),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text("Settlement Id: ${widget.orderId}",
                                  style: GoogleFonts.openSans(
                                      fontSize: 16, fontWeight: FontWeight.w600, color: TextBlackLight)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Date: ${DateFormat("dd MMM yyyy").format(widget.date)}" +
                                    " - ${DateFormat.jm().format(widget.date)}",
                                style: TextStyle(fontSize: 13, color: TextGrey, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                            itemCount: upiList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              // if (searchList[index].status == 0) {
                              //   return Container();
                              // }
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                // child:
                                // InkWell(
                                //   splashColor: Colors.transparent,
                                //   onTap: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => UpiTransferDetailLedger(
                                //                   orderId: upiList[index].orderId,
                                //                   billingid: upiList[index].billingId,
                                //                   salereturn: upiList[index].isReturn,
                                //                 )));
                                //   },
                                child: Stack(children: [
                                  Container(
                                    height: 80,
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          offset: Offset(0.0, 0.0), //(x,y)
                                          blurRadius: 7,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "+91 ${upiList[index].mobile}",
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                              ),
                                              Text(
                                                "${DateFormat("dd MMM yyyy").format(upiList[index].date)}",
                                                style: TextStyle(
                                                    fontSize: 13, color: TextGrey, fontWeight: FontWeight.bold),
                                              ),
                                            ]),
                                        upiList[index].vendorMyProfit.isEmpty
                                            ? Text(
                                                " \u20B9 ${double.parse(upiList[index].myProfitVendor).toStringAsFixed(2)} ",
                                                style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: GreenBoxTextColor),
                                              )
                                            : Text(
                                                " \u20B9 ${double.parse(upiList[index].vendorMyProfit).toStringAsFixed(2)} ",
                                                style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
                                              ),
                                      ]),
                                    ),
                                  ),
                                  upiList[index].isReturn == 1
                                      ? Positioned(
                                          left: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 80,
                                            width: 28,
                                            decoration: BoxDecoration(
                                                color: ColorPrimary,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(7), bottomLeft: Radius.circular(7))),
                                            child: RotatedBox(
                                              quarterTurns: 3,
                                              child: Center(
                                                child: Text("return_key".tr(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ]),
                                // ),
                              );
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Net Settlement Amount".tr(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                            ),
                            Text(
                              "\u20B9 ${widget.amount.toStringAsFixed(2)}",
                              style:
                                  GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "To: MyProfit",
                                  style:
                                      GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                                ),
                                Text(
                                  "From: $name",
                                  style:
                                      GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: TextGrey), borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bank Transaction ID",
                                style: GoogleFonts.openSans(fontSize: 16, color: TextGrey),
                              ),
                              Text(
                                "2020282826826",
                                //"${widget.order.paymentDetails.first.bankTxnId}",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, color: TextBlackLight, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "To: MyProfit",
                                style: GoogleFonts.openSans(fontSize: 16, color: TextGrey),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "From: $name",
                                style: GoogleFonts.openSans(fontSize: 16, color: TextGrey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}

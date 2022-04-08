import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/get_due_amount_response.dart';
import 'package:vendor/model/get_vendor_free_coin.dart';
import 'package:vendor/ui/money_due_upi/daily_ledger/daily_ledger.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_state.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/free_coin_history.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/master_ledger_detail.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/redeem_coins/redeem_coin_history.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/upi_transfer/upi_transfer_history.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

class DueAmountScreen extends StatefulWidget {
  @override
  _DueAmountScreenState createState() => _DueAmountScreenState();
}

class _DueAmountScreenState extends State<DueAmountScreen> {
  static const paytmUpiPayment = MethodChannel("com.myprofit.vendor/paytmUpiPayment");
  MoneyDueBloc moneyDueBloc = MoneyDueBloc();
  GetVendorFreeCoinData? freecoin;
  List<CategoryDueAmount> categoryDue = [];
  String dueAmount = "0.0";
  String result = "";
  String mid = "", orderId = "", token = "", callbackurl = "";
  int condition = 0;
  @override
  void initState() {
    super.initState();
    moneyDueBloc.add(GetFreeCoins());
  }

  callMethod() {
    moneyDueBloc.add(GetFreeCoins());
  }

  payment() {
    var response = AllInOneSdk.startTransaction(mid, orderId, "1", token, callbackurl, false, true);
    // log("response ${response.}");
    response.then((value) {
      print(value);

      setState(() {
        result = value.toString();

        log("====>result1$result");
        processTransictionApi(
          mid: value!["MID"],
          orderId: value["ORDERID"],
        );
      });
    }).catchError((onError) {
      if (onError is PlatformException) {
        setState(() {
          result = '${onError.message.toString() + ' \n  ' + onError.details.toString()}';
          log("====>result2$result");
        });
      } else {
        setState(() {
          result = onError.toString();
          log("====>result3$result");
        });
      }
    });
  }

  Future<void> paymentTransiction(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["amount"] = 1;

    log("=====? $input");

    moneyDueBloc.add(GetInitiateTransiction(input));
  }

  void processTransictionApi({required String mid, required String orderId}) async {
    try {
      log("inputs--->yha tak");
      // String url = "https://securegw.paytm.in/theia/api/v1/processTransaction"; live
      String url = "http://vendor.myprofitinc.com/api/v1/checkOnlinePayment"; //staging
      Map<String, dynamic> map = {};

      map["mid"] = mid;
      map["ORDER_ID"] = orderId;

      CommonResponse res = await apiProvider.checkPaymentStatus(map);
      res.success == true ? _displayDialogs(context, 1) : _displayDialogs(context, 0);
      log("Response--->$res");
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double mwidth = MediaQuery.of(context).size.width;
    double mheight = MediaQuery.of(context).size.height;
    return BlocProvider<MoneyDueBloc>(
      create: (context) => moneyDueBloc,
      child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: condition == 0 ? ApproveTextColor : ColorPrimary,
            ),
            title: Text("money_due_upi_key".tr()),
            elevation: 0,
            backgroundColor: condition == 0 ? ApproveTextColor : ColorPrimary,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.50,
                    color: condition == 0 ? ApproveTextColor : ColorPrimary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                        ),
                        BlocConsumer<MoneyDueBloc, MoneyDueState>(
                          listener: (context, state) {
                            if (state is GetPaymentTransictionState) {
                              mid = state.mid;
                              orderId = state.orderId;
                              token = state.txnToken;
                              callbackurl = state.callbackUrl;
                              payment();
                            }
                          },
                          builder: (context, state) {
                            if (state is MoneyDueInitialState) {
                              moneyDueBloc.add(GetDueAmount());
                            }
                            if (state is GetDueAmountState) {
                              moneyDueBloc.add(GetFreeCoins());
                              log("due ammount ---> ${state.dueAmount}");
                              dueAmount = state.dueAmount;
                              categoryDue = state.categoryDue;
                              //  paymentTransiction(context);
                            }
                            if (state is GetPaymentTransictionState) {
                              mid = state.mid;
                              orderId = state.orderId;
                              token = state.txnToken;
                              callbackurl = state.callbackUrl;
                            }
                            if (state is GetFreeCoinState) {
                              freecoin = state.data;
                              if (freecoin!.availableCoins == "0") {
                                condition = 0;
                              }
                              log("=====>${freecoin}");
                            }
                            return Text(
                              "₹ $dueAmount",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            );
                          },
                        ),
                        Text(
                          "company_due_amount_key".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.20,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0.0, 1.0), //(x,y)
                                color: Colors.white)
                          ]),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "types_of_money_due_key".tr(),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        log("hiiiii");
                                        Navigator.push(context,
                                            PageTransition(child: NormalLedger(), type: PageTransitionType.fade));
                                      },
                                      child: Container(
                                        height: 70,
                                        width: mwidth * 0.42,
                                        padding: EdgeInsets.fromLTRB(18, 20, 18, 0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              offset: Offset(0, 0), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("normal_ledger_key".tr(),
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 16.3, fontWeight: FontWeight.w600)),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -27,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0, -6), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Image.asset("assets/images/money-due1.png", width: 27),
                                      ),
                                    ),
                                    Positioned(
                                      top: -14,
                                      right: 28,
                                      child: Container(
                                        width: 32,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Color(0xff6657f4).withOpacity(0.10),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -8,
                                      right: 15,
                                      child: Container(
                                        width: 32,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Color(0xff6657f4).withOpacity(0.25),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context, PageTransition(child: DailyLedger(), type: PageTransitionType.fade));
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: mwidth * 0.42,
                                      padding: EdgeInsets.fromLTRB(18, 20, 18, 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            offset: Offset(0, 0), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Daily Ledger".tr(),
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 16.3, fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -27,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0, -6), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Image.asset("assets/images/money-due2.png", width: 27),
                                      ),
                                    ),
                                    Positioned(
                                      top: -14,
                                      right: 28,
                                      child: Container(
                                        width: 32,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Color(0xff6657f4).withOpacity(0.10),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -8,
                                      right: 15,
                                      child: Container(
                                        width: 32,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Color(0xff6657f4).withOpacity(0.25),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context,
                                  //     PageTransition(child: UpiTransferHistory(), type: PageTransitionType.fade));
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: mwidth * 0.42,
                                      padding: EdgeInsets.fromLTRB(18, 20, 18, 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            offset: Offset(0, 0), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("upi_transfer_key".tr(),
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 16.3, fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -27,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0, -6), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Image.asset("assets/images/money-due2.png", width: 27),
                                      ),
                                    ),
                                    Positioned(
                                      top: -14,
                                      right: 28,
                                      child: Container(
                                        width: 32,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Color(0xff6657f4).withOpacity(0.10),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -8,
                                      right: 15,
                                      child: Container(
                                        width: 32,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Color(0xff6657f4).withOpacity(0.25),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        log("hiiiii");
                                        Navigator.push(context,
                                            PageTransition(child: ReddemCoinHistory(), type: PageTransitionType.fade));
                                      },
                                      child: Container(
                                        height: 70,
                                        width: mwidth * 0.42,
                                        padding: EdgeInsets.fromLTRB(18, 20, 18, 0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              offset: Offset(0, 0), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("redeem_coins_key".tr(),
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 16.3, fontWeight: FontWeight.w600)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -27,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0, -6), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Image.asset("assets/images/money-due4.png", width: 27),
                                      ),
                                    ),
                                    Positioned(
                                      top: -14,
                                      right: 28,
                                      child: Container(
                                        width: 32,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Color(0xff6657f4).withOpacity(0.10),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -8,
                                      right: 15,
                                      child: Container(
                                        width: 32,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Color(0xff6657f4).withOpacity(0.25),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        BlocConsumer<MoneyDueBloc, MoneyDueState>(
                            bloc: moneyDueBloc,
                            listener: (context, state) {
                              if (state is GetFreeCoinState) {
                                freecoin = state.data;
                                log("=====>${freecoin}");
                              }
                            },
                            builder: (context, state) {
                              log("state=====>${state}");
                              if (state is GetFreeCoinState) {
                                freecoin = state.data;
                                log("=====>${freecoin}");
                              }

                              if (freecoin == null) {
                                return Container();
                              }
                              if (freecoin!.availableCoins == "0") {
                                return Container();
                              }
                              if (freecoin == null) {
                                return Container(height: 70, child: Center(child: CircularProgressIndicator()));
                              }
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        PageTransition(child: FreeCoinsHistory(), type: PageTransitionType.fade));
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: mwidth * 0.88,
                                        padding: EdgeInsets.fromLTRB(18, 20, 18, 0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              offset: Offset(0, 0), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("free_coins_key".tr(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.3,
                                                      fontWeight: FontWeight.w600)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 15,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "remaining_key".tr(),
                                                style: TextStyle(
                                                    fontSize: 10, color: ColorTextPrimary, fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                "${double.parse(freecoin!.availableCoins).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: 13, color: ColorPrimary, fontWeight: FontWeight.bold),
                                              ),
                                              Text("out_of_key".tr(),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: ColorTextPrimary,
                                                      fontWeight: FontWeight.w500)),
                                              Text(
                                                "${double.parse(freecoin!.totalCoins).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: 13, color: ColorPrimary, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                      Positioned(
                                        top: -27,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: Offset(0, -6), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(5),
                                            ),
                                          ),
                                          child: Image.asset("assets/images/money-due5.png", width: 27),
                                        ),
                                      ),
                                      Positioned(
                                        top: -14,
                                        right: 28,
                                        child: Container(
                                          width: 32,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Color(0xff6657f4).withOpacity(0.10),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -8,
                                        right: 15,
                                        child: Container(
                                          width: 32,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Color(0xff6657f4).withOpacity(0.25),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: MaterialButton(
            onPressed: () {
              paymentTransiction(context);
            },
            color: condition == 0 ? PurpleLightColor : ColorPrimary,
            height: 50,
            shape: RoundedRectangleBorder(),
            child: Text(
              "upi_transfer_key".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
    );
  }

  _displayDialogs(BuildContext context, status) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset(
                  "assets/images/otp-wallet.png",
                  fit: BoxFit.cover,
                  height: 70,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    "assets/images/point.png",
                    scale: 3,
                  ),
                  Text(
                    " $status ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 17.0,
                      color: ColorPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                Text("Coins generated succesfully\n in customer Wallet",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 17.0,
                      color: ColorTextPrimary,
                      fontWeight: FontWeight.w600,
                    )),
              ]),
              actions: <Widget>[
                Center(
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.40,
                    height: 50,
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: ColorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      Navigator.pop(context, true);
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(child: DueAmountScreen(), type: PageTransitionType.fade),
                          ModalRoute.withName("/"));
                    },
                    child: new Text(
                      "done_key".tr(),
                      style: GoogleFonts.openSans(
                          fontSize: 17, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        });
  }
}

import 'dart:collection';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
// ignore: unnecessary_import
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/ui/home/bottom_navigation_home.dart';
import 'package:vendor/ui/home/home.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_bloc.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_event.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_state.dart';
import 'package:vendor/ui/money_due_upi/daily_ledger/daily_ledger.dart';
import 'package:vendor/ui/money_due_upi/free_coins/free_coins_history.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/reddem_coin_history.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return.dart';
import 'package:vendor/ui/money_due_upi/upi_transfer/upi_transfer_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

import '../../model/get_vendor_free_coin.dart';

import '../../widget/Upi_Summary_box.dart';
import '../../widget/progress_indecator.dart';

class MoneyDueScreen extends StatefulWidget {
  bool? isShow;
  MoneyDueScreen(this.isShow);
  @override
  _MoneyDueScreenState createState() => _MoneyDueScreenState();
}

class _MoneyDueScreenState extends State<MoneyDueScreen> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const paytmUpiPayment =
      MethodChannel("com.myprofit.vendor/paytmUpiPayment");
  // Get battery level.
  // String _batteryLevel = 'Unknown battery level.';

  // Future<void> _getBatteryLevel() async {
  //   String batteryLevel;
  //
  //   try {
  //     final int result = await platform.invokeMethod('getBatteryLevel');
  //     log("battery level 1-->$result");
  //     batteryLevel = 'Battery level at $result % .';
  //   } on PlatformException catch (e) {
  //     batteryLevel = "Failed to get battery level: '${e.message}'.";
  //     log("battery level 1-->$batteryLevel");
  //   }
  //
  //   setState(() {
  //     _batteryLevel = batteryLevel;
  //   });
  // }

  MoneyDueBloc moneyDueBloc = MoneyDueBloc();
  double totalRedeemption = 0;
  double totalCoinGenration = 0;
  String dueAmount = "0.0";
  String vendorToMyProfitPaymentid = "";
  String myProfitToVendorPaymentid = "";
  GetVendorFreeCoinData? freecoin;
  String result = "";
  String mid = "", orderId = "", token = "", callbackurl = "";
  int condition = 1;
  String availableconis = "0";
  String vendorName = "";
  bool initialloader = true;
  void getname() async {
    vendorName = await SharedPref.getStringPreference(SharedPref.VENDORNAME);
    availableconis =
        await SharedPref.getStringPreference(SharedPref.VendorCoin);
    setState(() {});
    log("=======>$vendorName");
    log("=======>$availableconis");
    initialloader = false;
  }

  @override
  void initState() {
    super.initState();

    getname();
    moneyDueBloc.add(GetFreeCoins());
  }

  @override
  void didUpdateWidget(covariant MoneyDueScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  payment() {
    var response = AllInOneSdk.startTransaction(
        mid, orderId, dueAmount, token, callbackurl, false, true);
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
          result =
              '${onError.message.toString() + ' \n  ' + onError.details.toString()}';
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

  void processTransictionApi(
      {required String mid, required String orderId}) async {
    try {
      log("inputs--->yha tak");
      // String url = "https://securegw.paytm.in/theia/api/v1/processTransaction"; live
      String url =
          "http://vendor.myprofitinc.com/api/v1/checkOnlinePayment"; //staging
      Map<String, dynamic> map = {};

      map["mid"] = mid;
      map["ORDER_ID"] = orderId;

      CommonResponse res = await apiProvider.checkPaymentStatus(map);
      res.success == true
          ? _displayDialogs(context, dueAmount)
          : _displayDialogs(context, dueAmount);
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

  Future<void> paymentTransiction(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] =
        await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["amount"] = double.parse(dueAmount).toStringAsFixed(2);
    input["vendor_myprofit_payment_id"] = vendorToMyProfitPaymentid.toString();
    input["myprofit_vendor_payment_id"] = myProfitToVendorPaymentid.toString();
    log("=====? $input");
    EasyLoading.show();
    moneyDueBloc.add(GetInitiateTransiction(input));
  }

  @override
  Widget build(BuildContext context) {
    double mwidth = MediaQuery.of(context).size.width;
    double mheight = MediaQuery.of(context).size.height;
    return BlocProvider<MoneyDueBloc>(
        create: (context) => moneyDueBloc,
        child:
            BlocBuilder<MoneyDueBloc, MoneyDueState>(builder: (context, state) {
          if (state is GetPaymentTransictionState) {
            mid = state.mid;
            orderId = state.orderId;
            token = state.txnToken;
            callbackurl = state.callbackUrl;
            payment();
          }
          if (state is GetPaymentTransictionFailureState) {
            Utility.showToast(msg: "${state.message}");
          }
          if (state is GetFreeCoinState) {
            freecoin = state.data;
            SharedPref.setStringPreference(
                SharedPref.VendorCoin, freecoin!.availableCoins);

            if (freecoin!.availableCoins == "0") {}
            moneyDueBloc.add(GetDueAmount());
          }

          // if (state is MoneyDueInitialState) {

          // }
          if (state is GetFreeCoinLoadingState) {
            return Center(
              child: CircularLoader(),
            );
          }
          if (state is GetVendorEarnGenerateState) {
            totalRedeemption = state.data.totalRedeemption;
            totalCoinGenration = state.data.totalCoinGenration;
          }
          if (state is GetDueAmountState) {
            // moneyDueBloc.add(GetFreeCoins());
            log("due ammount ---> ${state.dueAmount}");
            dueAmount = state.dueAmount.myProfitVendorDue == "0"
                ? state.dueAmount.vendorMyProfitDue
                : state.dueAmount.myProfitVendorDue;

            // paymentid = state.dueAmount.myProfitVendorDue == "0"
            //     ? state.dueAmount.myprofitVendorPaymentId
            //     : state.dueAmount.vendorMyprofitPaymentId;
            vendorToMyProfitPaymentid =
                state.dueAmount.vendorMyprofitPaymentId.isEmpty
                    ? ""
                    : state.dueAmount.vendorMyprofitPaymentId;
            myProfitToVendorPaymentid =
                state.dueAmount.myprofitVendorPaymentId.isEmpty
                    ? ""
                    : state.dueAmount.myprofitVendorPaymentId;
            state.dueAmount.myProfitVendorDue == "0"
                ? condition = 1
                : condition = 0;
            // paymentTransiction(context);
          }
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor:
                      condition == 0 ? ApproveTextColor : ColorPrimary,
                ),
                backgroundColor:
                    condition == 0 ? ApproveTextColor : ColorPrimary,
                title: Text(
                  "money_due_upi_key".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                automaticallyImplyLeading: widget.isShow!,
                elevation: 0,
                leading: widget.isShow! == true
                    ? IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      )
                    : Container(),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              child: HomeScreen(),
                              type: PageTransitionType.fade),
                          ModalRoute.withName("/"));
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/home.png"),
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.93,
                  child: Stack(
                    //alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 50,
                        color: condition == 0 ? ApproveTextColor : ColorPrimary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.08,
                            ),
                            Text(
                              "₹ ${double.parse(dueAmount).toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            condition == 0
                                ? Text(
                                    "MyProfit " +
                                        "to_key".tr() +
                                        " $vendorName ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  )
                                : Text(
                                    " $vendorName " +
                                        "to_key".tr() +
                                        " MyProfit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.20,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0.0, 0.0), //(x,y)
                                    color: Colors.white)
                              ]),
                          child: double.parse(availableconis) <= 0.00
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: UpiSummaryBox(
                                            billingcounter: "0",
                                            gencoin:
                                                totalCoinGenration.toString(),
                                            reedemamount:
                                                totalRedeemption.toString()),
                                      ),

                                      // Padding(
                                      //   padding: const EdgeInsets.all(20.0),
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       GestureDetector(
                                      //         onTap: () {
                                      //           Navigator.push(
                                      //               context,
                                      //               PageTransition(
                                      //                   child: DailyLedger(
                                      //                       amount: dueAmount),
                                      //                   type: PageTransitionType
                                      //                       .fade));
                                      //         },
                                      //         child: Stack(
                                      //           clipBehavior: Clip.none,
                                      //           children: [
                                      //             Container(
                                      //               height: 70,
                                      //               width: mwidth * 0.42,
                                      //               padding:
                                      //                   EdgeInsets.fromLTRB(
                                      //                       18, 20, 18, 0),
                                      //               decoration: BoxDecoration(
                                      //                 color: Colors.white,
                                      //                 boxShadow: [
                                      //                   BoxShadow(
                                      //                     color: Colors.grey
                                      //                         .withOpacity(0.2),
                                      //                     spreadRadius: 2,
                                      //                     blurRadius: 10,
                                      //                     offset: Offset(0,
                                      //                         0), // changes position of shadow
                                      //                   ),
                                      //                 ],
                                      //                 borderRadius:
                                      //                     BorderRadius.only(
                                      //                   topRight:
                                      //                       Radius.circular(10),
                                      //                   bottomLeft:
                                      //                       Radius.circular(10),
                                      //                   bottomRight:
                                      //                       Radius.circular(10),
                                      //                 ),
                                      //               ),
                                      //               child: Column(
                                      //                 crossAxisAlignment:
                                      //                     CrossAxisAlignment
                                      //                         .start,
                                      //                 children: [
                                      //                   Text(
                                      //                       "daily_ledger_key"
                                      //                           .tr(),
                                      //                       style: GoogleFonts.openSans(
                                      //                           color:
                                      //                               TextBlackLight,
                                      //                           fontSize: 15,
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w700)),
                                      //                   SizedBox(
                                      //                     height: 5,
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //             Positioned(
                                      //               top: -27,
                                      //               child: Container(
                                      //                 padding:
                                      //                     EdgeInsets.symmetric(
                                      //                         vertical: 8,
                                      //                         horizontal: 15),
                                      //                 decoration: BoxDecoration(
                                      //                   color: Colors.white,
                                      //                   boxShadow: [
                                      //                     BoxShadow(
                                      //                       color: Colors.grey
                                      //                           .withOpacity(
                                      //                               0.1),
                                      //                       spreadRadius: 1,
                                      //                       blurRadius: 7,
                                      //                       offset: Offset(0,
                                      //                           -6), // changes position of shadow
                                      //                     ),
                                      //                   ],
                                      //                   borderRadius:
                                      //                       BorderRadius.only(
                                      //                     topLeft:
                                      //                         Radius.circular(
                                      //                             10),
                                      //                     topRight:
                                      //                         Radius.circular(
                                      //                             5),
                                      //                   ),
                                      //                 ),
                                      //                 child: Image.asset(
                                      //                     "assets/images/money-due6.png",
                                      //                     width: 27),
                                      //               ),
                                      //             ),
                                      //             Positioned(
                                      //               top: -14,
                                      //               right: 28,
                                      //               child: Container(
                                      //                 width: 32,
                                      //                 height: 14,
                                      //                 decoration: BoxDecoration(
                                      //                   color: Color(0xff6657f4)
                                      //                       .withOpacity(0.10),
                                      //                   borderRadius:
                                      //                       BorderRadius.only(
                                      //                     topLeft:
                                      //                         Radius.circular(
                                      //                             5),
                                      //                     topRight:
                                      //                         Radius.circular(
                                      //                             5),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Positioned(
                                      //               top: -8,
                                      //               right: 15,
                                      //               child: Container(
                                      //                 width: 32,
                                      //                 height: 8,
                                      //                 decoration: BoxDecoration(
                                      //                   color: Color(0xff6657f4)
                                      //                       .withOpacity(0.25),
                                      //                   borderRadius:
                                      //                       BorderRadius.only(
                                      //                     topLeft:
                                      //                         Radius.circular(
                                      //                             5),
                                      //                     topRight:
                                      //                         Radius.circular(
                                      //                             5),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             right: 0.0),
                                      //         child: GestureDetector(
                                      //           child: Stack(
                                      //             clipBehavior: Clip.none,
                                      //             children: [
                                      //               Container(
                                      //                 width: mwidth * 0.42,
                                      //                 height: 70,
                                      //                 padding:
                                      //                     EdgeInsets.fromLTRB(
                                      //                         18, 20, 18, 0),
                                      //                 decoration: BoxDecoration(
                                      //                   color: Colors.white,
                                      //                   boxShadow: [
                                      //                     BoxShadow(
                                      //                       color: Colors.grey
                                      //                           .withOpacity(
                                      //                               0.2),
                                      //                       spreadRadius: 2,
                                      //                       blurRadius: 10,
                                      //                       offset: Offset(0,
                                      //                           0), // changes position of shadow
                                      //                     ),
                                      //                   ],
                                      //                   borderRadius:
                                      //                       BorderRadius.only(
                                      //                     topRight:
                                      //                         Radius.circular(
                                      //                             10),
                                      //                     bottomLeft:
                                      //                         Radius.circular(
                                      //                             10),
                                      //                     bottomRight:
                                      //                         Radius.circular(
                                      //                             10),
                                      //                   ),
                                      //                 ),
                                      //                 child: Column(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment
                                      //                           .start,
                                      //                   children: [
                                      //                     SizedBox(
                                      //                       height: 5,
                                      //                     ),
                                      //                     Text(
                                      //                         "upi_history_key"
                                      //                             .tr(),
                                      //                         style: GoogleFonts.openSans(
                                      //                             color:
                                      //                                 TextBlackLight,
                                      //                             fontSize: 15,
                                      //                             fontWeight:
                                      //                                 FontWeight
                                      //                                     .w700)),
                                      //                     SizedBox(
                                      //                       height: 10,
                                      //                     )
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               Positioned(
                                      //                 top: -27,
                                      //                 child: Container(
                                      //                   padding: EdgeInsets
                                      //                       .symmetric(
                                      //                           vertical: 8,
                                      //                           horizontal: 15),
                                      //                   decoration:
                                      //                       BoxDecoration(
                                      //                     color: Colors.white,
                                      //                     boxShadow: [
                                      //                       BoxShadow(
                                      //                         color: Colors.grey
                                      //                             .withOpacity(
                                      //                                 0.1),
                                      //                         spreadRadius: 1,
                                      //                         blurRadius: 7,
                                      //                         offset: Offset(0,
                                      //                             -6), // changes position of shadow
                                      //                       ),
                                      //                     ],
                                      //                     borderRadius:
                                      //                         BorderRadius.only(
                                      //                       topLeft:
                                      //                           Radius.circular(
                                      //                               10),
                                      //                       topRight:
                                      //                           Radius.circular(
                                      //                               5),
                                      //                     ),
                                      //                   ),
                                      //                   child: Image.asset(
                                      //                       "assets/images/money-due2.png",
                                      //                       width: 27),
                                      //                 ),
                                      //               ),
                                      //               Positioned(
                                      //                 top: -14,
                                      //                 right: 28,
                                      //                 child: Container(
                                      //                   width: 32,
                                      //                   height: 14,
                                      //                   decoration:
                                      //                       BoxDecoration(
                                      //                     color:
                                      //                         Color(0xff6657f4)
                                      //                             .withOpacity(
                                      //                                 0.10),
                                      //                     borderRadius:
                                      //                         BorderRadius.only(
                                      //                       topLeft:
                                      //                           Radius.circular(
                                      //                               5),
                                      //                       topRight:
                                      //                           Radius.circular(
                                      //                               5),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //               Positioned(
                                      //                 top: -8,
                                      //                 right: 15,
                                      //                 child: Container(
                                      //                   width: 32,
                                      //                   height: 8,
                                      //                   decoration:
                                      //                       BoxDecoration(
                                      //                     color:
                                      //                         Color(0xff6657f4)
                                      //                             .withOpacity(
                                      //                                 0.25),
                                      //                     borderRadius:
                                      //                         BorderRadius.only(
                                      //                       topLeft:
                                      //                           Radius.circular(
                                      //                               5),
                                      //                       topRight:
                                      //                           Radius.circular(
                                      //                               5),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //           onTap: () {
                                      //             Navigator.push(
                                      //                 context,
                                      //                 PageTransition(
                                      //                     child:
                                      //                         UpiTransferHistory(),
                                      //                     type:
                                      //                         PageTransitionType
                                      //                             .fade));
                                      //           },
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: DailyLedger(
                                                            amount: dueAmount),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: mwidth * 0.42,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            18, 20, 18, 0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 2,
                                                          blurRadius: 10,
                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "daily_ledger_key"
                                                                .tr(),
                                                            style: GoogleFonts.openSans(
                                                                color:
                                                                    TextBlackLight,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -27,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                -6), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                          "assets/images/money-due6.png",
                                                          width: 27),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -14,
                                                    right: 28,
                                                    child: Container(
                                                      width: 32,
                                                      height: 14,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.10),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.25),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: GestureDetector(
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      width: mwidth * 0.42,
                                                      height: 70,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              18, 20, 18, 0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            offset: Offset(0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "upi_history_key"
                                                                  .tr(),
                                                              style: GoogleFonts.openSans(
                                                                  color:
                                                                      TextBlackLight,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                          SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -27,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 1,
                                                              blurRadius: 7,
                                                              offset: Offset(0,
                                                                  -6), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                        child: Image.asset(
                                                            "assets/images/money-due2.png",
                                                            width: 27),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -14,
                                                      right: 28,
                                                      child: Container(
                                                        width: 32,
                                                        height: 14,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff6657f4)
                                                                  .withOpacity(
                                                                      0.10),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff6657f4)
                                                                  .withOpacity(
                                                                      0.25),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child:
                                                              UpiTransferHistory(),
                                                          type:
                                                              PageTransitionType
                                                                  .fade));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: mwidth * 0.42,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            18, 20, 18, 0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 2,
                                                          blurRadius: 10,
                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "return_ledger_key"
                                                                .tr(),
                                                            style: GoogleFonts.openSans(
                                                                color:
                                                                    TextBlackLight,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                -6), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                          "assets/images/money-due3.png",
                                                          width: 27),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -14,
                                                    right: 28,
                                                    child: Container(
                                                      width: 32,
                                                      height: 14,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.10),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.25),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child:
                                                            SalesReturnHistory(),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: GestureDetector(
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      height: 70,
                                                      width: mwidth * 0.42,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              18, 20, 18, 0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            offset: Offset(0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "redeem_coins_history_key"
                                                                  .tr(),
                                                              style: GoogleFonts.openSans(
                                                                  color:
                                                                      TextBlackLight,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -27,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 1,
                                                              blurRadius: 7,
                                                              offset: Offset(0,
                                                                  -6), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                        child: Image.asset(
                                                            "assets/images/money-due4.png",
                                                            width: 27),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -14,
                                                      right: 28,
                                                      child: Container(
                                                        width: 32,
                                                        height: 14,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff6657f4)
                                                                  .withOpacity(
                                                                      0.10),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff6657f4)
                                                                  .withOpacity(
                                                                      0.25),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child:
                                                              ReddemCoinHistory(),
                                                          type:
                                                              PageTransitionType
                                                                  .fade));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      log("hiiiii");
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              child:
                                                                  NormalLedger(),
                                                              type:
                                                                  PageTransitionType
                                                                      .fade));
                                                    },
                                                    child: Container(
                                                      height: 70,
                                                      width: mwidth * 0.88,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              18, 20, 18, 0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            offset: Offset(0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "master_ledger_key"
                                                                  .tr(),
                                                              style: GoogleFonts.openSans(
                                                                  color:
                                                                      TextBlackLight,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                -6), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                          "assets/images/money-due1.png",
                                                          width: 27),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -14,
                                                    right: 28,
                                                    child: Container(
                                                      width: 32,
                                                      height: 14,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.10),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.25),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                    ])
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.all(15.0),
                                      //   child: Text(
                                      //     "types_of_money_due_key".tr(),
                                      //       style: GoogleFonts.openSans(
                                      //           color: TextBlackLight,
                                      //           fontSize: 16,
                                      //           fontWeight: FontWeight.w700)
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      log("hiiiii");
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              child:
                                                                  NormalLedger(),
                                                              type:
                                                                  PageTransitionType
                                                                      .fade));
                                                    },
                                                    child: Container(
                                                      height: 70,
                                                      width: mwidth * 0.42,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              18, 20, 18, 0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            offset: Offset(0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "master_ledger_key"
                                                                  .tr(),
                                                              style: GoogleFonts.openSans(
                                                                  color:
                                                                      TextBlackLight,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                -6), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                          "assets/images/money-due1.png",
                                                          width: 27),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -14,
                                                    right: 28,
                                                    child: Container(
                                                      width: 32,
                                                      height: 14,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.10),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.25),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                    context,
                                                    PageTransition(
                                                        child: DailyLedger(
                                                          amount: dueAmount,
                                                        ),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: mwidth * 0.42,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            18, 20, 18, 0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 2,
                                                          blurRadius: 10,
                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "daily_ledger_key"
                                                                .tr(),
                                                            style: GoogleFonts.openSans(
                                                                color:
                                                                    TextBlackLight,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -27,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                -6), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                          "assets/images/money-due6.png",
                                                          width: 27),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -14,
                                                    right: 28,
                                                    child: Container(
                                                      width: 32,
                                                      height: 14,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.10),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.25),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: GestureDetector(
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      width: mwidth * 0.42,
                                                      height: 70,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              18, 20, 18, 0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            offset: Offset(0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "upi_history_key"
                                                                  .tr(),
                                                              style: GoogleFonts.openSans(
                                                                  color:
                                                                      TextBlackLight,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                          SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -27,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 1,
                                                              blurRadius: 7,
                                                              offset: Offset(0,
                                                                  -6), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                        child: Image.asset(
                                                            "assets/images/money-due2.png",
                                                            width: 27),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -14,
                                                      right: 28,
                                                      child: Container(
                                                        width: 32,
                                                        height: 14,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff6657f4)
                                                                  .withOpacity(
                                                                      0.10),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff6657f4)
                                                                  .withOpacity(
                                                                      0.25),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child:
                                                              UpiTransferHistory(),
                                                          type:
                                                              PageTransitionType
                                                                  .fade));
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: mwidth * 0.42,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            18, 20, 18, 0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 2,
                                                          blurRadius: 10,
                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "return_ledger_key"
                                                              .tr(),
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color:
                                                                      TextBlackLight),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -27,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                -6), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                          "assets/images/money-due3.png",
                                                          width: 27),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -14,
                                                    right: 28,
                                                    child: Container(
                                                      width: 32,
                                                      height: 14,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.10),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.25),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child:
                                                            SalesReturnHistory(),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: GestureDetector(
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      height: 70,
                                                      width: mwidth * 0.42,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              18, 20, 18, 0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            offset: Offset(0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "redeem_coins_history_key"
                                                                  .tr(),
                                                              style: GoogleFonts.openSans(
                                                                  color:
                                                                      TextBlackLight,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -27,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 1,
                                                              blurRadius: 7,
                                                              offset: Offset(0,
                                                                  -6), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                        child: Image.asset(
                                                            "assets/images/money-due4.png",
                                                            width: 27),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -27,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 1,
                                                              blurRadius: 7,
                                                              offset: Offset(0,
                                                                  -6), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                        child: Image.asset(
                                                            "assets/images/money-due4.png",
                                                            width: 27),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -14,
                                                      right: 28,
                                                      child: Container(
                                                        width: 32,
                                                        height: 14,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff6657f4)
                                                                  .withOpacity(
                                                                      0.10),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff6657f4)
                                                                  .withOpacity(
                                                                      0.25),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child:
                                                              ReddemCoinHistory(),
                                                          type:
                                                              PageTransitionType
                                                                  .fade));
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: mwidth * 0.42,
                                                    height: 70,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            18, 20, 18, 0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 2,
                                                          blurRadius: 10,
                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "free_coins_key"
                                                                      .tr(),
                                                                  style: GoogleFonts.openSans(
                                                                      color:
                                                                          TextBlackLight,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          ),
                                                          // BlocConsumer<MoneyDueBloc, MoneyDueState>(
                                                          //     bloc: moneyDueBloc,
                                                          //     listener: (context, state) {
                                                          //       if (state is GetFreeCoinState) {
                                                          //         freecoin = state.data;
                                                          //         log("=====>${freecoin}");
                                                          //       }
                                                          //     },
                                                          //     builder: (context, state) {
                                                          //       log("state=====>${state}");
                                                          //       if (state is GetFreeCoinState) {
                                                          //         freecoin = state.data;
                                                          //         log("=====>${freecoin}");
                                                          //       }
                                                          //
                                                          //       if (freecoin == null) {
                                                          //         return Container(
                                                          //             height: 70, child: Center(child: CircularLoader()));
                                                          //       }
                                                          //       return Column(
                                                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //         children: [
                                                          //           Text(
                                                          //             "remaining_key".tr(),
                                                          //             style: TextStyle(
                                                          //                 fontSize: 9,
                                                          //                 color: ColorTextPrimary,
                                                          //                 fontWeight: FontWeight.w500),
                                                          //           ),
                                                          //           Text(
                                                          //             "${double.parse(freecoin!.availableCoins).toStringAsFixed(2)}",
                                                          //             style: TextStyle(
                                                          //                 fontSize: 12, color: ColorPrimary, fontWeight: FontWeight.bold),
                                                          //           ),
                                                          //           Text("out_of_key".tr(),
                                                          //               style: TextStyle(
                                                          //                   fontSize: 9,
                                                          //                   color: ColorTextPrimary,
                                                          //                   fontWeight: FontWeight.w500)),
                                                          //           Text(
                                                          //             "${double.parse(freecoin!.totalCoins).toStringAsFixed(2)}",
                                                          //             style: TextStyle(
                                                          //                 fontSize: 12, color: ColorPrimary, fontWeight: FontWeight.bold),
                                                          //           )
                                                          //         ],
                                                          //       );
                                                          //     })
                                                        ]),
                                                  ),
                                                  Positioned(
                                                      top: -0,
                                                      right: 02,
                                                      child: BlocConsumer<
                                                              MoneyDueBloc,
                                                              MoneyDueState>(
                                                          bloc: moneyDueBloc,
                                                          listener:
                                                              (context, state) {
                                                            if (state
                                                                is GetFreeCoinState) {
                                                              freecoin =
                                                                  state.data;
                                                              log("=====>${freecoin}");
                                                            }
                                                          },
                                                          builder:
                                                              (context, state) {
                                                            log("state=====>${state}");
                                                            if (state
                                                                is GetFreeCoinState) {
                                                              freecoin =
                                                                  state.data;
                                                              log("=====>${freecoin}");
                                                            }
                                                            if (state
                                                                is GetPaymentTransictionFailureState) {
                                                              Utility.showToast(
                                                                  msg:
                                                                      "${state.message}");
                                                              log("=====>${freecoin}");
                                                            }
                                                            if (freecoin ==
                                                                null) {
                                                              return Container(
                                                                  height: 70,
                                                                  child: Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                    color:
                                                                        ColorPrimary,
                                                                  )));
                                                            }
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "remaining_key"
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          ColorTextPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                Text(
                                                                  "${double.parse(freecoin!.availableCoins).toStringAsFixed(2)}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          ColorPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                  "out_of_key"
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          ColorTextPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                Text(
                                                                  "${double.parse(freecoin!.totalCoins).toStringAsFixed(2)}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          ColorPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            );
                                                          })),
                                                  Positioned(
                                                    top: -27,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                -6), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                          "assets/images/point.png",
                                                          width: 27),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -14,
                                                    right: 28,
                                                    child: Container(
                                                      width: 32,
                                                      height: 14,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.10),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
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
                                                        color: Color(0xff6657f4)
                                                            .withOpacity(0.25),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child:
                                                            FreeCoinsHistory(),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: MaterialButton(
                elevation: 0,
                onPressed: () {
                  condition == 1 ? paymentTransiction(context) : Container();
                },
                color: condition == 0 ? Colors.white : ColorPrimary,
                height: 50,
                shape: RoundedRectangleBorder(),
                child: Text(
                  "upi_transfer_key".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: condition == 0 ? Colors.white : Colors.white,
                  ),
                ),
              ));
        }));
  }

  _displayDialogs(BuildContext context, status) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/tick.png",
                      fit: BoxFit.cover,
                      height: 70,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "\u20B9 $status ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 17.0,
                        color: ColorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text("Your Payment is successfully done.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 13.0,
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      Navigator.pop(context, true);
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              child: BottomNavigationHome(index: 2),
                              type: PageTransitionType.fade),
                          ModalRoute.withName("/"));
                    },
                    child: new Text(
                      "done_key".tr(),
                      style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
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

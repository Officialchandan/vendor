import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:vendor/model/get_due_amount_response.dart';
import 'package:vendor/model/get_vendor_free_coin.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_bloc.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_state.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/free_coin_history.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/master_ledger_detail.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/redeem_coins/redeem_coin_history.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

class DueAmountScreen extends StatefulWidget {
  @override
  _DueAmountScreenState createState() => _DueAmountScreenState();
}

class _DueAmountScreenState extends State<DueAmountScreen> {
  MoneyDueBloc moneyDueBloc = MoneyDueBloc();
  GetVendorFreeCoinData? freecoin;
  List<CategoryDueAmount> categoryDue = [];
  String dueAmount = "0.0";
  String result = "";
  String mid = "", orderId = "", token = "", callbackurl = "";
  @override
  void initState() {
    super.initState();
    moneyDueBloc.add(GetFreeCoins());
  }

  payment() {
    var response = AllInOneSdk.startTransaction(mid, orderId, dueAmount, token, callbackurl, true, true);
    // log("response ${response.}");
    response.then((value) {
      print(value);
      setState(() {
        result = value.toString();
        log("====>result1$result");
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
    input["amount"] = dueAmount;

    log("=====? $input");

    moneyDueBloc.add(GetInitiateTransiction(input));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoneyDueBloc>(
      create: (context) => moneyDueBloc,
      child: Scaffold(
          appBar: AppBar(
            title: Text("money_due_upi_key".tr()),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.50,
                    color: ColorPrimary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                        ),
                        BlocBuilder<MoneyDueBloc, MoneyDueState>(
                          builder: (context, state) {
                            if (state is MoneyDueInitialState) {
                              moneyDueBloc.add(GetDueAmount());
                            }
                            if (state is GetDueAmountState) {
                              moneyDueBloc.add(GetFreeCoins());
                              log("due ammount ---> ${state.dueAmount}");
                              dueAmount = state.dueAmount;
                              categoryDue = state.categoryDue;
                              paymentTransiction(context);
                            }
                            if (state is GetPaymentTransictionState) {
                              mid = state.mid;
                              orderId = state.orderId;
                              token = state.txnToken;
                              callbackurl = state.callbackUrl;
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
                            "Types Of Money Due",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
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
                                        height: 85,
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
                                            Text("Normal Ledger",
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 16.3, fontWeight: FontWeight.w600)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 1,
                                              width: 70,
                                              color: ColorTextPrimary,
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
                                  // Navigator.push(context,
                                  //     PageTransition(child: UpiTransferHistory(), type: PageTransitionType.fade));
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 85,
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
                                          Text("UPI Transfer    ",
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 16.3, fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: 1,
                                            width: 70,
                                            color: ColorTextPrimary,
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
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
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
                                        height: 85,
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
                                            Text("Redeem Coins ",
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 16.3, fontWeight: FontWeight.w600)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 1,
                                              width: 70,
                                              color: ColorTextPrimary,
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      PageTransition(child: FreeCoinsHistory(), type: PageTransitionType.fade));
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 85,
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
                                            Text("Free Coins",
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 12.3, fontWeight: FontWeight.w600)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 1,
                                              width: 65,
                                              color: ColorTextPrimary,
                                            ),
                                          ],
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
                                                return Container(
                                                    height: 70, child: Center(child: CircularProgressIndicator()));
                                              }
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Remaining",
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        color: ColorTextPrimary,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "${double.parse(freecoin!.availableCoins).toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        fontSize: 11, color: ColorPrimary, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text("Out of",
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          color: ColorTextPrimary,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(
                                                    "${double.parse(freecoin!.totalCoins).toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        fontSize: 11, color: ColorPrimary, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            })
                                      ]),
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
            onPressed: () {},
            color: ColorPrimary,
            height: 50,
            shape: RoundedRectangleBorder(),
            child: Text(
              "upi_transfer_key".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}

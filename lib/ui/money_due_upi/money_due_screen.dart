import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/get_due_amount_response.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_bloc.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_event.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_state.dart';
import 'package:vendor/ui/money_due_upi/free_coins/free_coins_history.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/reddem_coin_history.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return.dart';
import 'package:vendor/ui/money_due_upi/upi_transfer/upi_transfer_screen.dart';
import 'package:vendor/utility/color.dart';

import '../../model/get_vendor_free_coin.dart';

class MoneyDueScreen extends StatefulWidget {
  bool? isShow;
  MoneyDueScreen(this.isShow);
  @override
  _MoneyDueScreenState createState() => _MoneyDueScreenState();
}

class _MoneyDueScreenState extends State<MoneyDueScreen> {
  MoneyDueBloc moneyDueBloc = MoneyDueBloc();

  List<CategoryDueAmount> categoryDue = [];
  String dueAmount = "0.0";
  GetVendorFreeCoinData? freecoin;
  @override
  void initState() {
    super.initState();
    moneyDueBloc.add(GetFreeCoins());
  }

  @override
  void didUpdateWidget(covariant MoneyDueScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoneyDueBloc>(
      create: (context) => moneyDueBloc,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("money_due_upi_key".tr()),
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
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Stack(
                //alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 50,
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
                              dueAmount = state.dueAmount;
                              categoryDue = state.categoryDue;
                            }

                            return Text(
                              "₹ $dueAmount",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
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
                        // BlocBuilder<MoneyDueBloc, MoneyDueState>(
                        //   builder: (context, state) {
                        //     if (state is MoneyDueInitialState) {
                        //       moneyDueBloc.add(GetDueAmount());
                        //     }
                        //     if (state is GetDueAmountState) {
                        //       dueAmount = state.dueAmount;
                        //       categoryDue = state.categoryDue;
                        //     }
                        //
                        //     return Column(
                        //       children: List.generate(
                        //           categoryDue.length,
                        //           (index) => Container(
                        //                 margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        //                 decoration: BoxDecoration(
                        //                   color: ColorPrimary,
                        //                   borderRadius: BorderRadius.circular(6),
                        //                 ),
                        //                 child: Container(
                        //                   margin: EdgeInsets.only(
                        //                     left: 3,
                        //                   ),
                        //                   decoration: BoxDecoration(
                        //                     color: Colors.grey.shade50,
                        //                     borderRadius: BorderRadius.only(
                        //                         topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                        //                   ),
                        //                   child: ListTile(
                        //                     onTap: () {},
                        //                     leading: Image(
                        //                       image: NetworkImage("${categoryDue[index].image}"),
                        //                       height: 30,
                        //                       width: 30,
                        //                       fit: BoxFit.contain,
                        //                     ),
                        //                     title: Text("${categoryDue[index].categoryName}"),
                        //                     // subtitle: Text("${categoryDue[index]["subTitle"]}"),
                        //
                        //                     trailing: Text("₹ ${categoryDue[index].myprofitRevenue}"),
                        //                   ),
                        //                 ),
                        //               )),
                        //     );
                        //   },
                        // ),

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
                                              height: 5,
                                            ),
                                            Text("Full Ledger History",
                                                style: TextStyle(
                                                    color: Color(0xff303030),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400)),
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
                                  Navigator.push(context,
                                      PageTransition(child: UpiTransferHistory(), type: PageTransitionType.fade));
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
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
                                          Text("UPI Transfer",
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
                                            height: 5,
                                          ),
                                          Text("UPI Transfer History",
                                              style: TextStyle(
                                                  color: Color(0xff303030), fontSize: 12, fontWeight: FontWeight.w400)),
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
                                child: GestureDetector(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
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
                                            Text("Sales Return",
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
                                              height: 5,
                                            ),
                                            Text("Sales Return History",
                                                style: TextStyle(
                                                    color: Color(0xff303030),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400)),
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
                                          child: Image.asset("assets/images/money-due3.png", width: 27),
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
                                  onTap: () {
                                    Navigator.push(context,
                                        PageTransition(child: SalesReturnHistory(), type: PageTransitionType.fade));
                                  },
                                ),
                              ),
                              GestureDetector(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
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
                                          Text("Redeem Coins",
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
                                            height: 5,
                                          ),
                                          Text("Coin History",
                                              style: TextStyle(
                                                  color: Color(0xff303030), fontSize: 12, fontWeight: FontWeight.w400)),
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
                                onTap: () {
                                  Navigator.push(context,
                                      PageTransition(child: ReddemCoinHistory(), type: PageTransitionType.fade));
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GestureDetector(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(18, 7, 18, 5),
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
                                          height: 5,
                                        ),
                                        Text("Free Coin History",
                                            style: TextStyle(
                                                color: Color(0xff303030), fontSize: 12, fontWeight: FontWeight.w400)),
                                        SizedBox(
                                          height: 10,
                                        )
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
                                                    fontSize: 11, color: ColorTextPrimary, fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                "${double.parse(freecoin!.availableCoins).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: 14, color: ColorPrimary, fontWeight: FontWeight.bold),
                                              ),
                                              Text("Out of",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: ColorTextPrimary,
                                                      fontWeight: FontWeight.w500)),
                                              Text(
                                                "${double.parse(freecoin!.totalCoins).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: 14, color: ColorPrimary, fontWeight: FontWeight.bold),
                                              )
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
                            onTap: () {
                              Navigator.push(
                                  context, PageTransition(child: FreeCoinsHistory(), type: PageTransitionType.fade));
                            },
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

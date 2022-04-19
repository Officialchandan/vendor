import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/utility/color.dart';

class FreeCoinDetail extends StatefulWidget {
  final OrderData freecoindetail;
  FreeCoinDetail({required this.freecoindetail});

  @override
  _FreeCoinDetailState createState() => _FreeCoinDetailState();
}

class _FreeCoinDetailState extends State<FreeCoinDetail> {
  OrderData? freecoindetails;
  double count = 0;
  double reddem = 0, finalamount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("${widget.freecoindetail.mobile}");
    // log("${widget.freecoindetail.orderDetails[0].redeemCoins}");
    freecoindetails = widget.freecoindetail;
    count = freecoindetails!.orderType == 0
        ? double.parse(freecoindetails!.orderDetails.length.toString())
        : double.parse(freecoindetails!.billingDetails.length.toString());
    log("====>$count");
    log("====>${freecoindetails!.orderType}");
    calculation();
  }

  void calculation() {
    if (widget.freecoindetail.orderType == 1) {
      reddem = double.parse(
          double.parse(widget.freecoindetail.billingDetails.first.redeemCoins)
              .toStringAsFixed(2));
      finalamount = double.parse(widget.freecoindetail.orderTotal);
    } else {
      widget.freecoindetail.orderDetails.forEach((element) {
        reddem +=
            double.parse(double.parse(element.redeemCoins).toStringAsFixed(2));
        log("$reddem");
        finalamount += double.parse(element.amountPaid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("free_coins_details_key".tr()),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 70,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${freecoindetails!.firstName}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: ColorTextPrimary),
                        ),
                        Text(
                          "${DateFormat("dd MMM yyyy").format(freecoindetails!.dateTime) +" "+ DateFormat.jm().format(freecoindetails!.dateTime)}",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Text(
                      "+91 ${freecoindetails!.mobile}",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: ColorTextPrimary),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: count == 1 ? 220 : 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 10),
                      child: Text(
                        "all_items_key".tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    Container(
                      height: count == 1 ? 90 : 165,
                      child: ListView.builder(
                        itemCount: freecoindetails!.orderType == 0
                            ? freecoindetails!.orderDetails.length
                            : freecoindetails!.billingDetails.length,
                        itemBuilder: ((context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: 5, bottom: 5, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      color: Colors.white,
                                      child: Image.asset(
                                        "assets/images/account-ic6.png",
                                        height: 45,
                                        width: 45,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 50,

                                      // width: MediaQuery.of(context).size.width * 0.60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              freecoindetails!.orderType == 0
                                                  ? Text(
                                                      "${freecoindetails!.orderDetails[index].productName}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                    )
                                                  : Text(
                                                      "${freecoindetails!.billingDetails[0].categoryName}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                              freecoindetails!.orderType == 0
                                                  ? Text(
                                                      "\u20B9 ${freecoindetails!.orderDetails[0].total}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: ColorPrimary),
                                                    )
                                                  : Text(
                                                      "\u20B9 ${freecoindetails!.billingDetails[0].total}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: ColorPrimary),
                                                    ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              freecoindetails!.orderType == 0
                                                  ? Text(
                                                      "${freecoindetails!.orderDetails[index].qty} x \u20B9 ${freecoindetails!.orderDetails[index].price}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey),
                                                    )
                                                  : Text(
                                                      "",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "earn_coins_key".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: ColorTextPrimary),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/point.png",
                                scale: 3,
                              ),
                              freecoindetails!.orderType == 0
                                  ? Text(
                                      " ${freecoindetails!.orderDetails[0].earningCoins} (\u20B9${(double.parse(freecoindetails!.orderDetails[0].earningCoins) / 3).toStringAsFixed(2)})",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: ColorTextPrimary),
                                    )
                                  : Text(
                                      " ${freecoindetails!.billingDetails[0].earningCoins} (\u20B9${(double.parse(freecoindetails!.billingDetails[0].earningCoins) / 3).toStringAsFixed(2)})",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: ColorTextPrimary),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "redeemed_coins_key".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: ColorTextPrimary),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/point.png",
                                scale: 3,
                              ),
                              // double.parse(freecoindetails!.orderDetails[0].redeemCoins) == 0.00
                              //     ? Text(
                              //         " 0",
                              //         style:
                              //             TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ColorTextPrimary),
                              //       )
                              //
                              Text(
                                " $reddem (\u20B9${double.parse((reddem / 3).toString()).toStringAsFixed(2)})",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: ColorTextPrimary),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "amt_paid_by_customer_key".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: ColorTextPrimary),
                          ),
                          Text(
                            "\u20B9 ${finalamount.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: ColorPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "earn_coins_key".tr(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/point.png",
                          scale: 3,
                        ),
                        freecoindetails!.orderType == 0
                            ? Text(
                                " ${freecoindetails!.orderDetails[0].earningCoins} (\u20B9${(double.parse(freecoindetails!.orderDetails[0].earningCoins) / 3).toStringAsFixed(2)})",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.white),
                              )
                            : Text(
                                " ${freecoindetails!.billingDetails[0].earningCoins} (\u20B9${(double.parse(freecoindetails!.billingDetails[0].earningCoins) / 3).toStringAsFixed(2)})",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.white),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

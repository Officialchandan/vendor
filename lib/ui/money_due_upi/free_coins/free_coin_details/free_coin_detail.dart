import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vendor/model/free_coin_history.dart';
import 'package:vendor/utility/color.dart';

class FreeCoinDetail extends StatefulWidget {
  final GetFreeCoinHistoryData freecoindetail;
  FreeCoinDetail({required this.freecoindetail});

  @override
  _FreeCoinDetailState createState() => _FreeCoinDetailState();
}

class _FreeCoinDetailState extends State<FreeCoinDetail> {
  GetFreeCoinHistoryData? freecoindetails;
  double count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("${widget.freecoindetail.mobile}");
    log("${widget.freecoindetail.orderDetails[0].redeemCoins}");
    freecoindetails = widget.freecoindetail;
    count = double.parse(freecoindetails!.orderDetails.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deatail"),
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
                          "${freecoindetails!.customerName}",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: ColorTextPrimary),
                        ),
                        Text(
                          "${freecoindetails!.dateTime}",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Text(
                      "+91 ${freecoindetails!.mobile}",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: ColorTextPrimary),
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
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "All Iteams",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    Container(
                      height: count == 1 ? 90 : 165,
                      child: ListView.builder(
                        itemCount: freecoindetails!.orderDetails.length,
                        itemBuilder: ((context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      color: Colors.amber,
                                      child: Image.asset(
                                        "assets/images/point.png",
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
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${freecoindetails!.orderDetails[index].productName}",
                                                style: TextStyle(
                                                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                              ),
                                              Text(
                                                "\u20B9 ${freecoindetails!.orderDetails[index].total}",
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.bold, color: ColorPrimary),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${freecoindetails!.orderDetails[index].qty} x \u20B9 ${freecoindetails!.orderDetails[index].price}",
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
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
                            "Earn Coins",
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: ColorTextPrimary),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/point.png",
                                scale: 3,
                              ),
                              Text(
                                " ${freecoindetails!.orderDetails[0].earningCoins} (\u20B9${(double.parse(freecoindetails!.orderDetails[0].earningCoins) / 3).toStringAsFixed(2)})",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ColorTextPrimary),
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
                            "Redeemed Coins",
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: ColorTextPrimary),
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
                              //     :
                              Text(
                                " ${double.parse(freecoindetails!.orderDetails[0].redeemCoins).toStringAsFixed(2)} (\u20B9${(double.parse(freecoindetails!.orderDetails[0].redeemCoins) / 3).toStringAsFixed(2)})",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ColorTextPrimary),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amount Paid By Customer",
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: ColorTextPrimary),
                          ),
                          Text(
                            "\u20B9 ${double.parse(freecoindetails!.orderDetails[0].amountPaid).toStringAsFixed(2)}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ColorPrimary),
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
                      "Earn Coins",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/point.png",
                          scale: 3,
                        ),
                        Text(
                          " ${freecoindetails!.orderDetails[0].earningCoins} (\u20B9${(double.parse(freecoindetails!.orderDetails[0].earningCoins) / 3).toStringAsFixed(2)})",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
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

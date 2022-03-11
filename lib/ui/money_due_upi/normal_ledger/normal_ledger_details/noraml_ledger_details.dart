import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vendor/model/get_master_ledger_history.dart';
import 'package:vendor/utility/color.dart';

class NormalLedgerDetails extends StatefulWidget {
  final List<CommonLedgerHistory> commonLedgerHistory;
  final int index;
  NormalLedgerDetails({Key? key, required this.commonLedgerHistory, required this.index}) : super(key: key);

  @override
  State<NormalLedgerDetails> createState() => _NormalLedgerDetailsState();
}

class _NormalLedgerDetailsState extends State<NormalLedgerDetails> {
  late List<CommonLedgerHistory> commonLedgerHistory;
  late int index;
  double reddem = 0, finalamount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commonLedgerHistory = widget.commonLedgerHistory;
    index = widget.index;
    log("$index");
    calculation();
  }

  void calculation() {
    commonLedgerHistory[index].orderDetails!.forEach((element) {
      reddem += double.parse(element.redeemCoins);
      log("$reddem");
      if (double.parse(commonLedgerHistory[index].myprofitRevenue) > reddem)
        log("${double.parse(commonLedgerHistory[index].myprofitRevenue)}");
      finalamount = double.parse(commonLedgerHistory[index].myprofitRevenue) - reddem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Normal Ledger Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${commonLedgerHistory[index].firstName}",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Text(
                                "${commonLedgerHistory[index].dateTime}",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "+91 ${commonLedgerHistory[index].mobile}",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: RejectedTextBgColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
                                  child: Text(
                                    "Pending",
                                    style:
                                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: RejectedTextColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14, top: 10),
                            child: Text(
                              "All Items",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: commonLedgerHistory[index].orderDetails!.length == 1 ? 80 : 160,
                          child: ListView.builder(
                            itemCount: commonLedgerHistory[index].orderDetails!.length,
                            itemBuilder: ((context, index) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //       color: Colors.black12,
                                        //       spreadRadius: 4,
                                        //       blurRadius: 10)
                                        // ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Container(
                                                  color: Colors.amber,
                                                  child: Image.network(
                                                    "${commonLedgerHistory[index].orderDetails![index].productImage}",
                                                    height: 45,
                                                    width: 45,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Flexible(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${commonLedgerHistory[index].orderDetails![index].productName}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black87),
                                                        ),
                                                        Text(
                                                          "\u20B9 ${commonLedgerHistory[index].orderDetails![index].total}",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.bold,
                                                              color: ColorPrimary),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${commonLedgerHistory[index].orderDetails![index].qty} x \u20B9 ${commonLedgerHistory[index].orderDetails![index].price}",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey),
                                                        ),
                                                        Text(
                                                          "Commission \u20B9${commonLedgerHistory[index].myprofitRevenue}",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black87),
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
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 25,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: RejectedTextBgColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
                                        child: Text(
                                          "Redeemed",
                                          style: TextStyle(
                                              color: RejectedTextColor, fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount Paid By Customer",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Text(
                                "\u20B9 ${commonLedgerHistory[index].orderTotal}",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ColorPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Commission Amount",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Commission",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Text(
                                "\u20B9${commonLedgerHistory[index].myprofitRevenue}",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Redeemed Amount",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              commonLedgerHistory[index].orderDetails![0].redeemCoins == 0
                                  ? Text(
                                      "\u20B9 0",
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                    )
                                  : Text(
                                      "\u20B9-${commonLedgerHistory[index].orderDetails![0].redeemCoins}",
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        // stops: [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          RedLightColor,
                          RedDarkColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amount Paid To My Profit",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            "\u20B9 $finalamount",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

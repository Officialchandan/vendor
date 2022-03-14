import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/utility/color.dart';

class NormalLedgerDetails extends StatefulWidget {
  // final List<OrderData> commonLedgerHistory;
  final OrderData order;

  // final int index;
  NormalLedgerDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<NormalLedgerDetails> createState() => _NormalLedgerDetailsState();
}

class _NormalLedgerDetailsState extends State<NormalLedgerDetails> {
  // late List<CommonLedgerHistory> commonLedgerHistory;
  double reddem = 0, finalamount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // commonLedgerHistory = widget.commonLedgerHistory;
    // index = widget.index;
    log("orderType-->${widget.order.orderType}");
    log("order-->${widget.order.toString()}");
    calculation();
  }

  void calculation() {
    if (widget.order.orderType == 1) {
      reddem = double.parse(widget.order.billingDetails.first.redeemedCoins);
      if (double.parse(widget.order.myprofitRevenue) > reddem) {
        log("${double.parse(widget.order.myprofitRevenue)}");
        finalamount = double.parse(widget.order.myprofitRevenue) - reddem;
      } else {
        finalamount = reddem - double.parse(widget.order.myprofitRevenue);
      }
    } else {
      widget.order.orderDetails.forEach((element) {
        reddem += double.parse(element.redeemCoins);
        log("$reddem");
        if (double.parse(widget.order.myprofitRevenue) > reddem) {
          log("${double.parse(widget.order.myprofitRevenue)}");
          finalamount = double.parse(widget.order.myprofitRevenue) - reddem;
        } else {
          finalamount = reddem - double.parse(widget.order.myprofitRevenue);
        }
      });
    }
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
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
                                "${widget.order.firstName}",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Text(
                                "${widget.order.dateTime}",
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
                                "+91 ${widget.order.mobile}",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: widget.order.status == 1 ? PendingTextBgColor : GreenBoxBgColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                                  child: widget.order.status == 1
                                      ? Text(
                                          "Pending",
                                          style: TextStyle(
                                              fontSize: 10, fontWeight: FontWeight.bold, color: RejectedTextColor),
                                        )
                                      : Text(
                                          "Paid",
                                          style: TextStyle(
                                              fontSize: 10, fontWeight: FontWeight.bold, color: GreenBoxTextColor),
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
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
                        widget.order.orderType == 1
                            ? DirectBillingListItem(
                                commission: widget.order.myprofitRevenue,
                                detail: widget.order.billingDetails.first,
                              )
                            : Container(
                                height: widget.order.orderDetails.length > 1 ? 160 : 80,
                                child: ListView.builder(
                                  itemCount: widget.order.orderDetails.length,
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
                                                          "${widget.order.orderDetails[index].productImage}",
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
                                                                "${widget.order.orderDetails[index].productName}",
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.black87),
                                                              ),
                                                              Text(
                                                                "\u20B9 ${widget.order.orderDetails[index].total}",
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
                                                                "${widget.order.orderDetails[index].qty} x \u20B9 ${widget.order.orderDetails[index].price}",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.grey),
                                                              ),
                                                              Text(
                                                                "Commission \u20B9${widget.order.myprofitRevenue}",
                                                                style: TextStyle(
                                                                    fontSize: 11,
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
                                        double.parse(widget.order.orderDetails[index].redeemCoins) > 0
                                            ? Positioned(
                                                top: 4,
                                                right: 25,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: RejectedTextBgColor,
                                                    borderRadius: BorderRadius.circular(8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: RejectedTextBgColor,
                                                      )
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
                                                    child: Text(
                                                      "Redeemed",
                                                      style: TextStyle(
                                                          color: RejectedTextColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
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
                                "\u20B9 ${widget.order.orderTotal}",
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 14),
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
                                "\u20B9${widget.order.myprofitRevenue}",
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
                              Text(
                                "\u20B9 $reddem",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                              )
                              /* widget.order.orderType == 1
                                  ? widget.order.orderDetails[0].redeemCoins == "0"
                                      ? Text(
                                          "\u20B9 0",
                                          style:
                                              TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                        )
                                      : Text(
                                          "\u20B9-${widget.order.orderDetails[0].redeemCoins}",
                                          style:
                                              TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                        )

                                  : widget.order.billingDetails[0].redeemedCoins == "0"
                                      ? Text(
                                          "\u20B9 0",
                                          style:
                                              TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                        )
                                      : Text(
                                          "\u20B9-${widget.order.billingDetails[0].redeemedCoins}",
                                          style:
                                              TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                        ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
                  child: double.parse(widget.order.myprofitRevenue) > reddem
                      ? Container(
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
                        )
                      : Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              // stops: [0.1, 0.5, 0.7, 0.9],
                              colors: [
                                GreenLightColor,
                                GreenDarkColor,
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
                                  "Amount Paid To Vendor",
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

class DirectBillingListItem extends StatelessWidget {
  final String commission;

  final BillingDetail detail;

  const DirectBillingListItem({Key? key, required this.detail, required this.commission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
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
                            "${detail.categoryImage}",
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
                                  "${detail.categoryName}",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                Text(
                                  "\u20B9 ${detail.amountPaid}",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ColorPrimary),
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
                                  "sadasd",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                Text(
                                  "Commission \u20B9${commission}",
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
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
          double.parse(detail.redeemedCoins) > 0
              ? Positioned(
                  top: 4,
                  right: 20,
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
                        style: TextStyle(color: RejectedTextColor, fontWeight: FontWeight.bold, fontSize: 9),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

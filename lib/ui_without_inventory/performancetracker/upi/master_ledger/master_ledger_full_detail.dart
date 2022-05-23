import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

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

  double amtPaid = 0;
  double redeemCoins = 0;
  double earnCoins = 0;
  String vendorName = "";
  double orderTotal = 0;
  double totalComission = 0;
  void getname() async {
    vendorName = await SharedPref.getStringPreference(SharedPref.VENDORNAME);
    setState(() {});
    log("=======>$vendorName");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // commonLedgerHistory = widget.commonLedgerHistory;
    // index = widget.index;
    getname();
    log("orderType-->${widget.order.orderType}");
    log("order-->${widget.order.toString()}");
    totalComission = double.parse(widget.order.billingDetails.first.commissionValue);
    amtPaid = double.parse(widget.order.orderTotal);
    orderTotal = double.parse(widget.order.billingDetails.first.total);
    redeemCoins = double.parse(widget.order.billingDetails.first.redeemCoins);

    //calculation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "master_ledger_detail_key".tr(),
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(child: dataSalesReturn(context)),
      ),
    );
  }

  dataSalesReturn(BuildContext contex) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    "${widget.order.firstName}",
                    style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                  ),
                  Text(
                    "orderId : ${widget.order.orderId}",
                    style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "+91 ${widget.order.mobile}",
                      style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                    ),
                    Text(
                      "${DateFormat("yyyy MM dd ").format(widget.order.dateTime)} - ${DateFormat.jm().format(widget.order.dateTime)}",
                      style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 10),
                  child: Text(
                    "order_summary_key".tr(),
                    style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              DirectBillingListItem(
                commission: totalComission.toStringAsFixed(2),
                detail: widget.order.billingDetails.first,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "billing_key".tr(),
                    style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                  ),
                ],
              ),
              SizedBox(
                height: widget.order.isReturn == 0 ? 8 : 0,
              ),
              widget.order.isReturn == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "totals_order_value_key".tr(),
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                        ),
                        Text(
                          "\u20B9 ${orderTotal}",
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                height: widget.order.isReturn == 0 ? 8 : 0,
              ),
              widget.order.isReturn == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "total_commission_key".tr(),
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                        ),
                        Text(
                          "\u20B9 ${totalComission}",
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                        ),
                      ],
                    )
                  : Text(""),
              SizedBox(
                height: widget.order.isReturn == 0 ? 20 : 0,
              ),
              widget.order.isReturn == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "customer_amt_paid_key".tr(),
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                        ),
                        // Row(children: [

                        amtPaid >= redeemCoins / 3
                            ? Text(
                                "\u20B9 ${amtPaid}",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                              )
                            : Text(
                                "\u20B9 $amtPaid",
                                style: GoogleFonts.openSans(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                              ),
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                height: widget.order.isReturn == 0 ? 8 : 0,
              ),
              widget.order.isReturn == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          "customer_redemption_key".tr(),
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: TextGrey),
                        ),
                        Row(children: [
                          AutoSizeText(
                            "(",
                            minFontSize: 14,
                            maxFontSize: 16,
                            style:
                                GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                          ),
                          Image.asset(
                            "assets/images/point.png",
                            scale: 4,
                          ),
                          AutoSizeText(
                            "${(redeemCoins)}) ",
                            minFontSize: 14,
                            maxFontSize: 16,
                            style:
                                GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                          ),
                          AutoSizeText(
                            "\u20B9 ${(redeemCoins / 3).toStringAsFixed(2)}",
                            minFontSize: 14,
                            maxFontSize: 16,
                            style:
                                GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                          ),
                        ])
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),

              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "net_settlement_amount_key".tr(),
                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                      ),
                      Text(
                        "(${"redemption_key".tr()} - ${"commission_key".tr()})",
                        style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 12, color: TextGrey),
                      ),
                    ],
                  ),
                  totalComission >= redeemCoins / 3
                      ? Text(
                          "\u20B9${(totalComission - redeemCoins / 3).toStringAsFixed(2)}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                        )
                      : Text(
                          "\u20B9${(redeemCoins / 3 - totalComission).toStringAsFixed(2)}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                        ),
                ],
              ),
              //  Transaction By
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      totalComission <= redeemCoins / 3
                          ? Text(
                              "To: $vendorName",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                            )
                          : Text(
                              "To: MyProfit",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                            ),
                      totalComission >= redeemCoins / 3
                          ? Text(
                              "From: $vendorName",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                            )
                          : Text(
                              "From: MyProfit",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                            ),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),
              widget.order.status == 1
                  ? Container(
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
                            "${widget.order.paymentDetails.first.bankTxnId}",
                            style:
                                GoogleFonts.openSans(fontSize: 16, color: TextBlackLight, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "To: ${widget.order.paymentDetails.first.to}",
                            style: GoogleFonts.openSans(fontSize: 16, color: TextGrey),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "From: ${widget.order.paymentDetails.first.from}",
                            style: GoogleFonts.openSans(fontSize: 16, color: TextGrey),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
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
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        "${detail.categoryImage}",
                        height: 45,
                        width: 45,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${detail.categoryName}",
                              style: GoogleFonts.openSans(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\u20B9 ${detail.total}",
                                  style: GoogleFonts.openSans(
                                      fontSize: 20, fontWeight: FontWeight.bold, color: TextBlackLight),
                                ),
                                Text(
                                  "${"commission_key".tr()} \u20B9${detail.commissionValue}",
                                  style:
                                      GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.bold, color: TextGrey),
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
          double.parse(detail.redeemCoins) > 0
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
                        "redeemed_key".tr(),
                        style: GoogleFonts.openSans(color: RejectedTextColor, fontWeight: FontWeight.bold, fontSize: 9),
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

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/utility/color.dart';

class FreeCoinDetail extends StatefulWidget {
  final OrderData freecoindetail;

  FreeCoinDetail({required this.freecoindetail});

  @override
  _freeCoinDetailstate createState() => _freeCoinDetailstate();
}

class _freeCoinDetailstate extends State<FreeCoinDetail> {
  OrderData? freeCoinDetails;
  double count = 0;
  double redeemCoins = 0;
  double orderTotal = 0;
  double amtpaid = 0;

  @override
  void initState() {
    super.initState();
    // log("widget.freecoindetail${widget.freecoindetail.orderDetails.first.productName}");
    // log("widget.freecoindetail${widget.freecoindetail.orderDetails.first.qty}");
    // log("widget.freecoindetail${widget.freecoindetail.orderDetails.first.price}");
    // log("widget.freecoindetail${widget.freecoindetail.orderDetails.first.commissionValue}");
    // log("widget.freecoindetail${widget.freecoindetail.orderDetails.first.productImage}");
    freeCoinDetails = widget.freecoindetail;
    count = freeCoinDetails!.orderType == 0
        ? double.parse(freeCoinDetails!.orderDetails.length.toString())
        : double.parse(freeCoinDetails!.billingDetails.length.toString());
    if (freeCoinDetails!.orderType == 0) {
      widget.freecoindetail.orderDetails.forEach((element) {
        orderTotal += double.parse(element.total);
        redeemCoins += double.parse(element.redeemCoins);
        amtpaid += double.parse(element.amountPaid);
      });
    } else {
      widget.freecoindetail.billingDetails.forEach((element) {
        orderTotal += double.parse(element.total);
        redeemCoins += double.parse(element.redeemCoins);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "free_coins_details_key".tr(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.only(top: 14, left: 14, right: 14),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${freeCoinDetails!.firstName}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18, color: TextBlackLight),
                        ),
                        Text(
                          "${DateFormat("dd MMM yyyy").format(DateTime.parse(freeCoinDetails!.dateTime.toString()))}" +
                              " ${DateFormat.jm().format(DateTime.parse(freeCoinDetails!.dateTime.toString()))}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 13, color: TextGrey),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "+91 ${freeCoinDetails!.mobile}",
                      style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 13, color: TextGrey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "order_summary_key".tr(),
                  style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18, color: TextBlackLight),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: count == 1 ? 80 : 240,
                child: ListView.builder(
                  primary: false,
                  itemCount: freeCoinDetails!.orderType != 0 ? 1 : freeCoinDetails!.orderDetails.length,
                  itemBuilder: ((context, index) {
                    log("  freeCoinDetails!.orderType${freeCoinDetails!.orderType}");
                    print("  freeCoinDetails!.orderType${freeCoinDetails!.orderType}");
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
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
                                color: Colors.white,
                                child: freeCoinDetails!.orderType != 0
                                    ? Image.network(
                                        "${freeCoinDetails!.billingDetails.first.categoryImage}",
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        "${freeCoinDetails!.orderDetails[index].productImage}",
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
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
                                        freeCoinDetails!.orderType == 0
                                            ? Text(
                                                "${freeCoinDetails!.orderDetails[index].productName}",
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                              )
                                            : Text(
                                                "${freeCoinDetails!.billingDetails.first.categoryName}",
                                                style: GoogleFonts.openSans(
                                                    fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                                              ),
                                        freeCoinDetails!.orderType == 0
                                            ? Text(
                                                "\u20B9${freeCoinDetails!.orderDetails[index].total}",
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                              )
                                            : Text(
                                                "\u20B9${freeCoinDetails!.billingDetails.first.total}",
                                                style: GoogleFonts.openSans(
                                                    fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                              ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            freeCoinDetails!.orderType == 0
                                                ? Text(
                                                    "${freeCoinDetails!.orderDetails[index].qty} x \u20B9 ${freeCoinDetails!.orderDetails[index].price}",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                                                  )
                                                : Text(
                                                    "",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                                                  ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            freeCoinDetails!.orderType == 0
                                                ? Text(
                                                    "${"commission_key".tr()}: ${freeCoinDetails!.orderDetails[index].commissionValue}",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 14, fontWeight: FontWeight.w600, color: TextGrey),
                                                  )
                                                : Text(
                                                    "${"commission_key".tr()}: ${freeCoinDetails!.billingDetails.first.commissionValue}",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 14, fontWeight: FontWeight.w600, color: TextGrey),
                                                  ),
                                          ],
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
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "billing_key".tr(),
                  style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "totals_order_value_key".tr(),
                    style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 14, color: TextGrey),
                  ),
                  Text(
                    "\u20B9${orderTotal.toStringAsFixed(2)}",
                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "customer_amt_paid_key".tr(),
                    style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 14, color: TextGrey),
                  ),
                  freeCoinDetails!.orderType == 0
                      ? Text(
                          "\u20B9${amtpaid}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                        )
                      : Text(
                          "\u20B9${freeCoinDetails!.billingDetails[0].amountPaid}",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
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
                    "customer_redemption_key".tr(),
                    style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 14, color: TextGrey),
                  ),
                  Row(
                    children: [
                      Text(
                        "(",
                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/point.png",
                          width: 15,
                        ),
                      ),
                      freeCoinDetails!.orderType == 0
                          ? Text(
                              "${redeemCoins.toStringAsFixed(2)}) \u20B9${(redeemCoins / 3).toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                            )
                          : Text(
                              "${freeCoinDetails!.billingDetails.first.redeemCoins}) \u20B9${(double.parse(freeCoinDetails!.billingDetails.first.redeemCoins) / 3).toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                            ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.only(top: 14, bottom: 5),
                height: 1,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "earn_coins_key".tr(),
                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18, color: TextBlackLight),
                  ),
                  Row(
                    children: [
                      Text(
                        "(",
                        style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 24, color: ColorPrimary),
                      ),
                      Image.asset(
                        "assets/images/point.png",
                        width: 20,
                      ),
                      freeCoinDetails!.orderType == 0
                          ? Text(
                              "${freeCoinDetails!.totalearningcoins})"
                              " \u20B9${(double.parse(freeCoinDetails!.totalearningcoins) / 3).toStringAsFixed(2)}",
                              style:
                                  GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 24, color: ColorPrimary),
                            )
                          : Text(
                              "${(double.parse(freeCoinDetails!.billingDetails[0].earningCoins)).toStringAsFixed(2)}) \u20B9${(double.parse(freeCoinDetails!.billingDetails[0].earningCoins) / 3).toStringAsFixed(2)}",
                              style:
                                  GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 24, color: ColorPrimary),
                            ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
// Row(
// children: [
// Image.asset(
// "assets/images/point.png",
// scale: 3,
// ),
// freeCoinDetails!.orderType == 0
// ? Text(
// " ${freeCoinDetails!.orderDetails[0].earningCoins} (\u20B9${(double.parse(freeCoinDetails!.orderDetails[0].earningCoins) / 3).toStringAsFixed(2)})",
// style:
// GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
// )
// : Text(
// " ${freeCoinDetails!.billingDetails[0].earningCoins} (\u20B9${(double.parse(freeCoinDetails!.billingDetails[0].earningCoins) / 3).toStringAsFixed(2)})",
// style:
// GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
// ),
// ],
// ),

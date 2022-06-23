import 'dart:async';
import 'package:vendor/widget/progress_indecator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/response/redeem_coin_response.dart';
import 'package:vendor/utility/color.dart';

class RedeemCoinDetails extends StatefulWidget {
  final CoinDetail detail;

  RedeemCoinDetails({Key? key, required this.detail}) : super(key: key);

  @override
  State<RedeemCoinDetails> createState() => _RedeemCoinDetailsState();
}

class _RedeemCoinDetailsState extends State<RedeemCoinDetails> {
  CoinDetail? details;
  List<CommonDetails> commonDetails = [];
  StreamController<List<CommonDetails>> detailsController = StreamController();
  double totalAmt = 0;
  double totalRedeemCoins = 0;
  double totalEarnCoin = 0;
  double totalPayAmt = 0;

  @override
  void initState() {
    super.initState();
    details = widget.detail;
    getAllItems(details!);
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
            "redeem_coin_details_key".tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${details!.firstName}",
                              style: GoogleFonts.openSans(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${details!.mobile}",
                              style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                            ),
                            Text(
                              "${DateFormat("dd MMM yyyy").format(DateTime.parse(details!.dateTime))}" +
                                  " ${DateFormat.jm().format(DateTime.parse(details!.dateTime))}",
                              style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: TextGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "order_summary_key".tr(),
                            style:
                                GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: commonDetails.length >= 2 ? 160 : 75,
                          child: StreamBuilder<List<CommonDetails>>(
                              stream: detailsController.stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularLoader(),
                                  );
                                }
                                if (snapshot.hasData) {
                                  var product = snapshot.data!;
                                  return ListView.builder(
                                    primary: false,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: ((context, index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 70,
                                            margin: EdgeInsets.only(bottom: 20),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Container(
                                                      child: product[index].image.isEmpty
                                                          ? Image.asset("assets/images/placeholder.webp",
                                                              width: 55, height: 55, fit: BoxFit.contain)
                                                          : CachedNetworkImage(
                                                              imageUrl: product[index].image,
                                                              progressIndicatorBuilder:
                                                                  (context, url, downloadProgress) => Center(
                                                                        child: CircularProgressIndicator(
                                                                            value: downloadProgress.progress),
                                                                      ),
                                                              errorWidget: (context, url, error) =>
                                                                  Image.asset("assets/images/placeholder.webp"),
                                                              width: 55,
                                                              height: 55,
                                                              fit: BoxFit.contain),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  child: Flexible(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${product[index].categoryName.isEmpty ? product[index].productName : product[index].categoryName}",
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: TextBlackLight),
                                                            ),
                                                            widget.detail.billingType == 0
                                                                ? Text(
                                                                    "\u20B9 ${product[index].total}",
                                                                    style: GoogleFonts.openSans(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: TextBlackLight),
                                                                  )
                                                                : Text(
                                                                    "\u20B9 ${widget.detail.orderTotal}",
                                                                    style: GoogleFonts.openSans(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: TextBlackLight),
                                                                  )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            widget.detail.billingType == 0
                                                                ? Text(
                                                                    "${product[index].qty} x \u20B9 ${product[index].price}",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: TextBlackLight),
                                                                  )
                                                                : Text(""),
                                                            Text(
                                                              "${"commission_key".tr()}: \u20B9${product[index].commission}",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: TextBlackLight),
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
                                        ],
                                      );
                                    }),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "billing_key".tr(),
                            style:
                                GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: TextBlackLight),
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
                            widget.detail.billingType == 0
                                ? Text(
                                    "\u20B9 ${totalAmt.toStringAsFixed(2)}",
                                    style: GoogleFonts.openSans(
                                        fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
                                  )
                                : Text(
                                    "\u20B9 ${widget.detail.orderTotal}",
                                    style: GoogleFonts.openSans(
                                        fontSize: 16, fontWeight: FontWeight.bold, color: TextBlackLight),
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
                            widget.detail.billingType == 0
                                ? Text(
                                    "\u20B9 ${totalPayAmt.toStringAsFixed(2)}",
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                                  )
                                : Text(
                                    "\u20B9 ${widget.detail.billingDetails.first.amountPaid}",
                                    style: GoogleFonts.openSans(
                                        fontSize: 15, fontWeight: FontWeight.bold, color: TextBlackLight),
                                  )
                          ],
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
                              "redemption_key".tr(),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 18, color: TextBlackLight),
                            ),
                            Row(
                              children: [
                                Text(
                                  "(",
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w600, fontSize: 24, color: ColorPrimary),
                                ),
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 20,
                                ),
                                Text(
                                  "${(totalRedeemCoins).toStringAsFixed(0)}) \u20B9${(totalRedeemCoins / 3).toStringAsFixed(0)}",
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w600, fontSize: 24, color: ColorPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                  //   child: Container(
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         begin: Alignment.topRight,
                  //         end: Alignment.bottomLeft,
                  //         // stops: [0.1, 0.5, 0.7, 0.9],
                  //         colors: [
                  //           RedDarkColor,
                  //           RedLightColor,
                  //         ],
                  //       ),
                  //       borderRadius: BorderRadius.circular(8),
                  //       boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)],
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 14, right: 14),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             "redeemed_coins_key".tr(),
                  //             style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  //           ),
                  //           Row(
                  //             children: [
                  //               Image.asset(
                  //                 "assets/images/point.png",
                  //                 height: 14,
                  //                 width: 14,
                  //               ),
                  //               Text(
                  //                 " ${totalRedeemCoins.toStringAsFixed(2)} (\u20B9 ${(totalRedeemCoins / 3).toStringAsFixed(2)})",
                  //                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getAllItems(CoinDetail details) {
    for (var product in details.orderDetails) {
      CommonDetails productDetails = CommonDetails(
        commission: product.commission,
        productId: product.productId,
        productName: product.productName,
        image: product.productImage,
        qty: product.qty,
        price: product.price,
        total: product.total,
        amountPaid: product.amountPaid,
        redeemCoins: product.redeemCoins,
        earningCoins: product.earningCoins,
        categoryId: "",
        categoryName: "",
      );
      commonDetails.add(productDetails);
    }

    for (var product in details.billingDetails) {
      CommonDetails productDetails = CommonDetails(
        commission: product.commission,
        productId: "",
        productName: "",
        image: product.categoryImage,
        qty: "",
        price: "",
        total: "",
        amountPaid: product.amountPaid,
        redeemCoins: product.redeemCoins,
        earningCoins: product.earningCoins,
        categoryId: product.categoryId,
        categoryName: product.categoryName,
      );
      commonDetails.add(productDetails);
    }

    for (var count in commonDetails) {
      totalAmt += double.parse(count.total.isEmpty ? "0" : count.total);
      totalRedeemCoins += double.parse(count.redeemCoins.isEmpty ? "0" : count.redeemCoins);
      totalEarnCoin += double.parse(count.earningCoins.isEmpty ? "0" : count.earningCoins);
    }
    if (totalAmt >= totalRedeemCoins / 3) {
      totalPayAmt = totalAmt - totalRedeemCoins / 3;
    } else {
      if (totalAmt == 0.00) {
        totalAmt = totalAmt;
      } else {
        totalPayAmt = (totalRedeemCoins / 3) - totalAmt;
      }
    }
    detailsController.add(commonDetails);
  }
}

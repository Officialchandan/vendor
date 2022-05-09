import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/widget/sales_return_details_bottom_sheet.dart';

class SalesReturnDetails extends StatefulWidget {
  final BillingDetails billingDetails;
  const SalesReturnDetails({required this.billingDetails, Key? key}) : super(key: key);

  @override
  _SalesReturnDetailsState createState() => _SalesReturnDetailsState();
}

class _SalesReturnDetailsState extends State<SalesReturnDetails> {
  List<CommonSaleReturnProductDetails> productDetails = [];
  BillingDetails? details;


  double collectionAmt = 0;
  double collectionFinalAmt = 0;double customerReturnAmt = 0;
  double amtPaid = 0;
  double coinBalance= 0;
  double coinBalanceRs = 0;
  double redeemCoins = 0;
  double earnCoins = 0;
  double redeemCoinsRs = 0;
  double earnCoinsRs = 0;

  @override
  void initState() {
    super.initState();
    this.details = widget.billingDetails;

    for (var products in details!.orderDetails) {
      CommonSaleReturnProductDetails normalBillingProducts = CommonSaleReturnProductDetails(
        orderId: products.orderId,
        mobile: products.mobile,
        productId: products.productId,
        productName: products.productName,
        productImage: products.productImage,
        qty: products.qty,
        price: products.price,
        total: products.total,
        amountPaid: products.amountPaid,
        redeemCoins: products.redeemCoins,
        earningCoins: products.earningCoins,
        myProfitRevenue: products.myProfitRevenue,
        billingId: "",
        categoryId: "",
        categoryImage: "",
        categoryName: "",
      );
      productDetails.add(normalBillingProducts);
    }

    for (var products in details!.billingDetails) {
      CommonSaleReturnProductDetails normalBillingProducts = CommonSaleReturnProductDetails(
        orderId: "",
        mobile: products.mobile,
        productId: "",
        productName: "",
        productImage: "",
        qty: "1",
        price: "",
        total: products.total,
        amountPaid: products.amountPaid,
        redeemCoins: products.redeemCoins,
        earningCoins: products.earningCoins,
        myProfitRevenue: products.myProfitRevenue,
        billingId: products.billingId,
        categoryId: products.categoryId,
        categoryImage: products.categoryImage,
        categoryName: products.categoryName,
      );
      productDetails.add(normalBillingProducts);
    }
    calculation();
  }

 void  calculation() {
    // Amount Paid
    productDetails.forEach((element) {
      amtPaid += double.parse(element.amountPaid);
    });

    // Redeem Coin
    productDetails.forEach((element) {
      redeemCoins += double.parse(element.redeemCoins);
      redeemCoinsRs = redeemCoins/3;
    });

    // Earn Coins
    productDetails.forEach((element) {
      earnCoins += double.parse(element.earningCoins);
      earnCoinsRs = earnCoins/3;
    });
    // Coin Balance 
    coinBalance = double.parse(details!.customerCoinBalance);
    coinBalanceRs = double.parse(details!.customerCoinBalance)/3;

    // collection Amount
    if(redeemCoinsRs>= earnCoinsRs){
      collectionAmt = 0;
    } else {
      collectionAmt =  earnCoinsRs - redeemCoinsRs;
      if(coinBalanceRs >= earnCoinsRs){
        collectionAmt = 0;
      } else {
        collectionAmt = earnCoinsRs - coinBalanceRs;
        collectionFinalAmt = collectionAmt;
        customerReturnAmt = amtPaid - collectionAmt;
      }
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
            "return_ledger_details_key".tr(),
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
                          children: [
                            Text(
                              "${details!.vendorName}",
                              style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold,
                                  color: TextBlackLight),
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
                              "+91 ${details!.mobile}",
                              style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: TextGrey),
                            ),
                            Text(
                              "${DateFormat("dd MMM yyyy").format(DateTime.parse(details!.dateTime))} -"
                                  " ${DateFormat.jm().format(DateTime.parse(details!.dateTime))}",
                              style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: TextGrey),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "order_summary_key".tr(),
                            style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold,
                                color: TextBlackLight),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: productDetails.length >= 2 ? 160 : 75,
                          child: ListView.builder(
                            primary: false,
                            itemCount: productDetails.length,
                            itemBuilder: ((context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    height: 70,
                                    margin: const EdgeInsets.only(left: 20),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8)
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                                imageUrl: productDetails[index].categoryImage.isEmpty
                                                    ? productDetails[index].productImage
                                                    : productDetails[index].categoryImage,
                                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                    Center(
                                                      child: CircularProgressIndicator(
                                                          value: downloadProgress.progress),
                                                    ),
                                                errorWidget: (context, url, error) => Image.asset(
                                                      "assets/images/placeholder.webp",
                                                      fit: BoxFit.contain,
                                                      width: 55,
                                                      height: 55,
                                                  color: Colors.red,
                                                    ),
                                                width: 55,
                                                height: 55,
                                                fit: BoxFit.contain),
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
                                                      productDetails[index].categoryName.isEmpty
                                                          ? productDetails[index].productName
                                                          : productDetails[index].categoryName,
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: TextBlackLight),
                                                    ),
                                                    Text(
                                                      "\u20B9 ${productDetails[index].total}",
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: TextBlackLight),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${productDetails[index].qty} x \u20B9 ${details!.billingType == 1 ? productDetails[index].total : productDetails[index].price}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      "${"commission_key".tr()}: 40",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
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
                                  Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            height: 70,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              color: ColorPrimary,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)
                                              ),
                                            ),
                                            child: RotatedBox(
                                              quarterTurns: 3,
                                              child: Center(
                                                child: Text(
                                                  "return_key".tr(),
                                                  style: GoogleFonts.openSans(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12),
                                                ),
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
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "return_summary_key".tr(),
                            style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold,
                                color: TextBlackLight),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Amount Paid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "customer_amt_paid_key".tr(),
                              style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 14, color: TextGrey),
                            ),
                            Text(
                              "\u20B9$amtPaid",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Redeem Coins
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
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  "${(redeemCoins).toStringAsFixed(2)}) \u20B9${(redeemCoinsRs).toStringAsFixed(2)}",
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Earn Coins
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "coin_earned_by_customer_key".tr(),
                              style: GoogleFonts.openSans(fontWeight:
                              FontWeight.w600, fontSize: 14, color: TextGrey),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "(",
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                                ),
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  "${(earnCoins).toStringAsFixed(2)}) \u20B9${(earnCoinsRs).toStringAsFixed(2)}",
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //Coin Balance
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "current_coin_balance_key".tr(),
                              style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 14, color: TextGrey),
                            ),
                            Row(
                              children: [
                                Text(
                                  "(",
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                                ),
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  "${(coinBalance).toStringAsFixed(2)}) \u20B9${(coinBalanceRs).toStringAsFixed(2)}",
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Customer Return Coins
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "amt_return_to_customer_key".tr(),
                              style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 14, color: TextGrey),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "\u20B9${(customerReturnAmt).toStringAsFixed(2)}",
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // collection Amt
                        Container(
                          margin: const EdgeInsets.only(top: 14),
                          height: 1,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "collection_amt_key".tr(),
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                                ),
                                Text(
                                  "(${"amount_paid_key".tr()} - ${"collection_amt_key".tr()})",
                                  style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 12, color: TextGrey),
                                ),
                              ],
                            ),
                            Text(
                              "\u20B9${(collectionAmt).toStringAsFixed(2)}",
                              style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                            ),
                          ],
                        ),
                      //  Transaction By
                       collectionAmt >0?
                        Column(
                           children: [
                             SizedBox(
                               height: 15,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       "To: MyProfit",
                                       style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                                     ),
                                     Text(
                                       "From: George Walker",
                                       style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextGrey),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ],
                        ):Container()
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  String amtPaidStatus = "";
  String payAmt = "0";
  double amtPaid = 0;
  double redeemCoins = 0;
  double earnCoins = 0;
  double netBalance = 0;
  double amtReturnToCustomer = 0;
  @override
  void initState() {
    super.initState();
    this.details = widget.billingDetails;

    if (double.parse(details!.amountPaidToMyProfit) >= double.parse(details!.amountPaidToVendor)) {
      amtPaidStatus = "1";
      // red
      payAmt =
          (double.parse(details!.amountPaidToMyProfit) - double.parse(details!.amountPaidToVendor)).toStringAsFixed(2);
      payAmt = (double.parse(payAmt) / 3).toStringAsFixed(2);
    }
    if (double.parse(details!.amountPaidToMyProfit) < double.parse(details!.amountPaidToVendor)) {
      amtPaidStatus = "0";
      // green
      payAmt = ((double.parse(details!.amountPaidToVendor) - double.parse(details!.amountPaidToMyProfit))
          .toStringAsFixed(2));
      payAmt = (double.parse(payAmt) / 3).toStringAsFixed(2);
    }

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

  calculation() {
    // Amount Paid
    productDetails.forEach((element) {
      amtPaid += double.parse(element.amountPaid);
    });

    // Redeem Coin
    productDetails.forEach((element) {
      redeemCoins += double.parse(element.redeemCoins);
    });

    // Earn Coins
    productDetails.forEach((element) {
      earnCoins += double.parse(element.earningCoins);
    });

    // Net Balance
    if (redeemCoins >= earnCoins) {
      netBalance = 0;
    } else if (earnCoins > redeemCoins && earnCoins != 0) {
      netBalance = earnCoins - redeemCoins;
      log("message >>> $netBalance");
      log("message >>> ${details!.customerCoinBalance}");
      if (double.parse(details!.customerCoinBalance) != 0) {
        if (double.parse(details!.customerCoinBalance) >= netBalance) {
          log("message2 >>> $netBalance");
          netBalance = 0;
        } else {
          log("message3 >>> $netBalance");
          netBalance = netBalance - double.parse(details!.customerCoinBalance);
          log("message3 >>> $netBalance");
        }
      } else {
        netBalance = double.parse(details!.returnAmountCustomer) - netBalance / 3;
        log("message4 >>> $netBalance");
      }
    } else {
      if (double.parse(details!.customerCoinBalance) != 0) {
        if (double.parse(details!.customerCoinBalance) >= earnCoins) {
          netBalance = 0;
        } else {
          netBalance = earnCoins - double.parse(details!.customerCoinBalance);
        }
      } else {
        netBalance = double.parse(details!.returnAmountCustomer) - earnCoins / 3;
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
            "sales_return_details_key".tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SalesReturnDetailsSheet(
                        customerId: details!.customerId,
                      );
                    });
              },
              icon: Icon(Icons.info),
            ),
          ],
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
                            children: [
                              Text(
                                "${details!.vendorName}",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                "${details!.mobile}",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: amtPaidStatus == "0" ? ApproveTextBgColor : RejectedTextBgColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                                  child: Text(
                                    "  ${"pay_key".tr()}: \u20B9 $payAmt  ",
                                    style: TextStyle(
                                        color: amtPaidStatus == "0" ? ApproveTextColor : RejectedTextColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
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
                              "all_items_key".tr(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: productDetails.length >= 2 ? 160 : 80,
                          child: ListView.builder(
                            itemCount: productDetails.length,
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
                                                          fit: BoxFit.cover,
                                                          width: 55,
                                                          height: 55,
                                                        ),
                                                    width: 55,
                                                    height: 55,
                                                    fit: BoxFit.cover),
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
                                                          productDetails[index].categoryName.isEmpty
                                                              ? productDetails[index].productName
                                                              : productDetails[index].categoryName,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black87),
                                                        ),
                                                        Text(
                                                          "\u20B9 ${productDetails[index].total}",
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
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${productDetails[index].qty} x \u20B9 ${details!.billingType == 1 ? productDetails[index].total : productDetails[index].price}",
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
                                    ),
                                  ),
                                  redeemCoins == 0
                                      ? SizedBox()
                                      : Positioned(
                                          top: 4,
                                          right: 25,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: RejectedTextBgColor,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10)
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5, right: 5),
                                              child: Text(
                                                "redeemed_key".tr(),
                                                style: TextStyle(
                                                    color: RejectedTextColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
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
                                "amt_paid_by_customer_key".tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Text(
                                "\u20B9 $amtPaid",
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
                                "sales_return_history_key".tr(),
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Text(
                                "${DateFormat("dd MMM yyyy").format(DateTime.parse(details!.dateTime))}  " +
                                    "${DateFormat.jm().format(DateTime.parse(details!.dateTime)).toLowerCase()}",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
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
                                "earn_coins_key".tr(),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/point.png",
                                    width: 14,
                                    height: 14,
                                  ),
                                  Text(
                                    "$earnCoins (\u20B9 ${(earnCoins / 3).toStringAsFixed(2)})",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                ],
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
                                "redeem_coins_key".tr(),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/point.png",
                                    width: 14,
                                    height: 14,
                                  ),
                                  Text(
                                    "${(redeemCoins).toStringAsFixed(2)} (\u20B9 ${(redeemCoins / 3).toStringAsFixed(2)})",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                ],
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
                                "customer_coin_balance_key".tr(),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/point.png",
                                    width: 14,
                                    height: 14,
                                  ),
                                  Text(
                                    "${details!.customerCoinBalance} (\u20B9 ${(double.parse(details!.customerCoinBalance) / 3).toStringAsFixed(2)})",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                ],
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
                                "net_balance_key".tr(),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/point.png",
                                    width: 14,
                                    height: 14,
                                  ),
                                  Text(
                                    "${(netBalance).toStringAsFixed(2)}  (\u20B9${(netBalance / 3).toStringAsFixed(2)})",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                ],
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
                                "amt_return_to_customer_key".tr(),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/point.png",
                                    width: 14,
                                    height: 14,
                                  ),
                                  netBalance == 0
                                      ? Text(
                                          "\u20B9 $amtPaid",
                                          style: TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                        )
                                      : Text(
                                          "\u20B9 ${(amtPaid - netBalance).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${"sum_key".tr()} (\u20B9 ${(amtPaid).toStringAsFixed(2)}  - \u20B9 ${(netBalance).toStringAsFixed(2)} = \u20B9 ${(amtPaid - netBalance).toStringAsFixed(2)})",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
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
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          PurpleDarkColor,
                          PurpleLightColor,
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
                            amtPaidStatus == "1" ? "amt_paid_to_my_profit_key".tr() : "amt_paid_to_vendor_key".tr(),
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            "\u20B9 ${(payAmt)}",
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

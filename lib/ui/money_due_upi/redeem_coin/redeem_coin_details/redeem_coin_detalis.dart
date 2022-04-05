import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 20),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 4,
                            blurRadius: 10)
                      ],
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
                                "${details!.firstName}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              Text(
                                "${DateFormat("dd MMM yyyy").format(DateTime.parse(details!.dateTime))}" +
                                    " ${DateFormat.jm().format(DateTime.parse(details!.dateTime)).toLowerCase()}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
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
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 4,
                            blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14, top: 10),
                            child: Text(
                              "all_items_key".tr(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: commonDetails.length >= 2 ? 160 : 80,
                          child: StreamBuilder<List<CommonDetails>>(
                              stream: detailsController.stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasData) {
                                  var product = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: ((context, index) {
                                      return Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Container(
                                                          child: product[index]
                                                                  .image
                                                                  .isEmpty
                                                              ? Image.asset(
                                                                  "assets/images/placeholder.webp",
                                                                  width: 45,
                                                                  height: 45,
                                                                  fit: BoxFit
                                                                      .cover)
                                                              : CachedNetworkImage(
                                                                  imageUrl: product[
                                                                          index]
                                                                      .image,
                                                                  progressIndicatorBuilder:
                                                                      (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          Center(
                                                                            child:
                                                                                CircularProgressIndicator(value: downloadProgress.progress),
                                                                          ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image.asset(
                                                                          "assets/images/placeholder.webp"),
                                                                  width: 45,
                                                                  height: 45,
                                                                  fit: BoxFit
                                                                      .cover),
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
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${product[index].categoryName.isEmpty ? product[index].productName : product[index].categoryName}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black87),
                                                                ),
                                                                Text(
                                                                  "\u20B9 ${product[index].total}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          ColorPrimary),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${product[index].qty} x \u20B9 ${product[index].price} ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .grey),
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
                                        ],
                                      );
                                    }),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 14, bottom: 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "total_amount_key".tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\u20B9 ${totalAmt.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "redeem_coins_key".tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/point.png",
                                        width: 14,
                                        height: 14,
                                      ),
                                      Text(
                                        " ${totalRedeemCoins.toStringAsFixed(2)} (\u20B9 ${(totalRedeemCoins / 3).toStringAsFixed(2)})",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "earn_coins_key".tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/point.png",
                                        width: 14,
                                        height: 14,
                                      ),
                                      Text(
                                        " ${totalEarnCoin.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "pay_amt_key".tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    "\u20B9 ${totalPayAmt.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: ColorPrimary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 20),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        // stops: [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          RedDarkColor,
                          RedLightColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 4,
                            blurRadius: 10)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "redeemed_coins_key".tr(),
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/point.png",
                                height: 14,
                                width: 14,
                              ),
                              Text(
                                " ${totalRedeemCoins.toStringAsFixed(2)} (\u20B9 ${(totalRedeemCoins / 3).toStringAsFixed(2)})",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
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

  getAllItems(CoinDetail details) {
    for (var product in details.orderDetails) {
      CommonDetails productDetails = CommonDetails(
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
      totalRedeemCoins +=
          double.parse(count.redeemCoins.isEmpty ? "0" : count.redeemCoins);
      totalEarnCoin +=
          double.parse(count.earningCoins.isEmpty ? "0" : count.earningCoins);
    }

    totalPayAmt = totalAmt - totalRedeemCoins / 3;
    detailsController.add(commonDetails);
  }
}

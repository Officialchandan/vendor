import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';

class SaleReturnProductDetails extends StatefulWidget {
  SaleReturnProductDetails({Key? key}) : super(key: key);

  @override
  State<SaleReturnProductDetails> createState() =>
      _SaleReturnProductDetailsState();
}

class _SaleReturnProductDetailsState extends State<SaleReturnProductDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "sale_return_key".tr(),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        // stops: [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          Color.fromARGB(255, 199, 0, 0),
                          Color.fromARGB(255, 243, 53, 39),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          "Customer Coin Balance",
                          maxLines: 1,
                          maxFontSize: 16,
                          minFontSize: 12,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/point.png",
                                scale: 2.5,
                              ),
                              Text(
                                " 46",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Colors.black12)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Return Calculation",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount Paid",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            Text(
                              " \u20B9 4550",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Earn Coins",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  " 100(\u20B9 33.33)",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Customer Coin Balance",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  " 46(\u20B915.33)",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Adjusted Balance",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  " (\u20B918)",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Amount To Be Returned To Customer",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [-1, 0.4],
                      colors: [
                        Color.fromARGB(179, 255, 255, 255),
                        ColorPrimary,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "\u20b9 4432",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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

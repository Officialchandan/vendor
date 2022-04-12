import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/sale_return_resonse.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class SaleReturnProductDetails extends StatefulWidget {
  final SaleReturnData saleReturnData;
  SaleReturnProductDetails({Key? key, required this.saleReturnData}) : super(key: key);

  @override
  State<SaleReturnProductDetails> createState() => _SaleReturnProductDetailsState();
}

class _SaleReturnProductDetailsState extends State<SaleReturnProductDetails> {
  TextEditingController _textFieldController = TextEditingController();
  String? coinBalance = "0";
  String? amountPaid = "0";
  String? earingCoins = "0";
  String? adjustedBalance = "0";
  String? returnAmount = "0";
  String? redeemCoins = "0";
  @override
  void initState() {
    this.coinBalance = widget.saleReturnData.walletBalance;
    this.amountPaid = widget.saleReturnData.amountPaid;
    this.earingCoins = widget.saleReturnData.earnCoins;
    this.redeemCoins = widget.saleReturnData.redeemCoins;
    if (double.parse(widget.saleReturnData.walletBalance) >= double.parse(widget.saleReturnData.earnCoins)) {
      this.adjustedBalance =
          (double.parse(widget.saleReturnData.walletBalance) - double.parse(widget.saleReturnData.earnCoins))
              .toStringAsFixed(2);
    } else {
      this.adjustedBalance =
          (double.parse(widget.saleReturnData.earnCoins) - (double.parse(widget.saleReturnData.walletBalance)))
              .toStringAsFixed(2);
    }

    if ((double.parse(adjustedBalance!) / 3 >= double.parse(widget.saleReturnData.amountPaid))) {
      returnAmount = amountPaid;
    } else {
      this.returnAmount =
          (double.parse(widget.saleReturnData.amountPaid) - double.parse(adjustedBalance!) / 3).toStringAsFixed(2);
    }

    super.initState();
  }

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
                          RedDarkColor,
                          RedLightColor,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          "customer_coin_balance_key".tr(),
                          maxLines: 1,
                          maxFontSize: 16,
                          minFontSize: 12,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                                " $coinBalance",
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
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
                      boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 5, color: Colors.black12)]),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "return_calculation_key".tr(),
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "amt_paid_key".tr(),
                              style: TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            Text(
                              "\u20B9$amountPaid",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
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
                              "earn_coins_key".tr(),
                              style: TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  (double.parse(earingCoins!)).toStringAsFixed(2) +
                                      " (\u20B9${(double.parse(earingCoins!) / 3).toStringAsFixed(2)})",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
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
                              "redeem_coins_key".tr(),
                              style: TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  (double.parse(redeemCoins!)).toStringAsFixed(2) +
                                      " (\u20B9${(double.parse(redeemCoins!) / 3).toStringAsFixed(2)})",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
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
                              "customer_coin_balance_key".tr(),
                              style: TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  " $coinBalance (\u20B9${(double.parse(coinBalance!) / 3).toStringAsFixed(2)})",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
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
                              "adj_balance_key".tr(),
                              style: TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/point.png",
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  " $adjustedBalance (\u20B9${(double.parse(adjustedBalance!) / 3).toStringAsFixed(2)})",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "amt_return_to_customer_key".tr(),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
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
                      colors: [PurpleLightColor, PurpleDarkColor],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "\u20b9${(double.parse(returnAmount!)).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            displayDialog(
              context,
            );
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.height,
            color: ColorPrimary,
            child: Center(
              child: Text(
                widget.saleReturnData.productId.isEmpty ? "cancel_key".tr() : "done_key".tr(),
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: RichText(
                text: TextSpan(
                  text: "otp_verification_key".tr() + "\n",
                  style: GoogleFonts.openSans(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "please_verify_your_otp_on_key".tr() + "${widget.saleReturnData.mobile}",
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        color: ColorTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              content: TextFormField(
                controller: _textFieldController,
                cursorColor: ColorPrimary,
                maxLength: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,

                  // fillColor: Colors.black,
                  hintText: "enter_otp_key".tr(),
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              actions: <Widget>[
                Center(
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.60,
                    height: 50,
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: ColorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if (_textFieldController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "please_enter_password_key".tr(), backgroundColor: ColorPrimary);
                      } else {
                        // input["otp"] = _textFieldController.text.trim();
                        // saleReturnBloc.add(VerifyOtpEvent(input: input));
                        verifyOTP(widget.saleReturnData);
                      }
                      // loginApiCall(
                      //     mobileController.text, _textFieldController.text);
                    },
                    child: new Text(
                      "verify_key".tr(),
                      style: GoogleFonts.openSans(
                          fontSize: 17, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.95,
                  color: Colors.transparent,
                )
              ],
            ),
          );
        });
  }

  verifyOTP(SaleReturnData saleReturnData) async {
    if (_textFieldController.text.length == 6) {
      Map<String, dynamic> input = HashMap();
      input["mobile"] = saleReturnData.mobile;
      input["otp"] = _textFieldController.text;
      input["vendor_id"] = saleReturnData.vendorId;
      input["order_id"] = saleReturnData.orderId;
      input["product_id"] = saleReturnData.productId;
      input["qty"] = saleReturnData.qty;
      input["reason"] = saleReturnData.reason;
      if (await Network.isConnected()) {
        CommonResponse response = await apiProvider.saleReturnOtpApi(input);

        if (response.success) {
          Navigator.of(context).pop(); //? For alert box
          successDialog(context, saleReturnData);

          // Navigator.of(context).pop(saleReturnData.orderId); //? For screen
          Utility.showToast(response.message);
        } else {
          Utility.showToast(response.message);
        }
      } else {
        Utility.showToast(Constant.INTERNET_ALERT_MSG);
      }
    } else {
      Utility.showToast("please_enter_6_digit_valid_otp_key".tr());
    }
  }

  successDialog(BuildContext context, SaleReturnData returnData) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            titlePadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Container(
                  height: 60,
                  width: 60,
                  child: Image.asset(
                    "assets/images/3x/tick.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            content: Container(
              height: 50,
              child: Center(
                child: Text(
                  "product_return_successfully".tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            actions: <Widget>[
              Center(
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.40,
                  height: 45,
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: ColorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    Navigator.of(context).pop(); //? For alert box
                    Navigator.of(context).pop(returnData.orderId); //? For screen
                  },
                  child: new Text(
                    "done_key".tr(),
                    style: GoogleFonts.openSans(
                        fontSize: 17, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        });
  }
}

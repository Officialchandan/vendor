import 'dart:collection';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/sale_return_resonse.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/sales_return_details_bottom_sheet.dart';

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
  String? earningCoins = "0";
  String? returnAmount = "0";
  String? redeemCoins = "0";
  String? coinBalanceRs = "0";
  String? earningCoinsRs = "0";
  String? returnAmountRs = "0";
  String? redeemCoinsRs = "0";
  String? collectionAmt = "0";

  @override
  void initState() {
    this.amountPaid = widget.saleReturnData.amountPaid;
    this.coinBalance = (double.parse(widget.saleReturnData.walletBalance)).toStringAsFixed(2);
    this.earningCoins = (double.parse(widget.saleReturnData.earnCoins)).toStringAsFixed(2);
    this.redeemCoins = (double.parse(widget.saleReturnData.redeemCoins)).toStringAsFixed(2);
    //Calculation in Rupees
    this.earningCoinsRs = (double.parse(widget.saleReturnData.earnCoins) / 3).toStringAsFixed(2);
    this.coinBalanceRs = (double.parse(widget.saleReturnData.walletBalance) / 3).toStringAsFixed(2);
    this.redeemCoinsRs = (double.parse(widget.saleReturnData.redeemCoins) / 3).toStringAsFixed(2);
    // Calculation for collection amt & return amt
    if (double.parse(coinBalanceRs!) != 0) {
      if (double.parse(coinBalanceRs!) >= double.parse(earningCoinsRs!)) {
        collectionAmt = (double.parse(coinBalanceRs!) - double.parse(earningCoinsRs!)).toStringAsFixed(2);
      } else {
        collectionAmt = "0";
      }
    }

    if (double.parse(redeemCoinsRs!) != 0) {
      if (double.parse(redeemCoinsRs!) >= double.parse(collectionAmt!)) {
        collectionAmt = (double.parse(redeemCoinsRs!) - double.parse(collectionAmt!)).toStringAsFixed(2);
      } else {
        collectionAmt = (double.parse(collectionAmt!) - double.parse(redeemCoinsRs!)).toStringAsFixed(2);
      }
    }

    if (double.parse(collectionAmt!) == 0) {
      returnAmount = (double.parse(amountPaid!) - double.parse(collectionAmt!)).toStringAsFixed(0);
    } else {
      returnAmount = amountPaid;
      collectionAmt = "0";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "sales_return_key".tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SalesReturnDetailsSheet(
                        customerId: widget.saleReturnData.customerId.toString(),
                      );
                    });
              },
              icon: Icon(Icons.info),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                double.parse(coinBalance!) < double.parse(earningCoins!)
                    ? Column(
                        children: [
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                // stops: [0.1, 0.5, 0.7, 0.9],
                                colors: [
                                  RedLightColor,
                                  RedDarkColor,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.warning, color: Colors.white, size: 18),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "insufficient_coin_balance_warning_key".tr(),
                                    maxLines: 1,
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  children: [
                    Text(
                      "return_summary_key".tr(),
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 20, color: TextBlackLight),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
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
                      "\u20B9$amountPaid",
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
                          "$redeemCoins) \u20B9$redeemCoinsRs",
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
                      style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 14, color: TextGrey),
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
                          "$earningCoins) \u20B9$earningCoinsRs",
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
                          "$coinBalance) \u20B9$coinBalanceRs",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                double.parse(coinBalance!) < double.parse(earningCoins!)
                    ? Column(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.warning, color: Colors.red, size: 18),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "insufficient_coin_balance_warning_key".tr(),
                                  maxLines: 1,
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "collection_amt_in_cash_key".tr(),
                      style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 14, color: TextGrey),
                    ),
                    Text(
                      "\u20B9$collectionAmt",
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15, color: TextBlackLight),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  height: 1,
                  color: TextBlackLight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "net_return_amt_key".tr(),
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16, color: TextBlackLight),
                        ),
                        Text(
                          "(${"amount_paid_key".tr()} - ${"collection_amt_key".tr()})",
                          style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 12, color: TextGrey),
                        ),
                      ],
                    ),
                    Text(
                      "\u20B9$returnAmount",
                      style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 28, color: ColorPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            _textFieldController.clear();
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
                "proceed_key".tr(),
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
                        Utility.showToast(msg: "please_enter_password_key".tr());
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
          Utility.showToast(msg: response.message);
        } else {
          Utility.showToast(msg: response.message);
        }
      } else {
        Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
      }
    } else {
      Utility.showToast(msg: "please_enter_6_digit_valid_otp_key".tr());
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
// Previous Changes till 28 April
// void initState() {
//   this.coinBalance = widget.saleReturnData.walletBalance;
//   this.amountPaid = widget.saleReturnData.amountPaid;
//   this.earingCoins = widget.saleReturnData.earnCoins;
//   this.redeemCoins = widget.saleReturnData.redeemCoins;
//   if (double.parse(widget.saleReturnData.walletBalance) >= double.parse(widget.saleReturnData.earnCoins)) {
//     this.adjustedBalance =
//         (double.parse(widget.saleReturnData.walletBalance) - double.parse(widget.saleReturnData.earnCoins))
//             .toStringAsFixed(2);
//     adjustedBalance = "0";
//   } else {
//     this.adjustedBalance =
//         (double.parse(widget.saleReturnData.earnCoins) - (double.parse(widget.saleReturnData.walletBalance)))
//             .toStringAsFixed(2);
//   }
//
//   if ((double.parse(adjustedBalance!) / 3 >= double.parse(widget.saleReturnData.amountPaid))) {
//     returnAmount = amountPaid;
//   } else {
//     this.returnAmount =
//         (double.parse(widget.saleReturnData.amountPaid) - double.parse(adjustedBalance!) / 3).toStringAsFixed(2);
//   }
//
//   super.initState();
// }

// SingleChildScrollView(
// child: Center(
// child: Column(
// children: [
// SizedBox(
// height: 30,
// ),
// Container(
// height: MediaQuery.of(context).size.height * 0.15,
// width: MediaQuery.of(context).size.width * 0.88,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// gradient: LinearGradient(
// begin: Alignment.topRight,
// end: Alignment.bottomLeft,
// // stops: [0.1, 0.5, 0.7, 0.9],
// colors: [
// RedDarkColor,
// RedLightColor,
// ],
// ),
// ),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// AutoSizeText(
// "customer_coin_balance_key".tr(),
// maxLines: 1,
// maxFontSize: 16,
// minFontSize: 12,
// style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
// ),
// Flexible(
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Image.asset(
// "assets/images/point.png",
// scale: 2.5,
// ),
// Text(
// " $coinBalance",
// style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
// ),
// ],
// ),
// ),
// ],
// )),
// SizedBox(
// height: 30,
// ),
// Container(
// width: MediaQuery.of(context).size.width * 0.88,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(10),
// boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 5, color: Colors.black12)]),
// child: Padding(
// padding: const EdgeInsets.all(14),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// "return_calculation_key".tr(),
// style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
// ),
// SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// "amt_paid_key".tr(),
// style: TextStyle(fontSize: 13, color: Colors.black87),
// ),
// Text(
// "\u20B9$amountPaid",
// style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// "earn_coins_key".tr(),
// style: TextStyle(fontSize: 13, color: Colors.black87),
// ),
// Row(
// children: [
// Image.asset(
// "assets/images/point.png",
// width: 14,
// height: 14,
// ),
// Text(
// (double.parse(earingCoins!)).toStringAsFixed(2) +
// " (\u20B9${(double.parse(earingCoins!) / 3).toStringAsFixed(2)})",
// style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
// ),
// ],
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// "redeem_coins_key".tr(),
// style: TextStyle(fontSize: 13, color: Colors.black87),
// ),
// Row(
// children: [
// Image.asset(
// "assets/images/point.png",
// width: 14,
// height: 14,
// ),
// Text(
// (double.parse(redeemCoins!)).toStringAsFixed(2) +
// " (\u20B9${(double.parse(redeemCoins!) / 3).toStringAsFixed(2)})",
// style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
// ),
// ],
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// "customer_coin_balance_key".tr(),
// style: TextStyle(fontSize: 13, color: Colors.black87),
// ),
// Row(
// children: [
// Image.asset(
// "assets/images/point.png",
// width: 14,
// height: 14,
// ),
// Text(
// " $coinBalance (\u20B9${(double.parse(coinBalance!) / 3).toStringAsFixed(2)})",
// style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
// ),
// ],
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// "adj_balance_key".tr(),
// style: TextStyle(fontSize: 13, color: Colors.black87),
// ),
// Row(
// children: [
// Image.asset(
// "assets/images/point.png",
// width: 14,
// height: 14,
// ),
// Text(
// " $adjustedBalance (\u20B9${(double.parse(adjustedBalance!) / 3).toStringAsFixed(2)})",
// style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
// ),
// ],
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// Text(
// "amt_return_to_customer_key".tr(),
// style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
// ),
// ],
// ),
// ),
// ),
// SizedBox(
// height: 30,
// ),
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(100),
// gradient: LinearGradient(
// begin: Alignment.topRight,
// end: Alignment.bottomLeft,
// stops: [-1, 0.4],
// colors: [PurpleLightColor, PurpleDarkColor],
// ),
// ),
// child: Center(
// child: Text(
// "\u20b9${(double.parse(returnAmount!)).toStringAsFixed(2)}",
// style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
// ),
// ),
// ),
// ],
// ),
// ),
// ),

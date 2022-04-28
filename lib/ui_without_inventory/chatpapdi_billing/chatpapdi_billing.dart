import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/chat_papdi_module/billing_chatpapdi.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/ScannerChatPapdi/scanner_chatpapdi.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_bloc.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_event.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_state.dart';
import 'package:vendor/ui_without_inventory/home/bottom_navigation_bar.dart';
import 'package:vendor/ui_without_inventory/home/home.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/utility/validator.dart';

class ChatPapdiBilling extends StatefulWidget {
  ChatPapdiBilling({Key? key}) : super(key: key);

  @override
  _ChatPapdiBillingState createState() => _ChatPapdiBillingState();
}

class _ChatPapdiBillingState extends State<ChatPapdiBilling> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  ChatPapdiBillingCustomerNumberResponseBloc directBillingCustomerNumberResponseBloc =
      ChatPapdiBillingCustomerNumberResponseBloc();
  var value = true;
  var message = "";
  bool? status, redeem = false;
  bool valuefirst = false;
  String coins = "0.0";
  var status1;
  String earningCoins = "0.0";
  String coinss = "0.0";

  String amount = "0.0";
  var billing, succes;
  ChatPapdiData? datas;
  ChatPapdiData? passing;
  Widget show(var coins) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            child: Image.asset(
          "assets/images/point.png",
          scale: 2,
        )),
        Text(
          "  $coins",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ColorPrimary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatPapdiBillingCustomerNumberResponseBloc>(
      create: (context) => directBillingCustomerNumberResponseBloc,
      child: BlocConsumer<ChatPapdiBillingCustomerNumberResponseBloc, ChatPapdiBillingCustomerNumberResponseState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("billing_key".tr(), style: TextStyle(fontWeight: FontWeight.w600)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(child: HomeScreenWithoutInventory(), type: PageTransitionType.fade),
                      ModalRoute.withName("/"));
                },
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  children: [
                    BlocConsumer<ChatPapdiBillingCustomerNumberResponseBloc,
                        ChatPapdiBillingCustomerNumberResponseState>(
                      listener: (context, state) async {
                        if (state is GetChatPapdiBillingCustomerNumberResponseState) {
                          coins = state.data.toString();
                          status1 = state.status;
                          log("staus=>$status1}");
                        }

                        if (state is GetChatPapdiBillingCustomerNumberResponseFailureState) {
                          status1 = state.status;
                        }
                        if (state is GetChatPapdiBillingFailureState) {
                          message = state.message;
                          status = state.succes;
                        }

                        if (state is GetChatPapdiBillingState) {
                          message = state.message;
                          status = state.succes;
                          datas = state.data;
                          _displayDialog(context, 1, "please_enter_password_key".tr(), "enter_otp_key".tr());
                        }

                        if (state is GetChatPapdiBillingLoadingstate) {}

                        if (state is GetChatPapdiBillingFailureState) {
                          message = state.message;
                          Utility.showToast(msg: state.message);
                        }
                        if (state is GetChatPapdiBillingOtpState) {
                          Utility.showToast(msg: state.message);

                          // var result = await
                          datas!.qrCodeStatus == 0
                              ? _displayDialogs(context, datas!.earningCoins, 0, "")
                              : _displayDialogs(context, datas!.earningCoins, 1, datas);
                          // log("-------$result --------");
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             BottomNavigationHomeWithOutInventory()));
                        }
                        if (state is GetChatPapdiBillingOtpLoadingstate) {}
                        if (state is GetChatPapdiBillingOtpFailureState) {
                          Utility.showToast(msg: state.message);
                        }
                        if (state is GetChatPapdiPartialUserState) {
                          succes = state.succes;
                          directBilling(context);
                        }

                        if (state is GetChatPapdiPartialUserFailureState) {
                          succes = state.succes;
                        }
                      },
                      builder: (context, state) {
                        return show(coins);
                      },
                    ),
                    Container(
                      child: Column(children: [
                        TextFormField(
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            validator: (numb) => Validator.validateMobile(numb!, context),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            maxLength: 10,
                            decoration: InputDecoration(
                              hintText: 'enter_customer_phone_number_key'.tr(),
                              labelText: 'mobile_number_key'.tr(),
                              counterText: "",
                              contentPadding: EdgeInsets.all(0),
                              fillColor: Colors.transparent,
                              enabledBorder:
                                  UnderlineInputBorder(borderSide: BorderSide(color: ColorTextPrimary, width: 1.5)),
                              focusedBorder:
                                  UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                              border: UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                            ),
                            onChanged: (length) {
                              if (mobileController.text.length == 10) {
                                directBillingCustomerNumberResponseBloc
                                    .add(GetChatPapdiBillingCustomerNumberResponseEvent(mobile: mobileController.text));
                              }
                              if (mobileController.text.length == 9) {
                                directBillingCustomerNumberResponseBloc
                                    .add(GetChatPapdiBillingCustomerNumberResponseEvent(mobile: mobileController.text));
                                coins = "0";
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        status1 == 0
                            ? TextFormField(
                                controller: nameController,
                                inputFormatters: [FilteringTextInputFormatter.allow(Validator.name)],
                                decoration: InputDecoration(
                                  hintText: 'enter_customer_name_key'.tr(),
                                  labelText: 'full_name_key'.tr(),
                                  counterText: "",
                                  contentPadding: EdgeInsets.all(0),
                                  fillColor: Colors.transparent,
                                  enabledBorder:
                                      UnderlineInputBorder(borderSide: BorderSide(color: ColorTextPrimary, width: 1.5)),
                                  focusedBorder:
                                      UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                ),
                                onChanged: (length) {})
                            : Container(),
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: 'amount_spent_here_key'.tr(),
                          labelText: 'amount_key'.tr(),
                          counterText: "",
                          contentPadding: EdgeInsets.all(0),
                          fillColor: Colors.transparent,
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide(color: ColorTextPrimary, width: 1.5)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                        ),
                        onChanged: (length) {
                          if (length.isEmpty) {
                            coinss = 0.0.toString();
                            amount = 0.0.toString();
                            earningCoins = 0.0.toString();
                            redeem = false;
                          } else {
                            calculation(length);
                            calculateEarnCoins(double.parse(length));
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(0.0, 0.0), //(x,y)
                            blurRadius: 7.0,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: this.redeem,
                            checkColor: Colors.white,
                            // value: widget
                            //     .billingItemList[index]
                            //     .billingcheck,
                            activeColor: ColorPrimary,
                            onChanged: (redeems) {
                              log("true===>");
                              redeem = false;

                              if (mobileController.text.length == 10) {
                                if (amountController.text.length > 0) {
                                  if (double.parse(coins) >= 3) {
                                    calculation(amountController.text);
                                    calculateEarnCoins(double.parse(amountController.text));
                                    setState(() {
                                      redeem = redeems;
                                    });
                                  } else {
                                    Utility.showToast(msg: "You_dont_have_enough_coins".tr());
                                  }
                                } else {
                                  Utility.showToast(msg: "please_enter_number_first_key".tr());
                                }
                              } else {
                                Utility.showToast(msg: "please_enter_10_digits_number_key".tr());
                              }
                              if (redeem == true) {
                                redeemDialog(context);
                              }
                              calculation(amountController.text.isEmpty ? "0" : amountController.text);

                              calculateEarnCoins(
                                  double.parse(amountController.text.isEmpty ? "0" : amountController.text));
                            },
                          ),
                          Text(
                            "  " + "redeemed_coins_key".tr(),
                            style: TextStyle(fontSize: 17, color: ColorTextPrimary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      decoration:
                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 7.0,
                        ),
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "calculation_key".tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("earn_coins_key".tr()),
                              Row(
                                children: [
                                  Container(
                                      child: Image.asset(
                                    "assets/images/point.png",
                                    scale: 3,
                                  )),
                                  Text(" $earningCoins"),
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
                              Text("total_coin_deducted_key".tr()),
                              Row(children: [
                                Container(
                                    child: Image.asset(
                                  "assets/images/point.png",
                                  scale: 3,
                                )),
                                Text(" $coinss")
                              ]),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration:
                          BoxDecoration(color: ColorPrimary, borderRadius: BorderRadius.circular(10), boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 7.0,
                        ),
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "total_payable_amount_key".tr(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "\u20B9 $amount",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: 60,
              child: Center(
                child: InkWell(
                  onTap: () {
                    if (status1 == 0) {
                      if (mobileController.text.length == 10) {
                        if (amountController.text.length >= 0) {
                          if (nameController.text.length > 1) {
                            userRegister(context);

                            if (succes == true) {}
                          } else {
                            Utility.showToast(msg: "please_enter_name_key".tr());
                          }
                        } else {
                          Utility.showToast(msg: "please_enter_amount_key".tr());
                        }
                      } else {
                        Utility.showToast(msg: "please_enter_10_digits_number_key".tr());
                      }
                    } else {
                      if (mobileController.text.length == 10) {
                        if (amountController.text.length >= 0) {
                          directBilling(context);
                        } else {
                          Utility.showToast(msg: "please_enter_amount_key");
                        }
                      } else {
                        Utility.showToast(msg: "please_enter_10_digits_number_key".tr());
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColorPrimary,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("submit_button_key".tr(),
                          style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  calculation(String length) {
    if (redeem == true) {
      if (double.parse(coins) >= double.parse(length) * 3) {
        double amounts = double.parse(length) * 3;

        coinss = amounts.toStringAsFixed(2);
        amount = 0.0.toString();
      } else {
        int i = 1;
        var rs;
        if (1 == i) {
          rs = double.parse(coins) / 3;
          coinss = coins.toString();
          amount = (double.parse(length) - rs).toStringAsFixed(2);
        }
      }
    } else {
      coinss = 0.0.toString();
      amount = length.toString();
    }
  }

  void calculateEarnCoins(double amount) async {
    if (amount.toString().isNotEmpty) {
      var c = await SharedPref.getStringPreference(SharedPref.COMMISSION);
      double commission = double.parse(c);
      String freeCoins = await SharedPref.getStringPreference(SharedPref.VendorCoin);
      amount = double.parse(freeCoins) != 0 ? amount : amount - (amount * 18) / 100;
      amount = (amount * commission) / 100;

      amount = amount / 2;
      amount = amount * 3;
      amount = amount < 0 ? 0 : amount;
      amount = amount - 0.75;
      earningCoins = amount.toStringAsFixed(2);
    } else {
      earningCoins = "0.0";
    }
  }

  Future<void> userRegister(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["mobile"] = mobileController.text;
    input["first_name"] = nameController.text;

    directBillingCustomerNumberResponseBloc.add(GetChatPapdiPartialUserRegisterEvent(input: input));
  }

  Future<void> directBilling(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["mobile"] = mobileController.text;
    input["bill_amount"] = amountController.text;
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["total_pay"] = amount;
    input["coin_deducted"] = coinss;

    directBillingCustomerNumberResponseBloc.add(GetChatPapdiBillingEvent(input: input));
  }

  Future<void> verifyOtp(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["bill_id"] = datas!.billId;

    input["otp"] = otpController.text;
    input["total_pay"] = datas!.totalPay;
    input["coin_deducted"] = datas!.coinDeducted;
    input["earning_coins"] = datas!.earningCoins;
    input["myprofit_revenue"] = datas!.myProfitRevenue;
    SharedPref.setStringPreference(SharedPref.VendorCoin, datas!.vendorAvailableCoins);
    input["vendor_available_coins"] = datas!.vendorAvailableCoins;
    log("=====? $input");
    directBillingCustomerNumberResponseBloc.add(GetChatPapdiBillingOtpEvent(input: input));
  }

  _displayDialog(BuildContext context, index, text, hintText) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.40),
            child: AlertDialog(
              contentPadding: const EdgeInsets.only(left: 20, right: 20,bottom: 20),
              titlePadding:  const EdgeInsets.only(left: 20, right: 20,top: 20, bottom: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(
                "$text",
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                  fontSize: 18.0,
                  color: TextBlackLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: TextFormField(
                controller: otpController,
                cursorColor: ColorPrimary,
                maxLength: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: TextGrey,
                    fontSize: 17,
                    letterSpacing: 1
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0),
                  counterText: "",
                  hintText: "$hintText",
                  hintStyle: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: TextGrey
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
                      if (status == 0) {
                        log("index->$index");

                        // directBillingCustomerNumberResponseBloc.add((
                        //     price: y, index: index, earningCoin: earningCoin));
                        otpController.clear();
                        Navigator.pop(context);
                      } else {
                        verifyOtp(context);
                      }
                    },
                    child: new Text(
                      "submit_button_key".tr(),
                      style: GoogleFonts.openSans(
                          fontSize: 17, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        }).then((value) => otpController.clear());
  }

  _displayDialogs(BuildContext context, hinttext, sta, data) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset(
                  "assets/images/otp-wallet.png",
                  fit: BoxFit.cover,
                  height: 70,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    "assets/images/point.png",
                    height: 40,
                    width: 40,
                  ),
                  Text(
                    " ${double.parse(hinttext).toStringAsFixed(2)} ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 40.0,
                      color: ColorPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                Text("${"coin_generated_successfully_key".tr()}\n ${"in_customer_wallet_key".tr()}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 17.0,
                      color: ColorTextPrimary,
                      fontWeight: FontWeight.w600,
                    )),
              ]),
              actions: <Widget>[
                Center(
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.40,
                    height: 50,
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: ColorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      sta == 1
                          ? Navigator.push(context, MaterialPageRoute(builder: (context) => Scanner(data: datas!)))
                          : Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  child: BottomNavigationHomeWithOutInventory(), type: PageTransitionType.fade),
                              ModalRoute.withName("/"));
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
            ),
          );
        });
  }

  redeemDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            titlePadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Image.asset(
              "assets/images/3x/hooray-banner.png",
              fit: BoxFit.cover,
            ),
            content: Container(
              height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "hooray_you_saved".tr(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      " \u20B9${(double.parse(coinss) / 3).toStringAsFixed(0)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorPrimary),
                    ),
                  ],
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
                    Navigator.pop(context);
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

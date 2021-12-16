import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/model/chat_papdi_module/billing_chatpapdi.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/ScannerChatPapdi/scanner_chatpapdi.dart';

import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_bloc.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_event.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_state.dart';

import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
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
  ChatPapdiBillingCustomerNumberResponseBloc
      directBillingCustomerNumberResponseBloc =
      ChatPapdiBillingCustomerNumberResponseBloc();
  var value = true;
  var message = "";
  bool? status, redeem = false;
  bool valuefirst = false;
  String coins = "0.0";
  var status1;

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
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: ColorPrimary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatPapdiBillingCustomerNumberResponseBloc>(
      create: (context) => directBillingCustomerNumberResponseBloc,
      child: BlocConsumer<ChatPapdiBillingCustomerNumberResponseBloc,
          ChatPapdiBillingCustomerNumberResponseState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("billing_key".tr(),
                  style: TextStyle(fontWeight: FontWeight.w600)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                children: [
                  BlocConsumer<ChatPapdiBillingCustomerNumberResponseBloc,
                      ChatPapdiBillingCustomerNumberResponseState>(
                    listener: (context, state) async {
                      if (state
                          is GetChatPapdiBillingCustomerNumberResponseState) {
                        coins = state.data.toString();
                        status1 = state.status;
                        log("staus=>$status1}");
                      }

                      if (state
                          is GetChatPapdiBillingCustomerNumberResponseFailureState) {
                        status1 = state.status;
                        log("staus=>$status1}");
                      }
                      if (state is GetChatPapdiBillingFailureState) {
                        message = state.message;
                        status = state.succes;
                      }

                      if (state is GetChatPapdiBillingState) {
                        message = state.message;
                        status = state.succes;
                        datas = state.data;
                        _displayDialog(
                            context,
                            1,
                            "please_enter_password_key".tr(),
                            "enter_otp_key".tr());
                      }

                      if (state is GetChatPapdiBillingLoadingstate) {}

                      if (state is GetChatPapdiBillingFailureState) {
                        message = state.message;
                        Fluttertoast.showToast(
                            msg: state.message, backgroundColor: ColorPrimary);
                      }
                      if (state is GetChatPapdiBillingOtpState) {
                        Fluttertoast.showToast(
                            msg: state.message, backgroundColor: ColorPrimary);
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scanner(data: datas!)));
                        log("-------$result --------");
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             BottomNavigationHomeWithOutInventory()));
                      }
                      if (state is GetChatPapdiBillingOtpLoadingstate) {}
                      if (state is GetChatPapdiBillingOtpFailureState) {
                        Fluttertoast.showToast(
                            msg: state.message, backgroundColor: ColorPrimary);
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
                          validator: (numb) =>
                              Validator.validateMobile(numb!, context),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 10,
                          decoration: InputDecoration(
                            hintText: 'enter_customer_phone_number_key'.tr(),
                            labelText: 'mobile_number_key'.tr(),
                            counterText: "",
                            contentPadding: EdgeInsets.all(0),
                            fillColor: Colors.transparent,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTextPrimary, width: 1.5)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorPrimary, width: 1.5)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorPrimary, width: 1.5)),
                          ),
                          onChanged: (length) {
                            if (mobileController.text.length == 10) {
                              directBillingCustomerNumberResponseBloc.add(
                                  GetChatPapdiBillingCustomerNumberResponseEvent(
                                      mobile: mobileController.text));
                            }
                            if (mobileController.text.length == 9) {
                              directBillingCustomerNumberResponseBloc.add(
                                  GetChatPapdiBillingCustomerNumberResponseEvent(
                                      mobile: mobileController.text));
                              coins = "0";
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      status1 == 0
                          ? TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'enter_customer_name_key'.tr(),
                                labelText: 'full_name_key'.tr(),
                                counterText: "",
                                contentPadding: EdgeInsets.all(0),
                                fillColor: Colors.transparent,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorTextPrimary, width: 1.5)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPrimary, width: 1.5)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPrimary, width: 1.5)),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: 'amount_spent_here_key'.tr(),
                          labelText: 'amount_key'.tr(),
                          counterText: "",
                          contentPadding: EdgeInsets.all(0),
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorTextPrimary, width: 1.5)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPrimary, width: 1.5)),
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPrimary, width: 1.5)),
                        ),
                        onChanged: (length) {
                          log("$status1  ===>");
                          if (length.isEmpty) {
                            log("if$length");
                            log("if$coins");
                            coinss = 0.toString();
                          } else {
                            log("else$length");
                            calculaton(length);
                          }
                          setState(() {});
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text("total_payable_amount_key $amount".tr()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text("total_coin_deducted_key $coinss".tr()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 18,
                        width: 18,
                        color: Colors.white,
                        child: Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
                                calculaton(amountController.text);
                                setState(() {
                                  redeem = redeems;
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "please_enter_name_key".tr(),
                                    backgroundColor: ColorPrimary);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "please_enter_10_digits_number_key".tr(),
                                  backgroundColor: ColorPrimary);
                            }
                            calculaton(amountController.text.isEmpty
                                ? "0"
                                : amountController.text);
                          },
                        ),
                      ),
                      Text(
                        "  redeemed_coins_key".tr(),
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (status1 == 0) {
                          if (mobileController.text.length == 10) {
                            if (amountController.text.length >= 0) {
                              if (nameController.text.length > 1) {
                                userRegister(context);
                                log("====>$succes");
                                if (succes == true) {}
                              } else {
                                Fluttertoast.showToast(
                                    msg: "please_enter_name_key ".tr(),
                                    backgroundColor: ColorPrimary);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "please_enter_amount_key".tr(),
                                  backgroundColor: ColorPrimary);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "please_enter_10_digits_number_key".tr(),
                                backgroundColor: ColorPrimary);
                          }
                        } else {
                          if (mobileController.text.length == 10) {
                            if (amountController.text.length >= 0) {
                              directBilling(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "please_enter_amount_key",
                                  backgroundColor: ColorPrimary);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "please_enter_10_digits_number_key".tr(),
                                backgroundColor: ColorPrimary);
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: ColorPrimary,
                            borderRadius: BorderRadius.circular(10)),
                        width: 250,
                        child: Center(
                          child: Text("submit_button_key".tr(),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  calculaton(String length) {
    if (redeem == true) {
      if (double.parse(coins) >= double.parse(length) * 3) {
        double amounts = double.parse(length) * 3;
        log("amount1===>$amounts");
        coinss = amounts.toStringAsFixed(2);
        amount = 0.toString();
        log("coins1===>$coins");
      } else {
        int i = 1;
        var rs;
        if (1 == i) {
          rs = double.parse(coins) / 3;
          log("==>rs$rs");
          coinss = coins.toString();
          log("==>controller${length}");
          amount = (double.parse(length) - rs).toStringAsFixed(2);
          log("===>amount${length}");
        }
      }
    } else {
      coinss = 0.toString();
      amount = 0.toString();
    }
  }

  Future<void> userRegister(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["mobile"] = mobileController.text;
    input["first_name"] = nameController.text;

    log("=====? $input");
    directBillingCustomerNumberResponseBloc
        .add(GetChatPapdiPartialUserRegisterEvent(input: input));
  }

  Future<void> directBilling(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["mobile"] = mobileController.text;
    input["bill_amount"] = amountController.text;
    input["vendor_id"] =
        await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["total_pay"] = amount;
    input["coin_deducted"] = coinss;

    log("=====? $input");
    directBillingCustomerNumberResponseBloc
        .add(GetChatPapdiBillingEvent(input: input));
  }

  Future<void> verifyOtp(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] =
        await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["bill_id"] = datas!.billId;

    input["otp"] = otpController.text;
    input["total_pay"] = datas!.totalPay;
    input["coin_deducted"] = datas!.coinDeducted;
    input["earning_coins"] = datas!.earningCoins;
    input["myprofit_revenue"] = datas!.myProfitRevenue;

    log("=====? $input");

    directBillingCustomerNumberResponseBloc
        .add(GetChatPapdiBillingOtpEvent(input: input));
  }

  _displayDialog(BuildContext context, index, text, hinttext) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: RichText(
                text: TextSpan(
                  text: "$text",
                  style: GoogleFonts.openSans(
                    fontSize: 18.0,
                    color: ColorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              content: TextFormField(
                controller: otpController,
                cursorColor: ColorPrimary,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // filled: true,

                  // fillColor: Colors.black,
                  hintText: "$hinttext`",
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
              ),
              actions: <Widget>[
                Center(
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.40,
                    height: 50,
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: ColorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if (status1 == 0) {
                        log("index->$index");

                        // directBillingCustomerNumberResponseBloc.add((
                        //     price: y, index: index, earningCoin: earningCoin));
                        otpController.clear();
                        mobileController.clear();
                        nameController.clear();
                        amountController.clear();
                        redeem = false;
                        FocusScope.of(context).unfocus();

                        Navigator.pop(context);
                      } else {
                        verifyOtp(context);
                      }
                    },
                    child: new Text(
                      "done_key".tr(),
                      style: GoogleFonts.openSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
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
        }).then((value) => otpController.clear());
  }
}

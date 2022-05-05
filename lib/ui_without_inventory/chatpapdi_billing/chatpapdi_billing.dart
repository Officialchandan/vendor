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
  String firstName = "You";
  String lastName = "";
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
              title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("billing_key".tr(), style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(width: 5),
                Image.asset(
                  "assets/images/point.png",
                  width: 25,
                ),
                SizedBox(
                  width: 35,
                )
              ]),
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
                          firstName = state.firstName;
                          lastName = state.lastName;
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
                        if (state is ChatPapdiCheckboxState) {
                          redeem = false;
                          if (mobileController.text.length == 10) {
                            if (amountController.text.length > 0) {
                              if (double.parse(coins) >= 3) {
                                calculation(amountController.text);
                                calculateEarnCoins(double.parse(amountController.text));
                                setState(() {
                                  redeem = state.isChecked;
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

                          calculateEarnCoins(double.parse(amountController.text.isEmpty ? "0" : amountController.text));
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
                            style: TextStyle(color: TextBlackLight, fontSize: 16),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            maxLength: 10,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 12),
                              hintText: 'enter_customer_phone_number_key'.tr(),
                              hintStyle: TextStyle(color: TextBlackLight, fontSize: 16),
                              labelText: 'mobile_number_key'.tr(),
                              labelStyle: TextStyle(color: TextBlackLight, fontSize: 16),
                              counterText: "",
                              contentPadding: EdgeInsets.all(0),
                              fillColor: Colors.transparent,
                              enabledBorder:
                                  UnderlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 1.5)),
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
                                style: TextStyle(color: TextBlackLight, fontSize: 16),
                                inputFormatters: [FilteringTextInputFormatter.allow(Validator.name)],
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: TextBlackLight, fontSize: 16),
                                  labelStyle: TextStyle(color: TextBlackLight, fontSize: 16),
                                  errorStyle: TextStyle(fontSize: 12),
                                  hintText: 'enter_customer_name_key'.tr(),
                                  labelText: 'full_name_key'.tr(),
                                  counterText: "",
                                  contentPadding: EdgeInsets.all(0),
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: textFieldBorderColor, width: 1.5)),
                                  focusedBorder:
                                      UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                ),
                                onChanged: (length) {})
                            : Container(),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: TextBlackLight, fontSize: 16),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: TextBlackLight, fontSize: 16),
                          labelStyle: TextStyle(color: TextBlackLight, fontSize: 16),
                          errorStyle: TextStyle(fontSize: 12),
                          hintText: 'amount_spent_here_key'.tr(),
                          labelText: 'amount_key'.tr(),
                          counterText: "",
                          contentPadding: EdgeInsets.all(0),
                          fillColor: Colors.transparent,
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 1.5)),
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
                    // SizedBox(
                    //   height: 210,
                    // ),
                    // Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: InkWell(
                    //     onTap: (){
                    //       if(redeem == false){
                    //         directBillingCustomerNumberResponseBloc.add(ChatPapdiCheckBoxEvent(isChecked: true));
                    //       }
                    //
                    //       if(redeem == true){
                    //         directBillingCustomerNumberResponseBloc.add(ChatPapdiCheckBoxEvent(isChecked: false));
                    //       }
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           "redeem_coins_key".tr(),
                    //           style: TextStyle(fontSize: 15, color: ColorTextPrimary, fontWeight: FontWeight.bold),
                    //         ),
                    //         SizedBox(
                    //           height: 20,
                    //           width: 20,
                    //           child: Checkbox(
                    //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //             value: this.redeem,
                    //             checkColor: Colors.white,
                    //             shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(2)
                    //             ),
                    //             side: BorderSide(width: 1.5),
                    //             activeColor: ColorPrimary,
                    //             onChanged: (value) {
                    //               directBillingCustomerNumberResponseBloc.add(ChatPapdiCheckBoxEvent(isChecked: value!));
                    //             },
                    //           ),
                    //         ),
                    //
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 14,
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 10,horizontal: 14),
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration:
                    //       BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.shade300,
                    //       offset: Offset(0.0, 0.0), //(x,y)
                    //       blurRadius: 7.0,
                    //     ),
                    //   ]),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             "total_order_value_key".tr(),
                    //             style: TextStyle(color: TextBlackLight, fontSize: 15, fontWeight: FontWeight.bold),
                    //           ),
                    //           Row(
                    //             children: [
                    //               Text("\u20B9",
                    //                   style:
                    //                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    //               Text("${amountController.text.isEmpty ? 0.0 : amountController.text}",
                    //                   style:
                    //                   TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text("redeemed_coins_key".tr(),
                    //             style: TextStyle(color: TextBlackLight, fontSize: 15, fontWeight: FontWeight.bold),),
                    //           Row(children: [
                    //             Container(
                    //                 child: Image.asset(
                    //               "assets/images/point.png",
                    //               scale: 3,
                    //             )),
                    //             Text(" $coinss", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                    //           ]),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text("earned_coins_key".tr(),
                    //             style: TextStyle(color: TextBlackLight, fontSize: 15, fontWeight: FontWeight.bold),),
                    //           Row(
                    //             children: [
                    //               Container(
                    //                   child: Image.asset(
                    //                 "assets/images/point.png",
                    //                 scale: 3,
                    //               )),
                    //               Text(" $earningCoins",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    //         Text(
                    //           "net_payable_key".tr(),
                    //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorPrimary),
                    //         ),
                    //         Row(
                    //           children: [
                    //             Text("\u20B9",
                    //                 style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: ColorPrimary)),
                    //             Text("$amount",
                    //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorPrimary)),
                    //           ],
                    //         ),
                    //       ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: MediaQuery.of(context).size.height * 0.32,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: InkWell(
                      onTap: () {
                        if (redeem == false) {
                          directBillingCustomerNumberResponseBloc.add(ChatPapdiCheckBoxEvent(isChecked: true));
                        }

                        if (redeem == true) {
                          directBillingCustomerNumberResponseBloc.add(ChatPapdiCheckBoxEvent(isChecked: false));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "redeem_coins_key".tr(),
                            style: TextStyle(fontSize: 15, color: ColorTextPrimary, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: this.redeem,
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              side: BorderSide(width: 1.5),
                              activeColor: ColorPrimary,
                              onChanged: (value) {
                                directBillingCustomerNumberResponseBloc.add(ChatPapdiCheckBoxEvent(isChecked: value!));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(0.0, 0.0), //(x,y)
                        blurRadius: 7.0,
                      ),
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "total_order_value_key".tr(),
                              style: TextStyle(color: TextBlackLight, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text("\u20B9",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                                Text("${amountController.text.isEmpty ? 0.0 : amountController.text}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
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
                              "redeemed_coins_key".tr(),
                              style: TextStyle(color: TextBlackLight, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Row(children: [
                              Container(
                                  child: Image.asset(
                                "assets/images/point.png",
                                scale: 3,
                              )),
                              Text(" $coinss",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "earned_coins_key".tr(),
                              style: TextStyle(color: TextBlackLight, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Container(
                                    child: Image.asset(
                                  "assets/images/point.png",
                                  scale: 3,
                                )),
                                Text(" $earningCoins",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
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
                              "net_payable_key".tr(),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorPrimary),
                            ),
                            Row(
                              children: [
                                Text("\u20B9",
                                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: ColorPrimary)),
                                Text("$amount",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorPrimary)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
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
                ],
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
              titlePadding: const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 10),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              actionsPadding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: RichText(
                text: TextSpan(
                  text: "${"otp_verification_key".tr()}\n",
                  style: GoogleFonts.openSans(
                    fontSize: 25.0,
                    height: 2.0,
                    color: TextBlackLight,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "${"please_verify_your_otp_on_key".tr()}\n",
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        height: 1.5,
                        color: ColorTextPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "+91 ${mobileController.text}",
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        height: 1.5,
                        color: ColorTextPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              content: TextFormField(
                controller: otpController,
                maxLength: 6,
                cursorColor: ColorPrimary,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  filled: true,
                  counterText: "",
                  // fillColor: Colors.black,
                  hintText: "enter_otp_key".tr(),
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: const EdgeInsets.only(left: 14.0, right: 14, top: 8, bottom: 8),
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
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
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
                      "${"hooray_you_saved".tr()} $firstName ${"saved_key".tr()}",
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

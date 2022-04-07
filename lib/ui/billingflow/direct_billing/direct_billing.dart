import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/direct_billing.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/ui/billingflow/direct_billing/ScannerDirectBilling/scanner.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_bloc.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_event.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_state.dart';
import 'package:vendor/ui/home/bottom_navigation_home.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/validator.dart';

class DirectBilling extends StatefulWidget {
  DirectBilling({Key? key}) : super(key: key);

  @override
  _DirectBillingState createState() => _DirectBillingState();
}

class _DirectBillingState extends State<DirectBilling> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  DirectBillingCustomerNumberResponseBloc directBillingCustomerNumberResponseBloc =
      DirectBillingCustomerNumberResponseBloc();
  var value = true;
  var checkbox = false;
  var message = "";
  var status1, succes;
  bool? status, redeem = false;
  List<CategoryModel> categoryList = [];
  bool valuefirst = false;
  String coins = "0.0";
  List categoryIdList = [];
  String coinss = "0.0", earn = "0.0";

  String amount = "0.0";
  var billing;
  DirectBillingData? datas;

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
  void initState() {
    directBillingCustomerNumberResponseBloc.add(GetDirectBillingCategoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DirectBillingCustomerNumberResponseBloc>(
      create: (context) => directBillingCustomerNumberResponseBloc,
      child: BlocConsumer<DirectBillingCustomerNumberResponseBloc, DirectBillingCustomerNumberResponseState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("direct_billing_key".tr(), style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(width: 3),
                Image.asset(
                  "assets/images/point.png",
                  scale: 2,
                ),
                SizedBox(
                  width: 35,
                )
              ]),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  children: [
                    BlocConsumer<DirectBillingCustomerNumberResponseBloc, DirectBillingCustomerNumberResponseState>(
                      listener: (context, state) {
                        if (state is DirectBillingCustomerNumberResponseState) {
                          log("number chl gya");

                          //coins = state.data;
                          // Fluttertoast.showToast(
                          //     backgroundColor: ColorPrimary,
                          //     textColor: Colors.white,
                          //     msg: state.message);
                        }
                        if (state is GetDirectBillingCustomerNumberResponseFailureState) {
                          message = state.message;
                          status = state.succes;
                          status1 = state.status;
                        }

                        if (state is GetDirectBillingState) {
                          message = state.message;
                          status = state.succes;
                          datas = state.data;

                          _displayDialog(context, 1, "please_enter_password_key".tr(), "enter_otp_key".tr());
                        }

                        if (state is GetDirectBillingLoadingstate) {}

                        if (state is GetDirectBillingFailureState) {
                          message = state.message;
                          Fluttertoast.showToast(msg: state.message, backgroundColor: ColorPrimary);
                        }
                        if (state is GetDirectBillingOtpState) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: state.message, backgroundColor: ColorPrimary);
                          int.parse(datas!.qrCodeStatus) == 0
                              ? _displayDialogs(context, datas!.earningCoins, 0, "")
                              : _displayDialogs(context, datas!.earningCoins, 1, datas);
                        }
                        if (state is GetDirectBillingOtpLoadingstate) {}
                        if (state is GetDirectBillingOtpFailureState) {
                          Fluttertoast.showToast(msg: state.message, backgroundColor: ColorPrimary);
                        }
                        if (state is GetDirectBillingPartialUserState) {
                          succes = state.succes;
                          directBilling(context);
                        }

                        if (state is GetDirectBillingPartialUserFailureState) {
                          succes = state.succes;
                        }
                        if (state is GetDirectBillingCategoryByVendorIdState) {
                          categoryList = state.data;
                        }
                      },
                      builder: (context, state) {
                        if (state is GetDirectBillingCustomerNumberResponseState) {
                          status1 = state.status;
                          coins = state.data.toString();
                        }

                        return show(coins);
                      },
                    ),
                    Container(
                      child: Column(
                        children: [
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
                                      .add(GetDirectBillingCustomerNumberResponseEvent(mobile: mobileController.text));
                                }
                                if (mobileController.text.length == 9) {
                                  directBillingCustomerNumberResponseBloc
                                      .add(GetDirectBillingCustomerNumberResponseEvent(mobile: mobileController.text));
                                }
                              }),
                          status1 == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: 'enter_customer_name_key'.tr(),
                                        labelText: 'full_name_key'.tr(),
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(0),
                                        fillColor: Colors.transparent,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: ColorTextPrimary, width: 1.5)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                      ),
                                      onChanged: (length) {
                                        // if (name.text.length == 10) {
                                        //   directBillingCustomerNumberResponseBloc.add(
                                        //       GetDirectBillingCustomerNumberResponseEvent(
                                        //           mobile: mobileController.text));
                                        // }
                                      }),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                            focusedBorder:
                                UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                          ),
                          onChanged: (length) {
                            log("$status1  ===>");
                            if (length.isEmpty) {
                              log("if$length");
                              log("if$coins");
                              coinss = 0.toString();
                              amount = 0.toString();
                              redeem = false;
                            } else {
                              log("else$length");
                              calculation(length);
                            }
                            setState(() {});
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: categoryList.isNotEmpty
                          ? categoryList.length > 2
                              ? 150
                              : (70 * (categoryList.length.toDouble()))
                          : 70,
                      width: MediaQuery.of(context).size.width,
                      child: categoryList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: categoryList.length,
                              itemBuilder: (context, index) {
                                return buildList(categoryList[index]);
                              })
                          : succes == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(),
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
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
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
                                    setState(() {
                                      redeem = redeems;
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "You_dont_have_enough_coins".tr(), backgroundColor: ColorPrimary);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "please_enter_number_first_key".tr(), backgroundColor: ColorPrimary);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "please_enter_10_digits_number_key".tr(), backgroundColor: ColorPrimary);
                              }
                              calculation(amountController.text.isEmpty ? "0" : amountController.text);
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
                      height: 110,
                      decoration:
                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
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
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("total_payable_amount_key".tr()),
                          Text("\u20B9 $amount"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: 50,
              child: Center(
                child: InkWell(
                  onTap: () {
                    if (status1 == 0) {
                      if (mobileController.text.length == 10) {
                        if (amountController.text.length >= 0) {
                          if (nameController.text.length > 1) {
                            userRegister(context);
                          } else {
                            Fluttertoast.showToast(msg: "please_enter_name_key".tr(), backgroundColor: ColorPrimary);
                          }
                        } else {
                          Fluttertoast.showToast(msg: "please_enter_amount_key".tr(), backgroundColor: ColorPrimary);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "please_enter_10_digits_number_key".tr(), backgroundColor: ColorPrimary);
                      }
                    } else {
                      if (mobileController.text.length == 10) {
                        if (amountController.text.length >= 0) {
                          if (checkbox == true) {
                            directBilling(context);
                          } else {
                            Fluttertoast.showToast(msg: "Please select category".tr(), backgroundColor: ColorPrimary);
                          }
                        } else {
                          Fluttertoast.showToast(msg: "please_enter_amount_key".tr(), backgroundColor: ColorPrimary);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "please_enter_10_digits_number_key".tr(), backgroundColor: ColorPrimary);
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: ColorPrimary),
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
          log("==>controller$length");
          amount = (double.parse(length) - rs).toStringAsFixed(2);
          log("===>amount$length");
        }
      }
    } else {
      coinss = 0.toString();
      amount = length.toString();
    }
  }

  Future<void> userRegister(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["mobile"] = mobileController.text;
    input["first_name"] = nameController.text;

    log("=====? $input");
    directBillingCustomerNumberResponseBloc.add(GetDirectBillingPartialUserRegisterEvent(input: input));
  }

  Future<void> directBilling(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["mobile"] = mobileController.text;
    input["bill_amount"] = amountController.text;
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["total_pay"] = amount;
    input["coin_deducted"] = coinss;
    input["category_id"] = categoryIdList.join(',');

    log("=====? $input");
    directBillingCustomerNumberResponseBloc.add(GetDirectBillingEvent(input: input));
  }

  Future<void> verifyOtp(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["bill_id"] = datas!.billId;
    input["otp"] = otpController.text;
    input["total_pay"] = datas!.totalPay;
    input["coin_deducted"] = datas!.coinDeducted;
    input["earning_coins"] = datas!.earningCoins;
    input["myprofit_revenue"] = datas!.myprofitRevenue;
    SharedPref.setStringPreference(SharedPref.VendorCoin, datas!.vendorAvailableCoins);
    input["vendor_available_coins"] = datas!.vendorAvailableCoins;

    log("=====? $input");
    directBillingCustomerNumberResponseBloc.add(GetDirectBillingOtpEvent(input: input));
  }

  _displayDialog(BuildContext context, index, text, hinttext) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(
                " $text ",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 17.0,
                  color: ColorPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: TextFormField(
                controller: otpController,
                cursorColor: ColorPrimary,
                maxLength: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // filled: true,
                  counterText: "",
                  // fillColor: Colors.black,
                  hintText: "$hinttext`",
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 0.0),
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

  _displayDialogs(BuildContext context, hinttext, status, data) async {
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
                    scale: 3,
                  ),
                  Text(
                    " ${double.parse(hinttext).toStringAsFixed(2)} ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 17.0,
                      color: ColorPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                Text("Coins generated succesfully\n in customer Wallet",
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
                      status == 1
                          ? Navigator.push(context, MaterialPageRoute(builder: (context) => Scanner(data: data!)))
                          : Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(child: BottomNavigationHome(), type: PageTransitionType.fade),
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

  Widget buildList(list) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: .5), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
            ),
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: list.isChecked,
              checkColor: Colors.white,
              activeColor: ColorPrimary,
              onChanged: (isCheck) {
                list.isChecked = isCheck;
                checkbox = isCheck!;
                if (isCheck) {
                  categoryIdList.add(list.id);
                } else {
                  categoryIdList.remove(list.id);
                }
                setState(() {});

                log("List of Selected Category ${categoryIdList.join(',')}");
              },
            ),
            SizedBox(
              width: 20,
            ),
            Image.network(
              list.image,
              width: 20,
              height: 20,
              color: ColorPrimary,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              list.categoryName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}

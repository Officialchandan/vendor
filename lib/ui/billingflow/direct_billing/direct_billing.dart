import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:vendor/utility/utility.dart';
import 'package:vendor/utility/validator.dart';

import '../../../utility/network.dart';

class DirectBilling extends StatefulWidget {
  int usertype;
  DirectBilling({required this.usertype, Key? key}) : super(key: key);

  @override
  _DirectBillingState createState() => _DirectBillingState();
}

class _DirectBillingState extends State<DirectBilling> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FocusNode mobileFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();

  DirectBillingCustomerNumberResponseBloc
      directBillingCustomerNumberResponseBloc =
      DirectBillingCustomerNumberResponseBloc();
  var value = true;
  bool checkbox = false;
  var message = "";
  var status1, succes;
  String earningCoins = "0.0";
  bool? status, redeem = false;
  List<CategoryModel> categoryList = [];
  bool valuefirst = false;
  String coins = "0.0";
  List categoryIdList = [];
  String coinss = "0.0", earn = "0.0";
  String amount = "0.0";
  String firstname = "You";
  String lastName = "";
  var billing;
  DirectBillingData? datas;
  bool onTileTap = false;

  // -- otpReSend functionality start here -- //

  bool isResendOTPpage = false;
  int _counter = 0;
  StreamController<int> events = StreamController.broadcast();

  Timer? _timer;
  void startTimer() {
    _counter = 60;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_counter > 0) ? _counter-- : _timer!.cancel();
      //});
      print(_counter);
      events.sink.add(_counter);
    });
  }

  // -- otpReSend functionality end here -- //

  @override
  void initState() {
    directBillingCustomerNumberResponseBloc
        .add(GetDirectBillingCategoryEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    events.close();
    _timer!.cancel();
    _counter = 0;
    nameController.clear();
    lastnameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DirectBillingCustomerNumberResponseBloc>(
      create: (context) => directBillingCustomerNumberResponseBloc,
      child: BlocConsumer<DirectBillingCustomerNumberResponseBloc,
          DirectBillingCustomerNumberResponseState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("direct_billing_key".tr(),
                    style: TextStyle(fontWeight: FontWeight.w600)),
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
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 14, right: 14, top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              child: Image.asset("assets/images/point.png",
                                  width: 24)),
                          mobileController.text.length == 10
                              ? Text(
                                  " $coins",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: ColorPrimary),
                                )
                              : Text(
                                  " 0.0",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: ColorPrimary),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Column(
                        children: [
                          TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.number,
                              validator: (numb) =>
                                  Validator.validateMobile(numb!, context),
                              style: TextStyle(
                                  color: TextBlackLight, fontSize: 16),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 10,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 12),
                                hintText:
                                    'enter_customer_phone_number_key'.tr(),
                                hintStyle: TextStyle(
                                    color: TextBlackLight, fontSize: 16),
                                labelText: 'mobile_number_key'.tr(),
                                labelStyle: TextStyle(
                                    color: TextBlackLight, fontSize: 16),
                                counterText: "",
                                contentPadding: EdgeInsets.all(0),
                                fillColor: Colors.transparent,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: textFieldBorderColor,
                                        width: 1.5)),
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
                                      GetDirectBillingCustomerNumberResponseEvent(
                                          mobile: mobileController.text));
                                }
                                if (mobileController.text.length == 9) {
                                  nameController.clear();
                                  lastnameController.clear();
                                  directBillingCustomerNumberResponseBloc.add(
                                      GetDirectBillingCustomerNumberResponseEvent(
                                          mobile: mobileController.text));
                                }
                              }),
                          status1 == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                      controller: nameController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            Validator.name)
                                      ],
                                      style: TextStyle(
                                          color: TextBlackLight, fontSize: 16),
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(fontSize: 12),
                                        hintText:
                                            'enter_customer_first_name_key'
                                                .tr(),
                                        hintStyle: TextStyle(
                                            color: TextBlackLight,
                                            fontSize: 16),
                                        labelText: 'first_name_key'.tr(),
                                        labelStyle: TextStyle(
                                            color: TextBlackLight,
                                            fontSize: 16),
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(0),
                                        fillColor: Colors.transparent,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: textFieldBorderColor,
                                                width: 1.5)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorPrimary,
                                                width: 1.5)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorPrimary,
                                                width: 1.5)),
                                      ),
                                      onChanged: (length) {
                                        firstname = nameController.text;
                                        // if (name.text.length == 10) {
                                        //   directBillingCustomerNumberResponseBloc.add(
                                        //       GetDirectBillingCustomerNumberResponseEvent(
                                        //           mobile: mobileController.text));
                                        // }
                                      }),
                                )
                              : Container(),

                          /// add this field if last name api added
                          status1 == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                      controller: lastnameController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            Validator.name)
                                      ],
                                      style: TextStyle(
                                          color: TextBlackLight, fontSize: 16),
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(fontSize: 12),
                                        hintText:
                                            'enter_customer_last_name_key'.tr(),
                                        hintStyle: TextStyle(
                                            color: TextBlackLight,
                                            fontSize: 16),
                                        labelText: 'last_name_key'.tr(),
                                        labelStyle: TextStyle(
                                            color: TextBlackLight,
                                            fontSize: 16),
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(0),
                                        fillColor: Colors.transparent,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: textFieldBorderColor,
                                                width: 1.5)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorPrimary,
                                                width: 1.5)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorPrimary,
                                                width: 1.5)),
                                      ),
                                      onChanged: (length) {
                                        // firstname = nameController.text;
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
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(color: TextBlackLight, fontSize: 16),
                          maxLength: 10,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 12),
                            hintText: 'amount_spent_here_key'.tr(),
                            hintStyle:
                                TextStyle(color: TextBlackLight, fontSize: 16),
                            labelText: 'amount_key'.tr(),
                            labelStyle:
                                TextStyle(color: TextBlackLight, fontSize: 16),
                            counterText: "",
                            contentPadding: EdgeInsets.all(0),
                            fillColor: Colors.transparent,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: textFieldBorderColor, width: 1.5)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorPrimary, width: 1.5)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorPrimary, width: 1.5)),
                          ),
                          onChanged: (length) {
                            log("$status1  ===>");
                            if (length.isEmpty) {
                              log("if$length");
                              log("if$coins");
                              coinss = 0.0.toString();
                              amount = 0.0.toString();
                              earningCoins = 0.0.toString();
                              redeem = false;
                            } else {
                              log("else$length");
                              calculation(length);
                              calculateEarnCoins(double.parse(length));
                            }
                            setState(() {});
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<DirectBillingCustomerNumberResponseBloc,
                        DirectBillingCustomerNumberResponseState>(
                      listener: (context, state) {
                        if (state
                            is GetDirectBillingCustomerNumberResponseState) {
                          coins = state.data.toString();
                          status1 = state.status;
                          nameController.clear();
                          lastnameController.clear();
                          firstname = state.firstName;
                        }
                        if (state
                            is GetDirectBillingCustomerNumberResponseFailureState) {
                          coins = "0.0";
                          message = state.message;
                          status = state.succes;
                          status1 = state.status;
                          firstname = "";
                        }
                        if (state is GetDirectBillingState) {
                          message = state.message;
                          status = state.succes;
                          datas = state.data;
                          isResendOTPpage = true;
                          startTimer();
                          _displayDialog(context, mobileController.text);
                        }
                        if (state is GetDirectBillingFailureState) {
                          message = state.message;
                          log("failure state");
                          Utility.showToast(
                            msg: state.message,
                          );
                        }
                        if (state is GetDirectBillingOtpState) {
                          Navigator.pop(context);
                          Utility.showToast(msg: state.message);
                          datas!.remainingOrdAmt == "0"
                              ? _displayCumulative(
                                      context,
                                      datas!.remainingOrdAmt,
                                      datas!.freeGiftName)
                                  .then((value) {
                                  int.parse(datas!.qrCodeStatus) == 0
                                      ? _displayDialogs(
                                          context, datas!.earningCoins, 0, "")
                                      : _displayDialogs(context,
                                          datas!.earningCoins, 1, datas);
                                })
                              : int.parse(datas!.qrCodeStatus) == 0
                                  ? _displayDialogs(
                                      context, datas!.earningCoins, 0, "")
                                  : _displayDialogs(
                                      context, datas!.earningCoins, 1, datas);
                        }
                        if (state is GetDirectBillingOtpFailureState) {
                          Utility.showToast(msg: state.message);
                        }
                        if (state is ResendOtpDirectBillingState) {
                          startTimer();
                          if (state.succes) {
                            Utility.showToast(
                                msg: "otp_resend_successfully".tr());
                          } else {
                            Utility.showToast(msg: state.message);
                          }
                        }
                        if (state is GetDirectBillingPartialUserState) {
                          succes = state.succes;
                          directBilling(context);
                        }
                        if (state is GetDirectBillingPartialUserFailureState) {
                          succes = state.succes;
                        }
                        if (state is DirectBillingCheckBoxState) {
                          categoryList[state.index].isChecked = state.isChecked;

                          categoryList[state.index].onTileTap = state.isChecked;
                          if (state.isChecked) {
                            categoryIdList.add(categoryList[state.index].id);
                          } else {
                            categoryIdList.remove(categoryList[state.index].id);
                          }
                          log("List of Selected Category ${categoryIdList.join(',')}");
                        }
                        if (state is DirectBillingRedeemCheckBoxState) {
                          redeem = false;
                          categoryList.forEach((element) {
                            if (element.isChecked == true) {
                              redeem = true;
                            }
                          });
                          if (mobileController.text.length == 10) {
                            if (amountController.text.length > 0) {
                              if (double.parse(coins) >= 3) {
                                calculation(amountController.text);
                                calculateEarnCoins(
                                    double.parse(amountController.text));
                                redeem = state.isChecked;
                              } else {
                                Utility.showToast(
                                    msg: "You_dont_have_enough_coins_key".tr());
                              }
                            } else {
                              Utility.showToast(
                                msg: "please_enter_amount_key".tr(),
                              );
                            }
                          } else {
                            Utility.showToast(
                                msg: "please_enter_10_digits_number_key".tr());
                          }
                          if (redeem == true) {
                            if (mobileController.text.length == 10) {
                              if (amountController.text.length > 0) {
                                if (double.parse(coins) >= 3) {
                                  redeemDialog(context);
                                }
                              } else {
                                Utility.showToast(
                                  msg: "please_enter_amount_key".tr(),
                                );
                              }
                            } else {
                              Utility.showToast(
                                  msg:
                                      "please_enter_10_digits_number_key".tr());
                            }
                          }
                          calculation(amountController.text.isEmpty
                              ? "0"
                              : amountController.text);
                          calculateEarnCoins(double.parse(
                              amountController.text.isEmpty
                                  ? "0"
                                  : amountController.text));
                        }
                      },
                      builder: (context, state) {
                        if (state
                            is GetDirectBillingCustomerNumberResponseState) {
                          status1 = state.status;
                          coins = state.data.toString();
                        }
                        if (state is GetDirectBillingLoadingstate) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorPrimary,
                                ),
                              ));
                        }
                        if (state is GetDirectBillingCategoryByVendorIdState) {
                          if (widget.usertype == 3) {
                            categoryList = state.data;
                            categoryList
                                .removeWhere((element) => element.id == "11");
                            categoryList
                                .removeWhere((element) => element.id == "41");
                          } else {
                            categoryList = state.data;
                          }
                        }
                        return Container(
                          height: 225,
                          width: MediaQuery.of(context).size.width,
                          child: categoryList.isNotEmpty
                              ? ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: categoryList.length,
                                  itemBuilder: (context, index) {
                                    if (categoryList.isNotEmpty) {
                                      if (categoryList.length == 1) {
                                        categoryList[index].isChecked = true;
                                        if (!categoryIdList
                                            .contains(categoryList[index].id)) {
                                          categoryIdList
                                              .add(categoryList[index].id);
                                        }
                                      }
                                    }
                                    var list = categoryList[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 14,
                                          right: 14),
                                      child: Container(
                                        height: 55,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: .5),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: Offset(0.0, 0.0), //(x,y)
                                              blurRadius: 7.0,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: InkWell(
                                            onTap: () {
                                              if (categoryList[index]
                                                      .onTileTap ==
                                                  false) {
                                                directBillingCustomerNumberResponseBloc
                                                    .add(
                                                        GetDirectBillingCheckBoxEvent(
                                                            index: index,
                                                            isChecked: true));
                                              }
                                              if (categoryList[index]
                                                      .onTileTap ==
                                                  true) {
                                                directBillingCustomerNumberResponseBloc
                                                    .add(
                                                        GetDirectBillingCheckBoxEvent(
                                                            index: index,
                                                            isChecked: false));
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.network(
                                                      list.image!,
                                                      width: 20,
                                                      height: 20,
                                                      color: ColorPrimary,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    SizedBox(
                                                      width: 14,
                                                    ),
                                                    Text(
                                                      list.categoryName!,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: TextBlackLight,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Checkbox(
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    value: list.isChecked,
                                                    checkColor: Colors.white,
                                                    activeColor: ColorPrimary,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2)),
                                                    side:
                                                        BorderSide(width: 1.5),
                                                    onChanged: (isCheck) {
                                                      directBillingCustomerNumberResponseBloc.add(
                                                          GetDirectBillingCheckBoxEvent(
                                                              index: index,
                                                              isChecked:
                                                                  isCheck!));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : succes == true
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: ColorPrimary,
                                      ),
                                    )
                                  : Container(),
                        );
                      },
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () {
                          if (double.parse(coins) >= 3) {
                            FocusScope.of(context).unfocus();
                            if (redeem == false) {
                              directBillingCustomerNumberResponseBloc.add(
                                  GetDirectBillingRedeemCheckBoxEvent(
                                      isChecked: true));
                            }
                            if (redeem == true) {
                              directBillingCustomerNumberResponseBloc.add(
                                  GetDirectBillingRedeemCheckBoxEvent(
                                      isChecked: false));
                            }
                          } else {
                            Utility.showToast(
                                msg: "You_dont_have_enough_coins_key".tr());
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "  " + "redeem_coins_key".tr(),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: ColorTextPrimary,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: this.redeem,
                                    checkColor: Colors.white,
                                    activeColor: ColorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    side: BorderSide(width: 1.5),
                                    onChanged: (redeems) {
                                      FocusScope.of(context).unfocus();
                                      if (double.parse(coins) >= 3) {
                                        if (redeem == false) {
                                          directBillingCustomerNumberResponseBloc
                                              .add(
                                                  GetDirectBillingRedeemCheckBoxEvent(
                                                      isChecked: true));
                                        }
                                        if (redeem == true) {
                                          directBillingCustomerNumberResponseBloc
                                              .add(
                                                  GetDirectBillingRedeemCheckBoxEvent(
                                                      isChecked: false));
                                        }
                                      } else {
                                        Utility.showToast(
                                            msg:
                                                "You_dont_have_enough_coins_key"
                                                    .tr());
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
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
                                style: TextStyle(
                                    color: TextBlackLight,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text("\u20B9",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Text(
                                      "${amountController.text.isEmpty ? 0.0 : amountController.text}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
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
                                style: TextStyle(
                                    color: TextBlackLight,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(children: [
                                Text("(",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Container(
                                    child: Image.asset(
                                  "assets/images/point.png",
                                  scale: 3,
                                )),
                                Text("$coinss)",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text(
                                    " \u20B9${(double.parse(coinss) / 3).toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
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
                                style: TextStyle(
                                    color: TextBlackLight,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(children: [
                                Container(
                                    child: Image.asset(
                                  "assets/images/point.png",
                                  scale: 3,
                                )),
                                Text(" $earningCoins",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ]),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "net_payable_key".tr(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPrimary),
                              ),
                              Row(
                                children: [
                                  Text("\u20B9",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: ColorPrimary)),
                                  Text("$amount",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: ColorPrimary)),
                                ],
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
            bottomNavigationBar: IntrinsicHeight(
              child: Container(
                height: 50,
                // margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(color: ColorPrimary),
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  onPressed: () async {
                    checkbox = false;
                    categoryList.forEach((element) {
                      if (element.isChecked == true) {
                        checkbox = true;
                      }
                    });
                    if (status1 == 0) {
                      if (mobileController.text.length == 10) {
                        if (amountController.text.length > 0) {
                          if (nameController.text.trim().length >= 3) {
                            if (lastnameController.text.trim().length >= 3) {
                              if (checkbox == true) {
                                directBilling(context);
                                //   userRegister(context);
                              } else {
                                Utility.showToast(
                                    msg: "Please select category".tr());
                              }
                            } else {
                              Utility.showToast(msg: "last_name_excp_key".tr());
                            }
                          } else {
                            Utility.showToast(
                              msg: "first_name_excp_key".tr(),
                            );
                          }
                        } else {
                          Utility.showToast(
                              msg: "please_enter_amount_key".tr());
                        }
                      } else {
                        Utility.showToast(
                            msg: "please_enter_10_digits_number_key".tr());
                      }
                    } else {
                      if (mobileController.text.length == 10) {
                        if (amountController.text.length > 0) {
                          if (checkbox == true) {
                            directBilling(context);
                          } else {
                            Utility.showToast(
                                msg: "Please select category".tr());
                          }
                        } else {
                          Utility.showToast(
                              msg: "please_enter_amount_key".tr());
                        }
                      } else {
                        Utility.showToast(
                          msg: "please_enter_10_digits_number_key".tr(),
                        );
                      }
                    }
                  },
                  child: Text("submit_button_key".tr(),
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
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
        amount = 0.0.toString();
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
      coinss = 0.0.toString();
      amount = length.toString();
    }
  }

  Future<void> directBilling(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["mobile"] = mobileController.text;
    input["bill_amount"] = amountController.text;
    input["full_name"] =
        nameController.text.trim() + " " + lastnameController.text.trim();
    input['first_name'] = nameController.text.trim();
    input['last_name'] = lastnameController.text.trim();
    input["vendor_id"] =
        await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["total_pay"] = amount;
    input["coin_deducted"] = coinss;
    input["category_id"] = categoryIdList.join(',');

    log("=====? $input");
    if (isResendOTPpage) {
      directBillingCustomerNumberResponseBloc
          .add(ResendOtpDirectBillingEvent(input: input));
    } else {
      directBillingCustomerNumberResponseBloc
          .add(GetDirectBillingEvent(input: input));
    }
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
    input["myprofit_revenue"] = datas!.myprofitRevenue;
    SharedPref.setStringPreference(
        SharedPref.VendorCoin, datas!.vendorAvailableCoins);
    log("VendorCoin------->${datas!.vendorAvailableCoins}");
    input["vendor_available_coins"] = datas!.vendorAvailableCoins;

    log("=====? $input");

    directBillingCustomerNumberResponseBloc
        .add(GetDirectBillingOtpEvent(input: input));
  }

  _displayDialog(BuildContext context, mobile) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StreamBuilder<int>(
              stream: events.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return WillPopScope(
                  onWillPop: () async {
                    if (_counter > 0) {
                      Utility.showToast(
                          msg: "try_after".tr() +
                              " $_counter " +
                              "seconds".tr() +
                              " " +
                              "try_after_hi".tr());
                      return Future.value(false);
                    } else {
                      isResendOTPpage = false;
                      return Future.value(true);
                    }
                  },
                  child: AlertDialog(
                    titlePadding: const EdgeInsets.only(
                        left: 18, right: 18, top: 10, bottom: 10),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    actionsPadding: const EdgeInsets.only(
                        left: 12, right: 12, top: 0, bottom: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    // insetPadding: const EdgeInsets.all(10),
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
                      maxLength: 4,
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
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 14, top: 8, bottom: 8),
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
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: MaterialButton(
                              height: 50,
                              textColor: Colors.white,
                              color: ColorPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                if (otpController.text.length == 4) {
                                  if (status == 0) {
                                    // directBillingCustomerNumberResponseBloc.add((
                                    //     price: y, index: index, earningCoin: earningCoin));
                                    otpController.clear();
                                    Navigator.pop(context);
                                  } else {
                                    verifyOtp(context);
                                  }
                                } else {
                                  Utility.showToast(
                                    msg: "please enter 4 digit otp",
                                  );
                                }
                              },
                              child: new Text(
                                "submit_button_key".tr(),
                                style: GoogleFonts.openSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            //  width: MediaQuery.of(context).size.width,
                            child: snapshot.data! > 0
                                ? Text(
                                    "resend_OTP_after".tr() +
                                        " " +
                                        "${snapshot.data.toString()} " +
                                        "seconds".tr(),
                                    style: GoogleFonts.openSans(
                                        color: ColorTextPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.none),
                                  )
                                : TextButton(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero),
                                    onPressed: () async {
                                      if (mobile.length == 10) {
                                        if (await Network.isConnected()) {
                                          directBilling(context);
                                        } else {
                                          Utility.showToast(
                                            msg:
                                                "please_check_your_internet_connection_key"
                                                    .tr(),
                                          );
                                        }
                                      } else {
                                        Utility.showToast(
                                          msg: "please_atleast_one_product_key"
                                              .tr(),
                                        );
                                      }
                                    },
                                    child: new Text(
                                      "otp_resend".tr(),
                                      style: GoogleFonts.openSans(
                                          color: ColorPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              });
        }).then((value) => otpController.clear());
  }

  _displayDialogs(BuildContext context, hintText, status, data) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: AlertDialog(
              titlePadding: const EdgeInsets.all(20),
              actionsPadding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              contentPadding: const EdgeInsets.only(left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                        height: 35,
                        width: 35,
                      ),
                      Text(
                        " ${double.parse(hintText).toStringAsFixed(2)} ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 38,
                          color: ColorPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                    Text(
                        "${"coin_generated_successfully_key".tr()}\n ${"in_customer_wallet_key".tr()}",
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
                    textColor: Colors.white,
                    color: ColorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      status == 0
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Scanner(data: data!)))
                          : Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  child: BottomNavigationHome(),
                                  type: PageTransitionType.fade),
                              ModalRoute.withName("/"));
                    },
                    child: new Text(
                      "done_key".tr(),
                      style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void calculateEarnCoins(double amount) async {
    if (amount.toString().isNotEmpty) {
      double commission = double.parse(categoryList.first.commission);
      String freeCoins =
          await SharedPref.getStringPreference(SharedPref.VendorCoin);
      log("VendorCoin------->$freeCoins");
      amount = (amount * commission) / 100;
      //amount = double.parse(freeCoins) != 0 ? amount : amount - (amount * 18) / 100;
      log("commision--->$commission");

      amount = amount / 2;
      amount = amount * 3;
      amount = amount < 0 ? 0 : amount;
      log("amount---->$amount");
      earningCoins = amount.toStringAsFixed(2);
    } else {
      earningCoins = "0.0";
    }
  }

  _displayCumulative(BuildContext context, remainingAmount, giftName) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: AlertDialog(
              titlePadding: const EdgeInsets.all(20),
              actionsPadding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              contentPadding: const EdgeInsets.only(left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/otp-wallet.png",
                      fit: BoxFit.cover,
                      height: 70,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${datas!.remainingOrdAmt}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 17.0,
                          color: ColorTextPrimary,
                          fontWeight: FontWeight.w600,
                        )),
                    Text(
                        "${"amount_remaining_key".tr()} ${datas!.freeGiftName} ${"amount_remaining_gift_key".tr()}",
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text(
                      "done_key".tr(),
                      style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
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
            actionsPadding: const EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      "${"hooray_you_saved".tr()} $firstname ${"saved_key".tr()}",
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      " \u20B9${(double.parse(coinss) / 3).toStringAsFixed(2)}",
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorPrimary),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                    "redeem_popup_button_key".tr(),
                    style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

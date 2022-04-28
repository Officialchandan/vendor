import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_bloc.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_event.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_state.dart';
import 'package:vendor/ui/inventory/sale_return/sale_return_product_details.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class SaleReturnScreen extends StatefulWidget {
  @override
  _SaleReturnScreenState createState() => _SaleReturnScreenState();
}

class _SaleReturnScreenState extends State<SaleReturnScreen> {
  TextEditingController edtMobile = TextEditingController();
  TextEditingController edtProducts = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController edtReason = TextEditingController();
  List<SaleReturnProducts> purchasedList = [];
  List<SaleReturnProducts> returnProductList = [];

  SaleReturnBloc saleReturnBloc = SaleReturnBloc();
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaleReturnBloc>(
      create: (context) => saleReturnBloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "sale_return_key".tr(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: edtMobile,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                  maxLength: 10,
                  onChanged: (text) {
                    if (text.trim().length == 10) {
                      FocusScope.of(context).unfocus();
                      getProducts(text);
                    }
                    if (text.length == 9) {
                      purchasedList = [];
                      saleReturnBloc
                          .add(SaleReturnClearDataEvent(message: "enter_mobile_to_get_purchase_product".tr()));
                    }
                  },
                  // autofocus: true,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(counterText: "",  hintText: 'enter_customer_phone_number_key'.tr(),
                    hintStyle: TextStyle(color: TextBlackLight, fontSize: 16),
                    labelText: 'mobile_number_key'.tr(),
                    labelStyle: TextStyle(color: TextBlackLight, fontSize: 16),
                    enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 1.5)),
                    focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                  ),
                ),
              ),
              BlocConsumer<SaleReturnBloc, SaleReturnState>(
                listener: (context, state) {
                  if (state is ProductReturnSuccessState) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaleReturnProductDetails(saleReturnData: state.data))).then((value) {
                      if (value != null) {
                        // returnProductList.clear();
                        // purchasedList.removeWhere((element) => element.orderId == value);
                        getProducts(edtMobile.text.toString());
                      }
                    });
                    // displayDialog(context, state.input);
                  }

                  if (state is VerifyOtpSuccessState) {
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => SaleReturnScreen()),
                    //     (route) => false);
                    Navigator.pop(context);
                    Utility.showToast(msg: state.message);
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  if (state is GetProductSuccessState) {
                    purchasedList = state.purchaseList;
                  }

                  if (state is SaleReturnLoadingState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is GetProductFailureState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Center(
                        child: Text(state.message),
                      ),
                    );
                  }

                  if (state is SaleReturnQtyIncrementState) {
                    purchasedList[state.index].returnQty += state.count;
                  }

                  if (state is SaleReturnQtyDecrementState) {
                    purchasedList[state.index].returnQty -= state.count;
                  }

                  if (state is SaleReturnCheckBoxState) {
                    if (state.isChecked == true) {
                      purchasedList.forEach((element) {
                        element.checked = false;
                      });
                      returnProductList.clear();
                      purchasedList[state.index].checked = state.isChecked;
                      returnProductList.add(purchasedList[state.index]);
                    }
                    if (state.isChecked == false) {
                      purchasedList[state.index].checked = state.isChecked;
                      returnProductList.remove(purchasedList[state.index]);
                    }
                  }

                  if (state is SaleReturnClearDataState) {
                    return Center(
                      child: Text(state.message),
                    );
                  }

                  if (purchasedList.isEmpty) {
                    return Center(
                      child: Text("enter_mobile_to_get_purchase_product".tr()),
                    );
                  }

                  return Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 14, top: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "select_return_product_key".tr(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.70,
                          child: ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 50),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        offset: Offset(0.0, 0.0), //(x,y)
                                        blurRadius:7.0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: purchasedList[index].productImages.isNotEmpty
                                                ? Image(
                                                    height: 65,
                                                    width: 65,
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(purchasedList[index].productImages),
                                                  )
                                                : Image(
                                                    image: AssetImage(
                                                      "assets/images/placeholder.webp",
                                                    ),
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.70,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width * 0.45,
                                                          child: Text(
                                                            purchasedList[index].productName,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: TextBlackLight,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "₹ ${purchasedList[index].price == "0" ? purchasedList[index].total : purchasedList[index].price}\t" +
                                                                        " ",
                                                                style: TextStyle(
                                                                    color: ColorPrimary,
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                      child: Text(
                                                        DateFormat("dd MMM").format(
                                                                DateTime.parse(purchasedList[index].dateTime)) +
                                                            " " +
                                                            DateFormat.jm()
                                                                .format(
                                                                    DateTime.parse(purchasedList[index].dateTime))
                                                                .toLowerCase(),
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold,
                                                            color: TextBlackLight),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    purchasedList[index].checked != true
                                                        ? InkWell(
                                                            onTap: () async {
                                                              if (await Network.isConnected()) {
                                                                saleReturnBloc.add(SaleReturnCheckBoxEvent(
                                                                    isChecked: true, index: index));
                                                              } else {
                                                                Utility.showToast(
                                                                  msg: "please_check_your_internet_connection_key"
                                                                      .tr(),
                                                                );
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 25,
                                                              width: 71,
                                                              decoration: BoxDecoration(
                                                                  color: Buttonactive,
                                                                  borderRadius: BorderRadius.circular(25),
                                                                  border: Border.all(color: ColorPrimary)),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "add_key".tr(),
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: ColorPrimary),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Icon(
                                                                      Icons.add,
                                                                      size: 18,
                                                                      color: ColorPrimary,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(25),
                                                                border: Border.all(color: ColorPrimary)),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Container(
                                                                  width: 23,
                                                                  child: IconButton(
                                                                      padding: EdgeInsets.all(0),
                                                                      onPressed: () {
                                                                        saleReturnBloc.add(
                                                                          SaleReturnQtyDecrementEvent(
                                                                              count: 1, index: index),
                                                                        );

                                                                        if (purchasedList[index].returnQty <= 1) {
                                                                          saleReturnBloc.add(
                                                                              SaleReturnCheckBoxEvent(
                                                                                  isChecked: false, index: index));
                                                                        }
                                                                      },
                                                                      iconSize: 20,
                                                                      splashRadius: 10,
                                                                      icon: Icon(
                                                                        Icons.remove,
                                                                      )),
                                                                ),
                                                                Container(
                                                                  width: 23,
                                                                  color: ColorPrimary,
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${purchasedList[index].returnQty.toString()}",
                                                                      style: TextStyle(
                                                                          color: Colors.white, fontSize: 14),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 23,
                                                                  child: IconButton(
                                                                    padding: EdgeInsets.all(0),
                                                                    onPressed: () {
                                                                      if (purchasedList[index].returnQty <
                                                                          purchasedList[index].qty) {
                                                                        saleReturnBloc.add(
                                                                            SaleReturnQtyIncrementEvent(
                                                                                count: 1, index: index));
                                                                      } else {
                                                                        Utility.showToast(
                                                                            msg:
                                                                                "you_cant_return_more_then_quantity_key"
                                                                                    .tr());
                                                                      }
                                                                    },
                                                                    iconSize: 20,
                                                                    splashRadius: 10,
                                                                    icon: Icon(
                                                                      Icons.add,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    purchasedList[index].categoryName.isNotEmpty
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                                color: DirectBillTextBgColor,
                                                                borderRadius: BorderRadius.circular(20)),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2),
                                                              child: Text(
                                                                "  ${"direct_billing_key".tr()}  ",
                                                                style: TextStyle(
                                                                    fontSize: 11, color: DirectBillingTextColor),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(
                                                      height: 18,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Container();
                              },
                              itemCount: purchasedList.length),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: ColorPrimary,
            child: MaterialButton(
              shape: RoundedRectangleBorder(),
              onPressed: () async {
                if (await Network.isConnected()) {
                  edtMobile.text.length == 10
                      ? submit()
                      : Utility.showToast(msg: "please_enter_valid_mobile_number_key".tr());
                } else {
                  Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);

                  // EasyLoading.showError(Constant.INTERNET_ALERT_MSG);
                }
              },
              child: Text(
                "done_key".tr(),
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submit() async {
    if (returnProductList.isEmpty) {
      Utility.showToast(msg: "Please select product to be return!");
    } else {
      String productId = "";
      String orderId = "";
      String qty = "";

      for (int i = 0; i < returnProductList.length; i++) {
        if (i == returnProductList.length - 1) {
          productId += returnProductList[i].productId.toString();
          orderId += returnProductList[i].orderId.toString();
          qty += returnProductList[i].returnQty.toString();
        } else {
          productId += returnProductList[i].productId.toString() + ",";
          qty += returnProductList[i].returnQty.toString() + ",";
        }
      }

      Map input = HashMap<String, dynamic>();
      input["mobile"] = edtMobile.text.trim();
      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      input["product_id"] = productId;
      input["order_id"] = orderId;
      input["qty"] = qty;
      input["reason"] = edtReason.text.trim();
      saleReturnBloc.add(SaleReturnApiEvent(input: input));
    }
  }

  displayDialog(BuildContext context, Map input) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: RichText(
                text: TextSpan(
                  text: "otp_verification_key".tr(),
                  style: GoogleFonts.openSans(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "please_verify_your_otp_on_key".tr() + "${input["mobile"]}",
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
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
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
                        input["otp"] = _textFieldController.text.trim();
                        saleReturnBloc.add(VerifyOtpEvent(input: input));
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

  getProducts(String mobile) async {
    Map<String, dynamic> input = HashMap();
    input["mobile"] = mobile;
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    saleReturnBloc.add(GetPurchasedProductEvent(input: input));
  }
}

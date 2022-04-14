import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/model/verify_otp.dart';
import 'package:vendor/ui/billingflow/Scanner/scanner.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_bloc.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_event.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_state.dart';
import 'package:vendor/ui/home/bottom_navigation_home.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';

class BillingProducts extends StatefulWidget {
  final List<ProductModel> billingItemList;

  BillingProducts({required this.billingItemList, required this.mobile, required this.coin});

  final List<ProductModel> searchList = [];
  final coin;
  final mobile;

  @override
  _BillingProductsState createState() => _BillingProductsState(this.billingItemList, this.mobile, this.coin);
}

class _BillingProductsState extends State<BillingProducts> {
  _BillingProductsState(List<ProductModel> billingItemList, mobile, coin);
  VerifyEarningCoinsOtpData? passing;
  ProductModel? selectedProductList;
  List<ProductModel> productList = [];
  List index = [];
  BillingProductData? otpVerifyList;
  TextEditingController _textFieldController = TextEditingController();
  BillingProductsBloc billingProductsBloc = BillingProductsBloc();

  @override
  void initState() {
    productList.addAll(widget.billingItemList);
    billingProductsBloc.add(TotalPayAmountBillingProductsEvent(mrp: totalPay));

    super.initState();
  }

  _DialogState d = _DialogState();

  double totalPay = 0;

  //double redeem = 0;
  double redeemCoins = 0;

  //double redeemCoinss = 0;
  double earnCoins = 0;

  //double customerCoins = 0;

  double x = 0.0;
  var message;
  var status;
  var codes;
  String freecoins = "0.0";
  Future<double> earningPrice(double price, double comission, int qty) async {
    freecoins = await SharedPref.getStringPreference(SharedPref.VendorCoin);
    log("frecoins---->$freecoins");
    x = price;
    log("1=$x");
    x = (x * comission) / 100;
    log("2=$x");
    x = double.parse(freecoins) != 0 ? x : x - (x * 18) / 100;
    log("3=$x");
    x = x - 0.50;
    log("4=$x");
    x = x / 2;
    log("5=$x");
    x = x * 3;
    log("6=$x");
    x = x / qty;
    x = x < 0 ? 0 : x;
    return x;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocProvider<BillingProductsBloc>(
      create: (context) => billingProductsBloc,
      child: BlocListener<BillingProductsBloc, BillingProductsState>(
        listener: (context, state) {
          print("state-->$state");
          if (state is DeleteBillingProductState) {
            productList.remove(productList[state.index]);
            calculateAmounts(productList);
            index.add(state.index);
            // widget.billingItemList[state.index].check = false;
          }
          if (state is CheckerBillingProductstate) {
            productList[state.index].billingcheck = state.check;
            // if (productList[state.index].billingcheck) {
            //   widget.coin -= double.parse(productList[state.index].redeemCoins);
            // } else {
            //   widget.coin += double.parse(productList[state.index].redeemCoins);
            // }
            calculateAmounts(productList);
          }
          if (state is EditBillingProductState) {
            productList[state.index].sellingPrice = ((state.price) / productList[state.index].count).toStringAsFixed(2);

            productList[state.index].earningCoins = state.earningCoin.toStringAsFixed(2);
            print("productList[state.index].sellingPrice-->${productList[state.index].sellingPrice}");
            productList[state.index].earningCoins = state.earningCoin.toStringAsFixed(2);

            calculateAmounts(productList);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 30,
            leading: IconButton(
                onPressed: () {
                  //log("===>${index[0]}");
                  Navigator.pop(context, index);
                },
                icon: Icon(Icons.arrow_back_ios)),
            centerTitle: false,
            title: Text(
              "billing_products_key".tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
            actions: [
              Row(children: [
                Container(
                  height: 18,
                  width: 18,
                  child: Image.asset("assets/images/point.png"),
                ),
                BlocBuilder<BillingProductsBloc, BillingProductsState>(
                  builder: (context, state) {
                    if (state is IntitalBillingProductstate) {
                      calculateAmounts(productList);
                    }
                    return Text(" ${widget.coin.toStringAsFixed(2)} ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ));
                  },
                ),
              ]),
            ],
          ),
          body: BlocBuilder<BillingProductsBloc, BillingProductsState>(builder: (context, state) {
            if (state is IntitalBillingProductstate) {
              calculateAmounts(productList);
            }
            return ListView.builder(
              //    padding: EdgeInsets.all(10),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                String variantName = "";
                ProductModel product = productList[index];

                if (product.productOption.isNotEmpty) {
                  for (int i = 0; i < product.productOption.length; i++) {
                    if (product.productOption.length - 1 == i)
                      variantName += product.productOption[i].value.toString();
                    else
                      variantName += product.productOption[i].value.toString() + ", ";
                  }
                }

                return Stack(
                  children: [
                    Container(
                      height: 96,
                      margin: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: productList[index].productImages.isNotEmpty
                                        ? Image(
                                            height: 55,
                                            width: 55,
                                            fit: BoxFit.contain,
                                            image: NetworkImage("${productList[index].productImages[0].productImage}"),
                                          )
                                        : Image(
                                            image: AssetImage(
                                              "assets/images/placeholder.webp",
                                            ),
                                            height: 55,
                                            width: 55,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Container(
                                    height: productList[index].productName.length > 15 ? 54 : 48,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.70,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: width * 0.55,
                                                child: variantName.isEmpty
                                                    ? AutoSizeText(
                                                        "${productList[index].productName}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style:
                                                            TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                                        maxFontSize: 15,
                                                        minFontSize: 12,
                                                      )
                                                    : AutoSizeText(
                                                        "${productList[index].productName} ($variantName)",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style:
                                                            TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                                        maxFontSize: 15,
                                                        minFontSize: 12,
                                                      ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 4),
                                                height: 15,
                                                child: AutoSizeText(
                                                  "qty_key".tr() + ": ${productList[index].count}",
                                                  maxLines: 1,
                                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                                  maxFontSize: 11,
                                                  minFontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.70,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  new RichText(
                                                    text: new TextSpan(
                                                      text:
                                                          '\u20B9 ${double.parse(productList[index].sellingPrice) * productList[index].count}  ',
                                                      style:
                                                          TextStyle(fontWeight: FontWeight.bold, color: ColorPrimary),
                                                      // children: <TextSpan>[
                                                      //   new TextSpan(
                                                      //     text:
                                                      //         '\u20B9${double.parse(productList[index].mrp) * productList[index].count}',
                                                      //     style:
                                                      //         new TextStyle(
                                                      //       color:
                                                      //           Colors.grey,
                                                      //       decoration:
                                                      //           TextDecoration
                                                      //               .lineThrough,
                                                      //     ),
                                                      //   ),
                                                      // ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      // i = 0;
                                                      if (await Network.isConnected()) {
                                                        _displayDialog(context, index, 0, "edit_amount_key".tr(),
                                                            "enter_amount_key".tr());
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg: "please_check_your_internet_connection_key".tr(),
                                                            backgroundColor: ColorPrimary);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 16,
                                                      width: 16,
                                                      child: Image.asset("assets/images/edit.png"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  BlocBuilder<BillingProductsBloc, BillingProductsState>(
                                                    builder: (context, state) {
                                                      return SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: Checkbox(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4)),
                                                          side: BorderSide(color: Colors.grey),
                                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                                                          // checkColor: Colors.indigo,
                                                          value: productList[index].billingcheck,
                                                          activeColor: ColorPrimary,
                                                          onChanged: (newvalue) async {
                                                            log("true===>");

                                                            if (double.parse(widget.coin.toString()) >= 3) {
                                                              if (await Network.isConnected()) {
                                                                billingProductsBloc.add(CheckedBillingProductsEvent(
                                                                    check: newvalue!, index: index));
                                                                selectedProductList = productList[index];
                                                              } else {
                                                                Fluttertoast.showToast(
                                                                    msg: "please_check_your_internet_connection_key"
                                                                        .tr(),
                                                                    backgroundColor: ColorPrimary);
                                                              }
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: "You_dont_have_enough_coins".tr(),
                                                                  backgroundColor: ColorPrimary);
                                                            }
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      billingProductsBloc.add(CheckedBillingProductsEvent(
                                                          check:
                                                              productList[index].billingcheck == false ? true : false,
                                                          index: index));
                                                    },
                                                    child: Text(
                                                      "  " + "redeem_key".tr(),
                                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Text(
                                            "redeem_key".tr() + ": ",
                                            style: TextStyle(
                                                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                                          ),
                                          Container(
                                              child: Image.asset(
                                            "assets/images/point.png",
                                            width: 13,
                                            height: 13,
                                          )),
                                          Text(
                                            " ${(double.parse(productList[index].redeemCoins) * productList[index].count).toStringAsFixed(2)}",
                                            style: TextStyle(
                                                fontSize: 12, fontWeight: FontWeight.w600, color: ColorPrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "earn_key".tr() + ": ",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  Container(
                                      child: Image.asset(
                                    "assets/images/point.png",
                                    height: 13,
                                    width: 13,
                                  )),
                                  Text(
                                    " ${(double.parse(productList[index].earningCoins) * productList[index].count).toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ColorPrimary),
                                  ),
                                ],
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 20,
                      child: InkWell(
                        onTap: () async {
                          // i = 0;
                          // totalPay = 0;
                          // earncoins1 -= earncoins1 -
                          //     int.parse(productList[index]
                          //             .earningCoins) *
                          //         2;
                          // reddemcoins1 -= reddemcoins1 -
                          //     int.parse(productList[index]
                          //             .redeemCoins) *
                          //         2;
                          if (await Network.isConnected()) {
                            log("Product Index  >>>>>>>>> " + index.toString());

                            billingProductsBloc.add(DeleteBillingProductsEvent(index: index));
                          } else {
                            Fluttertoast.showToast(
                                msg: "please_check_your_internet_connection_key".tr(), backgroundColor: ColorPrimary);
                          }
                        },
                        child: BlocBuilder<BillingProductsBloc, BillingProductsState>(
                          builder: (context, state) {
                            return Container(
                              height: 20,
                              width: 20,
                              color: Colors.white,
                              child: Image.asset("assets/images/delete.png"),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
          bottomNavigationBar: Container(
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: BlocBuilder<BillingProductsBloc, BillingProductsState>(builder: (context, state) {
                      if (state is IntitalBillingProductstate) {
                        calculateAmounts(productList);
                      }
                      return Container(
                        decoration:
                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                          ),
                        ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 5),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  "total_pay_amount_key".tr(),
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Text("\u20B9 ",
                                        style:
                                            TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ColorPrimary)),
                                    Text("${totalPay.toStringAsFixed(2)}",
                                        style:
                                            TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ColorPrimary)),
                                  ],
                                ),
                              ]),
                            ),
                            // Divider(
                            //   height: 1,
                            //   color: ColorTextPrimary,
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 5),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  "redeem_coins_key".tr(),
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        child: Image.asset(
                                      "assets/images/point.png",
                                      width: 16,
                                      height: 16,
                                    )),
                                    Text(" ${redeemCoins.toStringAsFixed(2)}",
                                        style:
                                            TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ColorPrimary)),
                                  ],
                                ),
                              ]),
                            ),
                            // Divider(
                            //   height: 1,
                            //   color: ColorTextPrimary,
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 15),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  "earn_coins_key".tr(),
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        child: Image.asset(
                                      "assets/images/point.png",
                                      width: 16,
                                      height: 16,
                                    )),
                                    Text(" ${earnCoins.toStringAsFixed(2)}",
                                        style:
                                            TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ColorPrimary)),
                                  ],
                                ),
                              ]),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  BlocConsumer<BillingProductsBloc, BillingProductsState>(
                    listener: (context, state) async {
                      if (state is PayBillingProductsState) {
                        message = state.message;
                        status = state.succes;
                        otpVerifyList = state.data;
                        log("${otpVerifyList!.otp}");
                        _displayDialog(
                          context,
                          0,
                          1,
                          "please_enter_password_key".tr(),
                          "enter_otp_key".tr(),
                        );
                      }
                      if (state is PayBillingProductsStateFailureState) {
                        message = state.message;
                        Fluttertoast.showToast(msg: state.message, backgroundColor: ColorPrimary);
                      }
                      if (state is PayBillingProductsStateLoadingstate) {
                        log("number chl gya");
                      }

                      if (state is VerifyOtpState) {
                        Navigator.pop(context);
                        passing = state.data;
                        Fluttertoast.showToast(msg: state.message, backgroundColor: ColorPrimary);
                        otpVerifyList!.qrCodeStatus == 0
                            ? _displayDialogs(context, passing!.earningCoins, 0, "")
                            : _displayDialogs(context, passing!.earningCoins, 1, passing);
                        //log("-------$result --------");
                        // codes = result;
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => BillingScreen()));
                        // d._displayCoinDialog(context);
                      }
                      if (state is VerifyOtpStateLoadingstate) {
                        log("number chl gya");
                      }
                      if (state is VerifyOtpStateFailureState) {
                        message = state.message;
                        Fluttertoast.showToast(msg: state.message, backgroundColor: ColorPrimary);
                      }
                    },
                    builder: (context, state) {
                      return InkWell(
                        onTap: () async {
                          if (productList.isNotEmpty) {
                            if (await Network.isConnected()) {
                              billingProducts(context).then((value) => _textFieldController.clear());
                            } else {
                              Fluttertoast.showToast(
                                  msg: "please_check_your_internet_connection_key".tr(), backgroundColor: ColorPrimary);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "please_atleast_one_product_key".tr(), backgroundColor: ColorPrimary);
                          }
                        },
                        child: Container(
                          width: width,
                          color: ColorPrimary,
                          child: Center(
                            child: Text(
                              "submit_button_key".tr(),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          height: height * 0.07,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> billingProducts(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["mobile"] = widget.mobile;
    input["address_id"] = "";
    input["payment_method"] = "cash";
    input["payment_code"] = "COD";
    input["total_pay"] = totalPay;
    input["total_redeem"] = redeemCoins;
    input["order_status"] = "0";

    List<Map<String, dynamic>> billingProductList = [];

    double mCoins = widget.coin;

    for (int i = 0; i < productList.length; i++) {
      Map<String, dynamic> billingProduct = Map<String, dynamic>();

      if (productList[i].billingcheck) {
        billingProduct["product_id"] = productList[i].id;
        billingProduct["product_name"] = productList[i].productName;
        billingProduct["qty"] = productList[i].count.toString();
        billingProduct["price"] = productList[i].sellingPrice;
        billingProduct["total"] = double.parse(productList[i].sellingPrice) * productList[i].count;

        if (mCoins >= double.parse(productList[i].redeemCoins)) {
          billingProduct["product_redeem"] = double.parse(productList[i].redeemCoins) * productList[i].count;
          billingProduct["amount_paid"] = 0;
          mCoins = mCoins - (double.parse(productList[i].redeemCoins) * productList[i].count);
        } else {
          billingProduct["product_redeem"] = mCoins.toString();
          double r = (double.parse(productList[i].redeemCoins) * productList[i].count) - mCoins;
          billingProduct["amount_paid"] = r / 3;
          mCoins = 0;
        }

        billingProductList.add(billingProduct);
      } else {
        billingProduct["product_id"] = productList[i].id;
        billingProduct["product_name"] = productList[i].productName;
        billingProduct["qty"] = productList[i].count.toString();
        billingProduct["price"] = productList[i].sellingPrice;
        billingProduct["total"] = double.parse(productList[i].sellingPrice) * productList[i].count;

        billingProduct["product_redeem"] = "0";
        billingProduct["amount_paid"] = double.parse(productList[i].sellingPrice) * productList[i].count;
        billingProductList.add(billingProduct);
      }
    }
    input["product"] = billingProductList;
    log("input=====> $input");
    billingProductsBloc.add(PayBillingProductsEvent(input: input));
  }

  _displayDialog(BuildContext context, index, status, text, hinttext) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                controller: _textFieldController,
                cursorColor: ColorPrimary,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // filled: true,
                  counterText: "",

                  // fillColor: Colors.black,
                  hintText: "$hinttext",

                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      if (status == 0) {
                        if (_textFieldController.text.isNotEmpty) {
                          log("onPressed->$status");
                          // productList[index].sellingPrice = _textFieldController.text;
                          double y = double.parse(_textFieldController.text.trim());
                          log("y->$y");
                          double earningCoin = await earningPrice(
                              y, double.parse(productList[index].commission), productList[index].count);

                          log("index->$index");
                          log("earningCoin->$earningCoin");

                          billingProductsBloc
                              .add(EditBillingProductsEvent(price: y, index: index, earningCoin: earningCoin));

                          Navigator.pop(context);
                          _textFieldController.clear();
                        } else {
                          Fluttertoast.showToast(msg: "please_enter_amount_key".tr(), backgroundColor: ColorPrimary);
                        }
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
                          ? Navigator.push(context, MaterialPageRoute(builder: (context) => Scanner(data: passing!)))
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

  Future<void> verifyOtp(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["mobile"] = widget.mobile;
    input["order_id"] = "${otpVerifyList!.orderId}";
    input["customer_id"] = "${otpVerifyList!.customerId}";
    input["otp"] = "${_textFieldController.text}";
    input["total_pay"] = "${otpVerifyList!.totalPay}";

    input["total_redeem"] = otpVerifyList!.redeemCoins;
    input["total_earning"] = otpVerifyList!.earningCoins;
    input["myprofit_revenue"] = "${otpVerifyList!.myprofitrevenue}";
    input["vendor_available_coins"] = "${otpVerifyList!.vendorAvailableCoins}";

    log("=====? $input");

    billingProductsBloc.add(OtpVerifyEvent(input: input));
  }

  void calculateAmounts(List<ProductModel> productList) {
    totalPay = 0;
    redeemCoins = 0;
    earnCoins = 0;

    double availableCoins = widget.coin;
    double customerCoins = widget.coin;
    double redeemedCoin = 0;

    productList.forEach((product) {
      //redeemedCoin += double.parse(product.redeemCoins);
      product.redeemCoins = (double.parse(product.sellingPrice) * 3).toString();
      if (product.billingcheck) {
        if (availableCoins >= (double.parse(product.redeemCoins) * double.parse(product.count.toString()))) {
          redeemCoins += double.parse(product.redeemCoins) * double.parse(product.count.toString());
          redeemedCoin += double.parse(product.redeemCoins) * double.parse(product.count.toString());
          availableCoins = availableCoins - double.parse(product.redeemCoins) * double.parse(product.count.toString());
        } else {
          double remainingCoin =
              (double.parse(product.redeemCoins) * double.parse(product.count.toString())) - availableCoins;
          log("availableCoins1======>$availableCoins");
          log("customerCoins1=====>$customerCoins");
          log("amount1 ==> $remainingCoin");
          log("customerCoins1=====>$customerCoins");
          double coinToRupee = remainingCoin / 3;
          log("amount1== ==> $remainingCoin");
          log("coinToRupee== ==> $coinToRupee");
          totalPay += coinToRupee;
          redeemedCoin += availableCoins;
          redeemCoins += availableCoins;
          availableCoins = 0;
        }
      } else {
        totalPay += double.parse(product.sellingPrice) * product.count;
        log("yha mai aya hu $totalPay");
      }

      log("=====>product.earningCoins${double.parse(product.earningCoins)}");
      log("=====>product.count2${product.count}");
      earnCoins += double.parse(product.earningCoins) * product.count;
      log("---earnCoins$earnCoins");
      log("---totalpay --> $totalPay");
      log("---redeemCoins --> $redeemCoins");
    });
  }

  void calculateAmounts1(List<ProductModel> productList) {
    totalPay = 0;
    redeemCoins = 0;
    earnCoins = 0;

    double availableCoins = widget.coin;
    double customerCoins = widget.coin;
    double redeemedCoin = 0;
    double partialcoin = 0;
    double partialamount = 0;

    productList.forEach((product) {
      log("=====>sellingPrice${double.parse(product.sellingPrice)}");
      log("=====>product.count${product.count}");
      log("---totalPay$totalPay");
      log("=====>redeemCoins==>${double.parse(product.redeemCoins)}");
      //redeemedCoin += double.parse(product.redeemCoins);
      // log("=====>redeemCoinss==>$redeemedCoin");
      //log("=====>product.count${product.count}");
      product.redeemCoins = (double.parse(product.sellingPrice) * 3).toString();

      //log("=====>product.redeemCoins${product.redeemCoins}");
      if (product.billingcheck) {
        if (availableCoins >= (double.parse(product.redeemCoins) * double.parse(product.count.toString()))) {
          redeemCoins += double.parse(product.redeemCoins) * double.parse(product.count.toString());
          redeemedCoin += double.parse(product.redeemCoins) * double.parse(product.count.toString());
          availableCoins = availableCoins - double.parse(product.redeemCoins) * double.parse(product.count.toString());
          log("sellingPrice=====>${double.parse(product.sellingPrice) * product.count}");
          product.amounttopay = 0;
          log("customerCoins=====>$customerCoins");
          log("redeemCoins=====>$redeemCoins");
          log("availableCoins====>$availableCoins");
        } else if (availableCoins == 0) {
          product.amounttopay = double.parse(product.sellingPrice) * product.count;
          totalPay += double.parse(product.sellingPrice) * product.count;
          log("yha mai aya hu== $totalPay");
        } else {
          if (availableCoins < (double.parse(product.redeemCoins) * double.parse(product.count.toString()))) {
            log("yha mai aya hu totalPay===>${double.parse(product.redeemCoins) * double.parse(product.count.toString())}");
            double remainingCoin =
                (double.parse(product.redeemCoins) * double.parse(product.count.toString())) - availableCoins;
            log("availableCoins1======>$availableCoins");
            log("customerCoins1=====>$customerCoins");
            log("amount1 ==> $remainingCoin");
            log("customerCoins1=====>$customerCoins");
            double coinToRupee = remainingCoin / 3;

            log("amount1== ==> $remainingCoin");
            log("coinToRupee== ==> $coinToRupee");

            product.coinpaid = availableCoins;
            product.amounttopay = coinToRupee;

            log("product.coinpaid== ==> $availableCoins");
            log("product.amounttopay== ==> $coinToRupee");
            partialcoin = double.parse(product.redeemCoins) * double.parse(product.count.toString());
            log("yha mai aya hu totalPay====>${product.redeemCoins}");
            redeemedCoin += availableCoins;
            redeemCoins += availableCoins;
            availableCoins = 0;
            product.redeemCoins = partialcoin.toString();
            log("yha mai aya hu totalPay====>");
            totalPay = coinToRupee;
          } else {
            double remainingCoin =
                (double.parse(product.redeemCoins) * double.parse(product.count.toString())) - availableCoins;
            log("availableCoins1======>$availableCoins");
            log("customerCoins1=====>$customerCoins");
            log("amount1 ==> $remainingCoin");
            log("customerCoins1=====>$customerCoins");
            double coinToRupee = remainingCoin / 3;
            log("amount1== ==> $remainingCoin");
            totalPay += coinToRupee;
            redeemedCoin += availableCoins;
            redeemCoins += availableCoins;
            availableCoins = 0;
          }
        }
      } else {
        product.coinpaid = 0;
        product.redeemCoins = product.coinpaid.toString();
        product.amounttopay = double.parse(product.sellingPrice) * product.count;
        totalPay += double.parse(product.sellingPrice) * product.count;
        log("yha mai aya hu $totalPay");
      }

      log("=====>product.earningCoins${double.parse(product.earningCoins)}");
      log("=====>product.count2${product.count}");
      earnCoins += double.parse(product.earningCoins);
      log("---earnCoins$earnCoins");
      log("---totalpay --> $totalPay");
      log("---redeemCoins --> $redeemCoins");
    });
  }
}

class Dialog extends StatefulWidget {
  Dialog({Key? key}) : super(key: key);

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  _displayCoinDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Container(
                height: 100,
                width: 70,
                child: Image.asset("assets/images/coins.png", fit: BoxFit.contain),
              ),
              content: Text("coins_generated_successfully_in_customer_wallet_key".tr()),
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
                      Navigator.pushAndRemoveUntil(
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

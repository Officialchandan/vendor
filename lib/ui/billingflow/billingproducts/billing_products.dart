import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_bloc.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_event.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_state.dart';
import 'package:vendor/ui/home/bottom_navigation_home.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';

class BillingProducts extends StatefulWidget {
  final List<ProductModel> billingItemList;

  BillingProducts(
      {required this.billingItemList,
      required this.mobile,
      required this.coin});

  final List<ProductModel> searchList = [];
  final coin;
  final mobile;

  @override
  _BillingProductsState createState() =>
      _BillingProductsState(this.billingItemList, this.mobile, this.coin);
}

class _BillingProductsState extends State<BillingProducts> {
  _BillingProductsState(List<ProductModel> billingItemList, mobile, coin);

  ProductModel? selectedProductList;
  List<ProductModel> productList = [];
  List index = [];
  BillingProductData? otpVerifyList;
  TextEditingController _textFieldController = TextEditingController();
  BillingProductsBloc billingProductsBloc = BillingProductsBloc();

  @override
  void initState() {
    productList = widget.billingItemList;
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

  double earningPrice(double price) {
    x = price;
    log("1=$x");
    x = (x * 25) / 100;
    log("2=$x");
    x = x - (x * 18) / 100;
    log("3=$x");
    x = x - 0.50;
    log("4=$x");
    x = x / 2;
    log("5=$x");
    x = x * 3;
    log("6=$x");
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
            index.add(state.index);
            widget.billingItemList[state.index].check = false;

            calculateAmounts(productList);
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
            productList[state.index].sellingPrice =
                ((state.price) / widget.billingItemList[state.index].count)
                    .toStringAsFixed(2);

            productList[state.index].earningCoins =
                state.earningCoin.toStringAsFixed(2);
            print(
                "productList[state.index].sellingPrice-->${productList[state.index].sellingPrice}");
            productList[state.index].earningCoins =
                state.earningCoin.toStringAsFixed(2);

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
              "Billing Products",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
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
          body: BlocBuilder<BillingProductsBloc, BillingProductsState>(
              builder: (context, state) {
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
                      variantName +=
                          product.productOption[i].value.toString() + ", ";
                  }
                }

                return Stack(
                  children: [
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 30, right: 10),
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
                      child: ListTile(
                        minLeadingWidth: 20,
                        contentPadding: EdgeInsets.only(left: 50),
                        title: Container(
                          transform: Matrix4.translationValues(0, -2, 0),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.58,
                                      child: AutoSizeText(
                                        "${productList[index].productName} ($variantName)",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                        maxFontSize: 13,
                                        minFontSize: 10,
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 50,
                                            child: AutoSizeText(
                                              "Qty: ${productList[index].count} ",
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              maxFontSize: 15,
                                              minFontSize: 10,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          )
                                        ])
                                  ]),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            "\u20B9",
                                            style: TextStyle(
                                              color: ColorPrimary,
                                            ),
                                            maxFontSize: 17,
                                            minFontSize: 13,
                                          ),
                                          AutoSizeText(
                                            " ${(double.parse(productList[index].sellingPrice) * productList[index].count).toStringAsFixed(2)} ",
                                            style:
                                                TextStyle(color: ColorPrimary),
                                            maxFontSize: 15,
                                            minFontSize: 11,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              // i = 0;
                                              if (await Network.isConnected()) {
                                                _displayDialog(
                                                    context,
                                                    index,
                                                    0,
                                                    "Edit Amount",
                                                    "Enter Amount");
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please turn on Internet",
                                                    backgroundColor:
                                                        ColorPrimary);
                                              }
                                            },
                                            child: Container(
                                              height: 20,
                                              child: Image.asset(
                                                  "assets/images/edit.png"),
                                            ),
                                          ),
                                          // Text(
                                          //   " \u20B9",
                                          // ),
                                          // Text(
                                          //     "${double.parse(productList[index].mrp) * productList[index].count}",
                                          //     style: TextStyle(
                                          //         color: Colors.grey,
                                          //         decoration: TextDecoration
                                          //             .lineThrough,
                                          //         fontSize: 14)),
                                        ]),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AutoSizeText(
                                          "Earning ",
                                          maxFontSize: 15,
                                          minFontSize: 11,
                                        ),
                                        Container(
                                          height: 17,
                                          width: 17,
                                          child: Image.asset(
                                              "assets/images/point.png"),
                                        ),
                                        AutoSizeText(
                                          " ${(double.parse(productList[index].earningCoins) * productList[index].count).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: ColorPrimary,
                                          ),
                                          maxFontSize: 15,
                                          minFontSize: 11,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ])
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BlocBuilder<BillingProductsBloc,
                                              BillingProductsState>(
                                            builder: (context, state) {
                                              return Container(
                                                height: 18,
                                                width: 18,
                                                color: Colors.white,
                                                child: Checkbox(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,

                                                  // checkColor: Colors.indigo,
                                                  value: widget
                                                      .billingItemList[index]
                                                      .billingcheck,
                                                  activeColor: ColorPrimary,
                                                  onChanged: (newvalue) async {
                                                    log("true===>");
                                                    if (await Network
                                                        .isConnected()) {
                                                      billingProductsBloc.add(
                                                          CheckedBillingProductsEvent(
                                                              check: newvalue!,
                                                              index: index));
                                                      selectedProductList =
                                                          productList[index];
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Please turn on Internet",
                                                          backgroundColor:
                                                              ColorPrimary);
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          Text(" Redeem",
                                              style: TextStyle(fontSize: 14)),
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text("Redeem ",
                                              style: TextStyle(fontSize: 14)),
                                          Container(
                                            height: 17,
                                            width: 17,
                                            child: Image.asset(
                                                "assets/images/point.png"),
                                          ),
                                          Text(
                                              " ${double.parse(productList[index].redeemCoins) * productList[index].count}",
                                              style: TextStyle(
                                                  color: ColorPrimary,
                                                  fontSize: 15)),
                                          SizedBox(
                                            width: 5,
                                          )
                                        ])
                                  ])
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 0,
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 30, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: productList[index].productImages.isNotEmpty
                              ? Image(
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                      "${productList[index].productImages[0].productImage}"),
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
                    ),
                    Positioned(
                      top: 0,
                      right: 20,
                      child: InkWell(
                        onTap: () async {
                          log("===>${productList[index]}");
                          // i = 0;

                          // totalPay = 0;
                          // earncoins1 -= earncoins1 -
                          //     int.parse(widget
                          //             .billingItemList[index]
                          //             .earningCoins) *
                          //         2;
                          // reddemcoins1 -= reddemcoins1 -
                          //     int.parse(widget
                          //             .billingItemList[index]
                          //             .redeemCoins) *
                          //         2;
                          if (await Network.isConnected()) {
                            billingProductsBloc
                                .add(DeleteBillingProductsEvent(index: index));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please turn on Internet",
                                backgroundColor: ColorPrimary);
                          }
                        },
                        child: BlocBuilder<BillingProductsBloc,
                            BillingProductsState>(
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
                    )
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
                  BlocBuilder<BillingProductsBloc, BillingProductsState>(
                      builder: (context, state) {
                    if (state is IntitalBillingProductstate) {
                      calculateAmounts(productList);
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 15, bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Pay Amount",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Text("\u20B9 ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: ColorPrimary)),
                                    Text("${totalPay.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: ColorPrimary)),
                                  ],
                                ),
                              ]),
                        ),
                        Divider(
                          height: 1,
                          color: ColorTextPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 15, bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Redeem Coins",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        child: Image.asset(
                                      "assets/images/point.png",
                                      scale: 2.5,
                                    )),
                                    Text(" ${redeemCoins.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: ColorPrimary)),
                                  ],
                                ),
                              ]),
                        ),
                        Divider(
                          height: 1,
                          color: ColorTextPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 15, bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Earn Coins",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        child: Image.asset(
                                      "assets/images/point.png",
                                      scale: 2.5,
                                    )),
                                    Text(" ${earnCoins.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: ColorPrimary)),
                                  ],
                                ),
                              ]),
                        ),
                      ],
                    );
                  }),
                  BlocConsumer<BillingProductsBloc, BillingProductsState>(
                    listener: (context, state) {
                      if (state is PayBillingProductsState) {
                        message = state.message;
                        status = state.succes;
                        otpVerifyList = state.data;
                        log("${otpVerifyList!.otp}");
                        _displayDialog(
                            context, 0, 1, "Please Enter OTP", "Enter OTP");
                      }
                      if (state is PayBillingProductsStateFailureState) {
                        message = state.message;
                        Fluttertoast.showToast(
                            msg: state.message, backgroundColor: ColorPrimary);
                      }
                      if (state is PayBillingProductsStateLoadingstate) {
                        log("number chl gya");
                      }

                      if (state is VerifyOtpState) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => BillingScreen()));
                        d._displayCoinDialog(context);
                      }
                      if (state is VerifyOtpStateLoadingstate) {
                        log("number chl gya");
                      }
                      if (state is VerifyOtpStateFailureState) {
                        message = state.message;
                        Fluttertoast.showToast(
                            msg: state.message, backgroundColor: ColorPrimary);
                      }
                    },
                    builder: (context, state) {
                      return InkWell(
                        onTap: () async {
                          log("==>${_textFieldController.text}");
                          if (await Network.isConnected()) {
                            billingProducts(context)
                                .then((value) => _textFieldController.clear());
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please turn on Internet",
                                backgroundColor: ColorPrimary);
                          }
                        },
                        child: Container(
                          width: width,
                          color: ColorPrimary,
                          child: Center(
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
    input["vendor_id"] =
        await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["mobile"] = widget.mobile;
    input["address_id"] = "";
    input["payment_method"] = "cash";
    input["payment_code"] = "COD";
    input["total_pay"] = totalPay;
    input["total_redeem"] = redeemCoins;
    input["order_status"] = "0";

    List<Map<String, dynamic>> billingProductList = [];

    for (int i = 0; i < widget.billingItemList.length; i++) {
      Map<String, dynamic> billingProduct = Map<String, dynamic>();

      billingProduct["product_id"] = widget.billingItemList[i].id;
      billingProduct["product_name"] = widget.billingItemList[i].productName;
      billingProduct["qty"] = widget.billingItemList[i].count.toString();
      billingProduct["price"] = widget.billingItemList[i].sellingPrice;
      billingProduct["total"] =
          double.parse(productList[i].sellingPrice) * productList[i].count;

      billingProduct["product_redeem"] = widget.billingItemList[i].redeemCoins;

      billingProductList.add(billingProduct);
    }
    input["product"] = billingProductList;
    log("=====? $input");
    billingProductsBloc.add(PayBillingProductsEvent(input: input));
  }

  _displayDialog(BuildContext context, index, status, text, hinttext) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
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
                controller: _textFieldController,
                cursorColor: ColorPrimary,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // filled: true,
                  counterText: "",

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
                      if (status == 0) {
                        if (_textFieldController.text.isNotEmpty) {
                          log("onPressed->$status");
                          // productList[index].sellingPrice = _textFieldController.text;
                          double y =
                              double.parse(_textFieldController.text.trim());
                          log("y->$y");
                          double earningCoin = earningPrice(y);

                          log("index->$index");
                          log("earningCoin->$earningCoin");

                          billingProductsBloc.add(EditBillingProductsEvent(
                              price: y,
                              index: index,
                              earningCoin: earningCoin));

                          Navigator.pop(context);
                          _textFieldController.clear();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please Enter Amount",
                              backgroundColor: ColorPrimary);
                        }
                      } else {
                        verifyOtp(context);
                      }
                    },
                    child: new Text(
                      "DONE",
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
        });
  }

  Future<void> verifyOtp(BuildContext context) async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["vendor_id"] =
        await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    input["mobile"] = widget.mobile;
    input["order_id"] = "${otpVerifyList!.orderId}";
    input["customer_id"] = "${otpVerifyList!.customerId}";
    input["otp"] = "${_textFieldController.text}";
    input["total_pay"] = "${otpVerifyList!.totalPay}";

    input["total_redeem"] = totalPay;
    input["total_earning"] = earnCoins;
    input["myprofit_revenue"] = "${otpVerifyList!.myprofitrevenue}";

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
      log("=====>sellingPrice${double.parse(product.sellingPrice)}");
      log("=====>product.count${product.count}");
      log("---totalPay$totalPay");
      log("=====>redeemCoins==>${double.parse(product.redeemCoins)}");
      // redeemedCoin += double.parse(product.redeemCoins);
      log("=====>redeemCoinss==>$redeemedCoin");
      log("=====>product.count${product.count}");
      product.redeemCoins = (double.parse(product.sellingPrice) * 3).toString();

      log("=====>product.redeemCoins${product.redeemCoins}");
      if (product.billingcheck) {
        if (availableCoins >=
            (double.parse(product.redeemCoins) *
                double.parse(product.count.toString()))) {
          redeemCoins += double.parse(product.redeemCoins) *
              double.parse(product.count.toString());
          redeemedCoin += double.parse(product.redeemCoins) *
              double.parse(product.count.toString());
          availableCoins = availableCoins -
              double.parse(product.redeemCoins) *
                  double.parse(product.count.toString());
          log("sellingPrice=====>${double.parse(product.sellingPrice) * product.count}");
          log("customerCoins=====>$customerCoins");
          log("redeemCoins=====>$redeemCoins");
        } else {
          double remainingCoin = (double.parse(product.redeemCoins) *
                  double.parse(product.count.toString())) -
              availableCoins;

          log("customerCoins=====>$customerCoins");
          log("amount ==> $remainingCoin");
          log("customerCoins$customerCoins");
          double coinToRupee = remainingCoin / 3;
          log("amount ==> $remainingCoin");
          totalPay += coinToRupee;
          redeemedCoin += availableCoins;
          redeemCoins += availableCoins;
          availableCoins = 0;
        }

        // totalPay -= double.parse(product.sellingPrice) * product.count;
      } else {
        log("yha mai aya hu");
        totalPay += double.parse(product.sellingPrice) * product.count;
      }
      // if (product.billingcheck) {
      //   widget.coin -= double.parse(product.redeemCoins) * product.count;
      // } else {
      //   widget.coin += double.parse(product.redeemCoins) * product.count;
      // }
      log("=====>product.earningCoins${double.parse(product.earningCoins)}");
      log("=====>product.count2${product.count}");
      earnCoins += double.parse(product.earningCoins) * product.count;
      log("---earnCoins$earnCoins");
      log("---totalpay --> $totalPay");
      log("---redeemCoins --> $redeemCoins");
    });
    // totalPay = redeemCoinss -
  }

//   void calculateAmounts(List<ProductModel> productList) {
//     double totalPay = 0;
//     double redeemCoins = 0;
//     double earnCoins = 0;
//     double customerCoins = widget.coin;

//     productList.forEach((product) {
//       product.redeemCoins = (double.parse(product.sellingPrice) * 3).toString();

//       if (product.billingcheck) {
//         redeemCoins += double.parse(product.redeemCoins);
//       }

//       totalPay += double.parse(product.sellingPrice) * product.count;
//       earnCoins += double.parse(product.earningCoins) * product.count;

//       log("=====>product.earningCoins${double.parse(product.earningCoins)}");
//       log("=====>product.count2${product.count}");
//       log("---earnCoins$earnCoins");
//       log("---totalpay --> $totalPay");
//       log("---redeemCoins --> $redeemCoins");
//     });

//     if (customerCoins >= redeemCoins) {
//       double d = totalPay;

//       double e = redeemCoins*3;

//     } else {}
//   }
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Container(
                height: 100,
                width: 70,
                child:
                    Image.asset("assets/images/coins.png", fit: BoxFit.contain),
              ),
              content: Text("Coins generated successfully in customer Wallet"),
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
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              child: BottomNavigationHome(),
                              type: PageTransitionType.fade),
                          ModalRoute.withName("/"));
                    },
                    child: new Text(
                      "DONE",
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

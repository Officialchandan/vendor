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
import 'package:share/share.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billing/billing.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_bloc.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_event.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_state.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_event.dart';

import 'package:vendor/utility/color.dart';
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
  List<ProductModel> ProductList = [];
  BillingProductData? otpVerifyList;

  BillingProductsBloc billingProductsBloc = BillingProductsBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // log("${widget.billingItemList.length}");
    ProductList = widget.billingItemList;

    billingProductsBloc.add(TotalPayAmountBillingProductsEvent(mrp: totalpay1));
  }

  _DialogState d = _DialogState();

  double totalpay1 = 0;

  double reddemcoins1 = 0;
  var x, i = 0;
  var message;
  var status;

  double earncoins1 = 0;
  earningPrice(var price) {
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
      child: BlocConsumer<BillingProductsBloc, BillingProductsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 30,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
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
                  Text(" ${widget.coin}  ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                ]),
              ],
            ),
            body: Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: BlocBuilder<BillingProductsBloc,
                            BillingProductsState>(builder: (context, state) {
                          if (state is DeleteBillingProductstate) {
                            ProductList.remove(ProductList[state.index]);
                          }
                          if (state is IntitalBillingProductstate) {}
                          return ListView.builder(
                            itemCount: ProductList.length,
                            itemBuilder: (context, index) {
                              //totalpay1 = 0;
                              String variantName = "";

                              ProductModel product = ProductList[index];
                              // if (i < ProductList.length) {
                              log("=====>${int.parse(ProductList[index].sellingPrice)}");
                              log("=====>${ProductList[index].count}");
                              log("=====>$index");

                              totalpay1 += double.parse(widget
                                      .billingItemList[index].sellingPrice) *
                                  ProductList[index].count;
                              log("---$totalpay1");
                              // }
                              // if (i < ProductList.length) {
                              log("=====>${int.parse(ProductList[index].redeemCoins)}");
                              log("=====>${ProductList[index].count}");
                              log("=====>$index");
                              //reddemcoins1 = 0;
                              reddemcoins1 += double.parse(widget
                                      .billingItemList[index].redeemCoins) *
                                  ProductList[index].count;
                              log("---$reddemcoins1");
                              // }
                              // if (i < ProductList.length) {
                              // i++;
                              log("=====>${int.parse(ProductList[index].earningCoins)}");
                              log("=====>${ProductList[index].count}");
                              log("=====>$index");
                              //earncoins1 = 0;
                              earncoins1 += double.parse(widget
                                      .billingItemList[index].earningCoins) *
                                  ProductList[index].count;
                              log("---$earncoins1");
                              // }

                              if (product.productOption.isNotEmpty) {
                                for (int i = 0;
                                    i < product.productOption.length;
                                    i++) {
                                  if (product.productOption.length - 1 == i)
                                    variantName += product
                                        .productOption[i].value
                                        .toString();
                                  else
                                    variantName += product
                                            .productOption[i].value
                                            .toString() +
                                        ", ";
                                }
                              }

                              return Stack(
                                children: [
                                  Container(
                                    height: 100,
                                    margin: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 30,
                                        right: 10),
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
                                        transform:
                                            Matrix4.translationValues(0, -2, 0),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.58,
                                                    height: 20,
                                                    child: AutoSizeText(
                                                      "${ProductList[index].productName} ($variantName)",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      maxFontSize: 14,
                                                      minFontSize: 11,
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                            "Qty: ${ProductList[index].count} ",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 15)),
                                                        SizedBox(
                                                          width: 5,
                                                        )
                                                      ])
                                                ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("\u20B9",
                                                            style: TextStyle(
                                                                color:
                                                                    ColorPrimary,
                                                                fontSize: 18)),
                                                        Text(
                                                            " ${int.parse(ProductList[index].sellingPrice) * ProductList[index].count} ",
                                                            style: TextStyle(
                                                                color:
                                                                    ColorPrimary)),
                                                        InkWell(
                                                          onTap: () {
                                                            // i = 0;
                                                            _displayDialog(
                                                                context,
                                                                index,
                                                                0,
                                                                "Edit Amount",
                                                                "Enter Amount");
                                                          },
                                                          child: Container(
                                                            height: 20,
                                                            child: Image.asset(
                                                                "assets/images/edit.png"),
                                                          ),
                                                        ),
                                                        Text(
                                                          " \u20B9",
                                                        ),
                                                        Text(
                                                            "${int.parse(ProductList[index].mrp) * ProductList[index].count}",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                fontSize: 14)),
                                                      ]),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text("Earning ",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                      Container(
                                                        height: 17,
                                                        width: 17,
                                                        child: Image.asset(
                                                            "assets/images/point.png"),
                                                      ),
                                                      x == null
                                                          ? Text(
                                                              " ${int.parse(ProductList[index].earningCoins) * ProductList[index].count}",
                                                              style: TextStyle(
                                                                  color:
                                                                      ColorPrimary,
                                                                  fontSize: 15))
                                                          : Text(
                                                              " ${x * ProductList[index].count}",
                                                              style: TextStyle(
                                                                  color:
                                                                      ColorPrimary,
                                                                  fontSize:
                                                                      15)),
                                                      SizedBox(
                                                        width: 5,
                                                      )
                                                    ])
                                              ],
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        BlocBuilder<
                                                            BillingProductsBloc,
                                                            BillingProductsState>(
                                                          builder:
                                                              (context, state) {
                                                            if (state
                                                                is CheckerBillingProductstate) {
                                                              widget
                                                                      .billingItemList[
                                                                          state
                                                                              .index]
                                                                      .billingcheck =
                                                                  state.check;
                                                            }
                                                            return Container(
                                                              height: 18,
                                                              width: 18,
                                                              color:
                                                                  Colors.white,
                                                              child: Checkbox(
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,

                                                                // checkColor: Colors.indigo,
                                                                value: widget
                                                                    .billingItemList[
                                                                        index]
                                                                    .billingcheck,
                                                                activeColor:
                                                                    ColorPrimary,
                                                                onChanged:
                                                                    (newvalue) {
                                                                  log("true===>");
                                                                  billingProductsBloc.add(
                                                                      CheckedBillingProductsEvent(
                                                                          check:
                                                                              newvalue!,
                                                                          index:
                                                                              index));
                                                                  selectedProductList =
                                                                      ProductList[
                                                                          index];
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        Text(" Redeem",
                                                            style: TextStyle(
                                                                fontSize: 14)),
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text("Redeem ",
                                                            style: TextStyle(
                                                                fontSize: 14)),
                                                        Container(
                                                          height: 17,
                                                          width: 17,
                                                          child: Image.asset(
                                                              "assets/images/point.png"),
                                                        ),
                                                        Text(
                                                            " ${int.parse(ProductList[index].redeemCoins) * ProductList[index].count}",
                                                            style: TextStyle(
                                                                color:
                                                                    ColorPrimary,
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
                                      margin: EdgeInsets.only(
                                          left: 10, right: 30, bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ProductList[index]
                                                .productImages
                                                .isNotEmpty
                                            ? Image(
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.contain,
                                                image: NetworkImage(
                                                    "${ProductList[index].productImages[0].productImage}"),
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
                                      onTap: () {
                                        log("${ProductList[index]}");
                                        i = 0;

                                        totalpay1 = 0;

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

                                        billingProductsBloc.add(
                                            DeleteBillingProductsEvent(
                                                billingItemList: widget
                                                    .billingItemList[index],
                                                index: index));
                                      },
                                      child: BlocBuilder<BillingProductsBloc,
                                          BillingProductsState>(
                                        builder: (context, state) {
                                          return Container(
                                            height: 20,
                                            width: 20,
                                            color: Colors.white,
                                            child: Image.asset(
                                                "assets/images/delete.png"),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        })),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 15, bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Pay Amount",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                Text("\u20B9 ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: ColorPrimary)),
                                Text("$totalpay1",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: ColorPrimary)),
                              ],
                              //   );
                              // },
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
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                Container(
                                    child: Image.asset(
                                  "assets/images/point.png",
                                  scale: 2.5,
                                )),
                                Text(" $reddemcoins1",
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
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                Container(
                                    child: Image.asset(
                                  "assets/images/point.png",
                                  scale: 2.5,
                                )),
                                Text(" $earncoins1",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: ColorPrimary)),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
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
                  return Positioned(
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          log("==>${_textFieldController.text}");
                          billingProducts(context);
                          // billingProductsBloc.add(PayBillingProductsEvent(
                          //     input: widget.billingItemList));
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
                      ));
                },
              ),
            ]),
          );
        },
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
    input["total_pay"] = totalpay1;
    input["total_redeem"] = reddemcoins1;
    input["order_status"] = "1";

    List<Map<String, dynamic>> billingProductList = [];

    for (int i = 0; i < widget.billingItemList.length; i++) {
      Map<String, dynamic> billingProduct = Map<String, dynamic>();

      billingProduct["product_id"] = widget.billingItemList[i].id;
      billingProduct["product_name"] = widget.billingItemList[i].productName;
      billingProduct["qty"] = widget.billingItemList[i].count.toString();
      billingProduct["price"] = widget.billingItemList[i].sellingPrice;
      billingProduct["total"] =
          double.parse(ProductList[i].sellingPrice) * ProductList[i].count;

      billingProduct["product_redeem"] = widget.billingItemList[i].redeemCoins;

      billingProductList.add(billingProduct);
    }
    input["product"] = billingProductList;
    log("=====? $input");
    billingProductsBloc.add(PayBillingProductsEvent(input: input));
  }

  TextEditingController _textFieldController = TextEditingController();
  _displayDialog(BuildContext context, index, status, text, hinttext) async {
    return showDialog(
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
                controller: _textFieldController,
                cursorColor: ColorPrimary,
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // filled: true,

                  // fillColor: Colors.black,
                  hintText: "$hinttext`",
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.white),
                  // ),
                  // enabledBorder: Out
                  //
                  //
                  // lineInputBorder(
                  //   borderSide: BorderSide(color: Colors.white),
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
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
                        ProductList[index].sellingPrice =
                            _textFieldController.text;
                        double y = double.parse(_textFieldController.text);

                        earningPrice(y);
                        Navigator.pop(context);
                        _textFieldController.clear();
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
    input["total_redeem"] = totalpay1;
    input["total_earning"] = earncoins1;

    log("=====? $input");
    billingProductsBloc.add(OtpVerifyEvent(input: input));
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
                      Navigator.push(
                          context,
                          PageTransition(
                              child: BillingScreen(),
                              type: PageTransitionType.fade));
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

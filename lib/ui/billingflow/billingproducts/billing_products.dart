import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billing/billing.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_bloc.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_event.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_state.dart';

import 'package:vendor/utility/color.dart';

class BillingProducts extends StatefulWidget {
  List<ProductModel> billingItemList = [];
  BillingProducts(
      {required this.billingItemList,
      required this.mobile,
      required this.coin});
  List<ProductModel> searchList = [];
  var coin;
  var mobile;

  @override
  _BillingProductsState createState() =>
      _BillingProductsState(this.billingItemList, this.mobile, this.coin);
}

class _BillingProductsState extends State<BillingProducts> {
  _BillingProductsState(List<ProductModel> billingItemList, mobile, coin);
  ProductModel? selectedProductList;
  BillingProductsBloc billingProductsBloc = BillingProductsBloc();
  StreamController<ProductModel> product = StreamController();
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("${widget.billingItemList.length}");
    billingProductsBloc.add(TotalPayAmountBillingProductsEvent(mrp: totalpay1));
  }

  _DialogState d = _DialogState();

  double totalpay1 = 0;

  double reddemcoins1 = 0;

  double earncoins1 = 0;

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
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: BlocBuilder<BillingProductsBloc,
                          BillingProductsState>(
                        builder: (context, state) {
                          if (state is DeleteBillingProductstate) {
                            widget.billingItemList
                                .remove(widget.billingItemList[state.index]);
                          }
                          return StreamBuilder<ProductModel>(
                              stream: product.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {}

                                return ListView.builder(
                                  itemCount: widget.billingItemList.length,
                                  itemBuilder: (context, index) {
                                    String variantName = "";
                                    ProductModel product =
                                        widget.billingItemList[index];
                                    log("=====>${int.parse(widget.billingItemList[index].sellingPrice)}");
                                    log("=====>${widget.billingItemList[index].count}");
                                    log("=====>$index");
                                    //if (widget.billingItemList[index].count == 1) {
                                    totalpay1 += double.parse(widget
                                            .billingItemList[index]
                                            .sellingPrice) *
                                        widget.billingItemList[index].count;
                                    log("---$totalpay1");

                                    log("=====>${int.parse(widget.billingItemList[index].redeemCoins)}");
                                    log("=====>${widget.billingItemList[index].count}");
                                    log("=====>$index");

                                    reddemcoins1 += double.parse(widget
                                            .billingItemList[index]
                                            .redeemCoins) *
                                        widget.billingItemList[index].count;
                                    log("---$reddemcoins1");

                                    log("=====>${int.parse(widget.billingItemList[index].earningCoins)}");
                                    log("=====>${widget.billingItemList[index].count}");
                                    log("=====>$index");

                                    earncoins1 += double.parse(widget
                                            .billingItemList[index]
                                            .earningCoins) *
                                        widget.billingItemList[index].count;
                                    log("---$earncoins1");

                                    if (product.productOption.isNotEmpty) {
                                      for (int i = 0;
                                          i < product.productOption.length;
                                          i++) {
                                        if (product.productOption.length - 1 ==
                                            i)
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
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            minLeadingWidth: 20,
                                            contentPadding:
                                                EdgeInsets.only(left: 50),
                                            title: Container(
                                              transform:
                                                  Matrix4.translationValues(
                                                      0, -2, 0),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.58,
                                                          height: 20,
                                                          child: AutoSizeText(
                                                            "${widget.billingItemList[index].productName} ($variantName)",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            maxFontSize: 14,
                                                            minFontSize: 11,
                                                          ),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  "Qty: ${widget.billingItemList[index].count} ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          15)),
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
                                                                      fontSize:
                                                                          18)),
                                                              d._textFieldController
                                                                      .text.isEmpty
                                                                  ? Text(
                                                                      " ${int.parse(widget.billingItemList[index].sellingPrice) * widget.billingItemList[index].count} ",
                                                                      style: TextStyle(
                                                                          color:
                                                                              ColorPrimary))
                                                                  : Text(
                                                                      " ${d._textFieldController.text} "),
                                                              InkWell(
                                                                onTap: () {
                                                                  d._displayDialog(
                                                                      context,
                                                                      index,
                                                                      0,
                                                                      "Edit Amount",
                                                                      "Enter Amount");
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 20,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/images/edit.png"),
                                                                ),
                                                              ),
                                                              Text(
                                                                " \u20B9",
                                                              ),
                                                              Text(
                                                                  "${int.parse(widget.billingItemList[index].mrp) * widget.billingItemList[index].count}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                      fontSize:
                                                                          14)),
                                                            ]),
                                                      ),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text("Earning ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                            Container(
                                                              height: 17,
                                                              width: 17,
                                                              child: Image.asset(
                                                                  "assets/images/point.png"),
                                                            ),
                                                            Text(
                                                                " ${int.parse(widget.billingItemList[index].earningCoins) * widget.billingItemList[index].count}",
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
                                                                    (context,
                                                                        state) {
                                                                  if (state
                                                                      is CheckerBillingProductstate) {
                                                                    widget
                                                                        .billingItemList[
                                                                            state.index]
                                                                        .billingcheck = state.check;
                                                                  }
                                                                  return Container(
                                                                    height: 18,
                                                                    width: 18,
                                                                    color: Colors
                                                                        .white,
                                                                    child:
                                                                        Checkbox(
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
                                                                        billingProductsBloc.add(CheckedBillingProductsEvent(
                                                                            check:
                                                                                newvalue!,
                                                                            index:
                                                                                index));
                                                                        selectedProductList =
                                                                            widget.billingItemList[index];
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              Text(" Redeem",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                            ]),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text("Redeem ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                              Container(
                                                                height: 17,
                                                                width: 17,
                                                                child: Image.asset(
                                                                    "assets/images/point.png"),
                                                              ),
                                                              Text(
                                                                  " ${int.parse(widget.billingItemList[index].redeemCoins) * widget.billingItemList[index].count}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          ColorPrimary,
                                                                      fontSize:
                                                                          15)),
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
                                                left: 10,
                                                right: 30,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: widget
                                                      .billingItemList[index]
                                                      .productImages
                                                      .isNotEmpty
                                                  ? Image(
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.contain,
                                                      image: NetworkImage(
                                                          "${widget.billingItemList[index].productImages[0].productImage}"),
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
                                              log("${widget.billingItemList[index]}");
                                              billingProductsBloc.add(
                                                  DeleteBillingProductsEvent(
                                                      billingItemList: widget
                                                              .billingItemList[
                                                          index],
                                                      index: index));
                                            },
                                            child: BlocBuilder<
                                                BillingProductsBloc,
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
                              });
                        },
                      ),
                    ),
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
              Positioned(
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      log("==>${d._textFieldController.text}");
                      d._displayDialog(
                          context, 0, 1, "Please Enter OTP", "Enter OTP");
                    },
                    child: Container(
                      width: width,
                      color: ColorPrimary,
                      child: Center(
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      height: height * 0.07,
                    ),
                  )),
            ]),
          );
        },
      ),
    );
  }
}

class Dialog extends StatefulWidget {
  Dialog({Key? key}) : super(key: key);

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
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
                      if (status == 1) {
                        _displayCoinDialog(context);
                      } else {
                        Navigator.pop(context);
                        _textFieldController.clear();
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

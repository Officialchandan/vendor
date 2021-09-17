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
import 'package:vendor/ui/billingflow/billingPproducts/biliing_products_bloc.dart';
import 'package:vendor/ui/billingflow/billingPproducts/biliing_products_event.dart';
import 'package:vendor/ui/billingflow/billingPproducts/biliing_products_state.dart';
import 'package:vendor/utility/color.dart';

class BillingProducts extends StatefulWidget {
  List<ProductModel> billingItemList = [];
  BillingProducts({required this.billingItemList});
  List<ProductModel> searchList = [];

  @override
  _BillingProductsState createState() =>
      _BillingProductsState(this.billingItemList);
}

class _BillingProductsState extends State<BillingProducts> {
  _BillingProductsState(List<ProductModel> billingItemList);
  ProductModel? selectedProductList;
  BillingProductsBloc billingProductsBloc = BillingProductsBloc();
  TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("${widget.billingItemList.length}");
  }

  _DialogState d = _DialogState();
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
            ),
            body: Stack(children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: ListView.builder(
                        itemCount: widget.billingItemList.length,
                        itemBuilder: (context, index) {
                          String variantName = "";
                          ProductModel product = widget.billingItemList[index];
                          if (product.productOption.isNotEmpty) {
                            for (int i = 0;
                                i < product.productOption.length;
                                i++) {
                              if (product.productOption.length - 1 == i)
                                variantName +=
                                    product.productOption[i].value.toString();
                              else
                                variantName +=
                                    product.productOption[i].value.toString() +
                                        ", ";
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
                                    transform:
                                        Matrix4.translationValues(0, -2, 0),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.58,
                                                height: 20,
                                                child: AutoSizeText(
                                                  "${widget.billingItemList[index].productName} ($variantName)",
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
                                                        "Qty: ${widget.billingItemList[index].count} ",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15)),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("\u20B9",
                                                        style: TextStyle(
                                                            color: ColorPrimary,
                                                            fontSize: 18)),
                                                    Text(
                                                        " ${int.parse(widget.billingItemList[index].sellingPrice) * widget.billingItemList[index].count} ",
                                                        style: TextStyle(
                                                            color:
                                                                ColorPrimary)),
                                                    InkWell(
                                                      onTap: () {
                                                        d._displayDialog(
                                                            context,
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
                                                        "${int.parse(widget.billingItemList[index].mrp) * widget.billingItemList[index].count}",
                                                        style: TextStyle(
                                                            color: Colors.grey,
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
                                                  Text(
                                                      " ${int.parse(widget.billingItemList[index].earningCoins) * widget.billingItemList[index].count}",
                                                      style: TextStyle(
                                                          color: ColorPrimary,
                                                          fontSize: 15)),
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
                                                                      state.index]
                                                                  .billingcheck =
                                                              state.check;
                                                        }
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
                                                                  widget.billingItemList[
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
                                                        " ${int.parse(widget.billingItemList[index].earningCoins) * widget.billingItemList[index].count}",
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
                                  margin: EdgeInsets.only(
                                      left: 10, right: 30, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: widget.billingItemList[index]
                                            .productImages.isNotEmpty
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
                                            billingItemList:
                                                widget.billingItemList[index]));
                                  },
                                  child: BlocBuilder<BillingProductsBloc,
                                      BillingProductsState>(
                                    builder: (context, state) {
                                      if (state is DeleteBillingProductstate) {
                                        widget.billingItemList.remove(
                                            widget.billingItemList[index]);
                                      }
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
                                Text("1000",
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
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                Container(
                                    child: Image.asset(
                                  "assets/images/point.png",
                                  scale: 2.5,
                                )),
                                Text(" 1000",
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
                                Text(" 1000",
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
                      d._displayDialog(
                          context, "Please Enter OTP", "Enter OTP");
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
  _displayDialog(BuildContext context, text, hinttext) async {
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
                      _displayCoinDialog(context);
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

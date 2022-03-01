import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_bloc.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_event.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_state.dart';
import 'package:vendor/ui/inventory/sale_return/sale_return_product_details.dart';
import 'package:vendor/ui/inventory/view_product/view_product.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/show_catagories_widget.dart';

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
  StreamController<List<SaleReturnProducts>> streamController =
      StreamController();
  SaleReturnBloc saleReturnBloc = SaleReturnBloc();
  bool checked = false;

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaleReturnBloc>(
      create: (context) => saleReturnBloc,
      child: BlocListener<SaleReturnBloc, SaleReturnState>(
        listener: (context, state) {
          if (state is ProductReturnSuccessState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SaleReturnProductDetails(saleReturnData: state.data)));
            // displayDialog(context, state.input);
          }
          if (state is VerifyOtpSuccessState) {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => SaleReturnScreen()),
            //     (route) => false);
            Navigator.pop(context);
            Utility.showToast(state.message);
            Navigator.pop(context);
          }
        },
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
                        // saleReturnBloc
                        //     .add(GetPurchasedProductEvent(mobile: text));
                        getPurchasedProduct(text);
                        Timer(Duration(milliseconds: 500), () {
                          FocusScope.of(context).unfocus();
                        });
                      }
                    },
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        counterText: "", labelText: "mobile_number_key".tr()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 14, top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Return Products",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.67,
                  child: showProduct(),
                )
              ],
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () {
              submit();
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.height,
              color: ColorPrimary,
              child: Center(
                child: Text(
                  "done_key".tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void selectProduct(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return IntrinsicHeight(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                    height: 300,
                    margin: EdgeInsets.only(bottom: 50),
                    child: ListView(
                      children: [
                        SelectCategoryWidget(
                          onSelect: (String? categoryId) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: ViewProductScreen(
                                      categoryId: categoryId,
                                    ),
                                    type: PageTransitionType.fade));
                          },
                        ),
                      ],
                    )),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "cancel_key".tr(),
                            style: TextStyle(),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "done_key".tr(),
                            style: TextStyle(),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ));
        });
  }

  void submit() async {
    if (edtMobile.text.isEmpty) {
      Utility.showToast("please_enter_customer_mobile_number_key".tr());
    } /* else if (edtReason.text.trim().isEmpty) {
      Utility.showToast("Please enter reason ");
    }*/
    else if (returnProductList.isEmpty) {
      Utility.showToast("Please select product to be return!");
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
      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                      text: "please_verify_your_otp_on_key".tr() +
                          "${input["mobile"]}",
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
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if (_textFieldController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "please_enter_password_key".tr(),
                            backgroundColor: ColorPrimary);
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

  Widget showProduct() {
    return StreamBuilder<List<SaleReturnProducts>>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
              padding: const EdgeInsets.only(bottom: 10),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        // await Navigator.push(context, MaterialPageRoute(builder: (_) => EditProductScreen(product: product)));
                        // getProducts();
                      },
                      child: Container(
                        height: 90,
                        margin: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
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
                          child: Row(
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: snapshot
                                          .data![index].productImages.isNotEmpty
                                      ? Image(
                                          height: 65,
                                          width: 65,
                                          fit: BoxFit.contain,
                                          image: NetworkImage(snapshot
                                              .data![index].productImages),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            snapshot.data![index].productName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                            maxFontSize: 15,
                                            minFontSize: 12,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        "₹ ${snapshot.data![index].price}\t" +
                                                            " ",
                                                    style: TextStyle(
                                                        color: ColorPrimary,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text:
                                                        "₹ ${snapshot.data![index].total}",
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough))
                                              ])),
                                            ],
                                          ),
                                          snapshot.data![index].categoryName
                                                  .isNotEmpty
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffcadafa),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: Text(
                                                      "  Direct Billing  ",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Color(
                                                              0xff5086ed)),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                        child: IconButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed: () {
                                                              if (snapshot
                                                                      .data![
                                                                          index]
                                                                      .returnQty >
                                                                  1) {
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .returnQty = snapshot
                                                                        .data![
                                                                            index]
                                                                        .returnQty -
                                                                    1;
                                                                streamController
                                                                    .add(
                                                                        purchasedList);
                                                              }
                                                            },
                                                            iconSize: 20,
                                                            splashRadius: 10,
                                                            icon: Icon(
                                                              Icons.remove,
                                                            )),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        color: ColorPrimary,
                                                        child: Center(
                                                          child: Text(
                                                            "${snapshot.data![index].returnQty}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          onPressed: () {
                                                            if (snapshot
                                                                    .data![
                                                                        index]
                                                                    .returnQty <
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .qty) {
                                                              snapshot
                                                                  .data![index]
                                                                  .returnQty = snapshot
                                                                      .data![
                                                                          index]
                                                                      .returnQty +
                                                                  1;
                                                              streamController.add(
                                                                  purchasedList);
                                                            } else {
                                                              Utility.showToast(
                                                                  "Can't return more than ${snapshot.data![index].qty} products");
                                                            }
                                                          },
                                                          iconSize: 20,
                                                          splashRadius: 10,
                                                          icon: Icon(
                                                            Icons.add,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat("dd MMM HH:MM").format(
                                                    DateTime.parse(snapshot
                                                        .data![index]
                                                        .dateTime)) +
                                                " " +
                                                DateFormat.jm()
                                                    .format(DateTime.parse(
                                                        snapshot.data![index]
                                                            .dateTime))
                                                    .toLowerCase(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 9,
                      top: 4,
                      child: Checkbox(
                        activeColor: ColorPrimary,
                        value: snapshot.data![index].checked,
                        onChanged: (value) {
                          if (value == true) {
                            snapshot.data!.forEach((element) {
                              element.checked = false;
                            });
                            returnProductList.clear();
                            snapshot.data![index].checked = value!;
                            returnProductList.add(snapshot.data![index]);
                          }
                          if (value == false) {
                            snapshot.data![index].checked = value!;
                            returnProductList.remove(snapshot.data![index]);
                          }

                          streamController.add(purchasedList);
                        },
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Container();
              },
              itemCount: snapshot.data!.length);
        }
        return Container();
      },
    );
  }

  getPurchasedProduct(String mobile) async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = HashMap();
      input["mobile"] = mobile;

      GetPurchasedProductResponse response =
          await apiProvider.getPurchasedProduct(input);
      if (response.success) {
        List<SaleReturnProducts> products = [];
        for (var i in response.data!) {
          SaleReturnProducts categoryWise = SaleReturnProducts(
            orderId: i.orderId,
            categoryName: "",
            dateTime: i.dateTime,
            productId: i.productId,
            productName: i.productName,
            productImages: i.productImages.isEmpty ? "" : i.productImages.first,
            vendorId: i.vendorId,
            customerId: i.customerId,
            earningCoins: i.earningCoins,
            redeemCoins: i.redeemCoins,
            qty: i.qty,
            price: i.price,
            total: i.total,
            mobile: "",
          );
          products.add(categoryWise);
        }

        for (var i in response.directBilling!) {
          SaleReturnProducts directBilling = SaleReturnProducts(
            orderId: i.orderId.toString(),
            categoryName: i.categoryName,
            dateTime: i.dateTime,
            productId: "",
            productName: i.categoryName,
            productImages: "",
            vendorId: i.vendorId.toString(),
            customerId: "",
            earningCoins: "",
            redeemCoins: i.redeemedCoins,
            qty: 0,
            price: "",
            total: i.totalPay,
            mobile: i.mobile,
          );
          products.add(directBilling);
        }
        purchasedList = products;
        streamController.add(products);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}

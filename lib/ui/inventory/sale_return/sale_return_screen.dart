import 'dart:collection';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_bloc.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_event.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_state.dart';
import 'package:vendor/ui/inventory/sale_return/sale_product_screen.dart';
import 'package:vendor/ui/inventory/view_product/view_product.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/widget/app_button.dart';
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
  List<PurchaseProductModel> purchasedList = [];
  List<PurchaseProductModel> returnProductList = [];

  SaleReturnBloc saleReturnBloc = SaleReturnBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaleReturnBloc>(
      create: (context) => saleReturnBloc,
      child: BlocListener<SaleReturnBloc, SaleReturnState>(
        listener: (context, state) {
          if (state is GetProductSuccessState) {
            purchasedList = state.purchaseList;
          }
          if (state is ProductReturnSuccessState) {
            _displayDialog(context, state.input);
          }
          if (state is VerifyOtpSuccessState) {
            Navigator.pop(context);
            Utility.showToast(state.message);
            // Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: "sale_return_key".tr(),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: edtMobile,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  onChanged: (text) {
                    if (text.trim().length == 10) {
                      saleReturnBloc
                          .add(GetPurchasedProductEvent(mobile: text));
                    }
                  },
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      counterText: "", labelText: "mobile_number_key".tr()),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: edtProducts,
                  readOnly: true,
                  onTap: () async {
                    if (edtMobile.text.isEmpty) {
                      Utility.showToast("Please enter mobile number first!");
                      return;
                    }
                    if (edtMobile.text.trim().length != 10) {
                      Utility.showToast("Please enter valid mobile number");
                      return;
                    }

                    var result = await Navigator.push(
                        context,
                        PageTransition(
                            child: SaleProductScreen(purchasedList),
                            type: PageTransitionType.fade));

                    if (result != null) {
                      List<PurchaseProductModel> list =
                          result as List<PurchaseProductModel>;
                      saleReturnBloc
                          .add(SelectProductEvent(returnProductList: list));
                    }

                    // selectProduct(context);
                  },
                  onChanged: (text) {},
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: "choose_product_key".tr(),
                      suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                      suffixIconConstraints: BoxConstraints(
                          maxWidth: 15,
                          minWidth: 10,
                          maxHeight: 15,
                          minHeight: 10)),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: edtReason,
                  onChanged: (text) {},
                  autofocus: true,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "reason_optional_key".tr(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<SaleReturnBloc, SaleReturnState>(
                  builder: (context, state) {
                    if (state is SelectProductState) {
                      returnProductList = state.returnProductList;
                    }

                    if (returnProductList.isNotEmpty) {
                      return Column(
                        children:
                            List.generate(returnProductList.length, (index) {
                          PurchaseProductModel product =
                              returnProductList[index];
                          return Container(
                            margin: const EdgeInsets.only(
                                bottom: 5, top: 5, right: 10),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(
                                          left: 50,
                                          right: 5,
                                          top: 5,
                                          bottom: 5),
                                      title: Container(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("${product.productName}"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: "₹ ${product.price}\t",
                                                style: TextStyle(
                                                    color: ColorPrimary)),
                                            // TextSpan(
                                            //     text: "₹ ${product.total}",
                                            //     style: TextStyle(color: Colors.black, decoration: TextDecoration.lineThrough))
                                          ])),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "qty_key :  ${product.returnQty}"
                                                .tr(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ],
                                      )),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: product.productImages.isNotEmpty
                                            ? Image(
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.contain,
                                                image: NetworkImage(product
                                                    .productImages.first),
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
                                  left: 20,
                                  top: 0,
                                  bottom: 0,
                                )
                              ],
                            ),
                          );
                          return ListTile(
                            title: Text(returnProductList[index].productName),
                          );
                        }),
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                AppButton(
                  title: "submit_button_key".tr(),
                  onPressed: () {
                    submit();
                  },
                )
              ],
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
      String qty = "";

      for (int i = 0; i < returnProductList.length; i++) {
        if (i == returnProductList.length - 1) {
          productId += returnProductList[i].productId.toString();
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
      input["qty"] = qty;
      input["reason"] = edtReason.text.trim();

      saleReturnBloc.add(SaleReturnApiEvent(input: input));
    }
  }

  _displayDialog(BuildContext context, Map input) async {
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
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_bloc.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_event.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_state.dart';
import 'package:vendor/ui/inventory/sale_return/sale_product_screen.dart';
import 'package:vendor/ui/inventory/view_product/view_product.dart';
import 'package:vendor/widget/app_button.dart';
import 'package:vendor/widget/show_catagories_widget.dart';

class SaleReturnScreen extends StatefulWidget {
  @override
  _SaleReturnScreenState createState() => _SaleReturnScreenState();
}

class _SaleReturnScreenState extends State<SaleReturnScreen> {
  TextEditingController edtMobile = TextEditingController();
  TextEditingController edtProducts = TextEditingController();
  TextEditingController edtReason = TextEditingController();
  List<PurchaseProductModel> purchasedList = [];

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
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Sale Return",
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
                      saleReturnBloc.add(GetPurchasedProductEvent(mobile: text));
                    }
                  },
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(counterText: "", labelText: "Mobile Number"),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: edtProducts,
                  readOnly: true,
                  onTap: () {
                    Navigator.push(context, PageTransition(child: SaleProductScreen(purchasedList), type: PageTransitionType.fade));
                    // selectProduct(context);
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  onChanged: (text) {},
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: "Choose Product",
                      suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                      suffixIconConstraints: BoxConstraints(maxWidth: 15, minWidth: 10, maxHeight: 15, minHeight: 10)),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: edtReason,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  onChanged: (text) {},
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: "Reason (Optional)",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                AppButton(
                  title: "SUBMIT",
                  onPressed: () {},
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return IntrinsicHeight(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                    height: 300,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(),
                        )),
                  ],
                )
              ],
            ),
          ));
        });
  }
}

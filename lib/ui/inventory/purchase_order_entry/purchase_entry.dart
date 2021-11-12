import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/add_product/add_product_screen.dart';
import 'package:vendor/ui/inventory/view_product/view_product.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/widget/show_catagories_widget.dart';

class PurchaseEntry extends StatefulWidget {
  @override
  _PurchaseEntryState createState() => _PurchaseEntryState();
}

class _PurchaseEntryState extends State<PurchaseEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Purchase_Order_Entry_key".tr(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              onTap: () async {
                selectCategory(context);
              },
              onChanged: (text) {},
              autofocus: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Choose_Product_key".tr(),
                  suffixIcon: Icon(Icons.keyboard_arrow_right_sharp),
                  suffixIconConstraints: BoxConstraints(
                      maxWidth: 15,
                      minWidth: 10,
                      maxHeight: 15,
                      minHeight: 10)),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddProductScreen()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text(
                "Add_New_Product_key".tr(),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.add_circle,
                color: ColorPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectCategory(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return IntrinsicHeight(
              child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(15),
                    height: 300,
                    child: ListView(
                      children: [
                        SelectCategoryWidget(
                          onSelect: (String? categoryId) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: ViewProductScreen(
                                      categoryId: categoryId,
                                      from: "purchase_order_entry_key".tr(),
                                    ),
                                    type: PageTransitionType.fade));
                          },
                        ),
                      ],
                    )),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close_key".tr(),
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
}

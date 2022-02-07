import 'dart:ui';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/home/home.dart';
import 'package:vendor/ui/inventory/add_product/add_product_screen.dart';
import 'package:vendor/ui/inventory/purchase_order_entry/purchase_entry.dart';
import 'package:vendor/ui/inventory/purchase_return/purchase_return_screen.dart';
import 'package:vendor/ui/inventory/sale_return/sale_return_screen.dart';
import 'package:vendor/ui/inventory/suggested_product/suggested_product.dart';
import 'package:vendor/ui/inventory/view_product/select_category.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  CustomAppBar customAppBar = CustomAppBar(
    title: "inventory_key".tr(),
  );
  final options = [
    {
      "title": "add_product_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/inventory.png",
      "id": 1
    },
    {
      "title": "view_product_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/inventory-h2.png",
      "id": 2
    },
    {
      "title": "sale_return_key".tr(),
      "subTitle": "click_here_to_add_product_key".tr(),
      "image": "assets/images/inventory-h3.png",
      "id": 3
    },
    // {
    //   "title": "purchase_return_key".tr(),
    //   "subTitle": "click_here_to_add_product_key".tr(),
    //   "image": "assets/images/inventory-h4.png",
    //   "id": 4
    // },
    // {
    //   "title": "purchase_order_entry_key".tr(),
    //   "subTitle": "click_here_to_add_product_key".tr(),
    //   "image": "assets/images/inventory-h5.png",
    //   "id": 5
    // },
    // {"title": "Add Product", "subTitle": "click here to add product", "image": "assets/images/category1.png", "id": 6},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("inventory_key".tr()),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.home))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Stack(
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      if (options[index]["id"] == 2) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ViewCategoryScreen(),
                                type: PageTransitionType.fade));
                      }
                      if (options[index]["id"] == 3) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: SaleReturnScreen(),
                                type: PageTransitionType.fade));
                      }
                      if (options[index]["id"] == 4) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: PurchaseReturnScreen(),
                                type: PageTransitionType.fade));
                      }
                      if (options[index]["id"] == 5) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: PurchaseEntry(),
                                type: PageTransitionType.fade));
                      }
                      if (options[index]["id"] == 1) {
                        Navigator.push(
                          context,
                          PageTransition(
                              child: AddProductScreen(),
                              type: PageTransitionType.fade),
                        );
                        // showSheet(context);
                      }
                    },
                    leading: Image(
                      image: AssetImage("${options[index]["image"]}"),
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    ),
                    title: Text("${options[index]["title"]}"),
                    subtitle: Text("${options[index]["subTitle"]}"),
                  ),
                ),
                Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 5,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    ))
              ],
            ),
          );
        },
        itemCount: options.length,
      ),
    );
  }

  void showSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return IntrinsicHeight(
            child: Column(
              children: [
                ListTile(
                  leading: Image(
                    image: AssetImage("assets/images/plus.png"),
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text("add_own_product_key".tr()),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageTransition(
                          child: AddProductScreen(),
                          type: PageTransitionType.fade),
                    );
                  },
                ),
                // ListTile(
                //   leading: Image(
                //     image: AssetImage("assets/images/suggested.png"),
                //     width: 30,
                //     height: 30,
                //     fit: BoxFit.contain,
                //   ),
                //   title: Text("add_suggested_product_key".tr()),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         PageTransition(
                //             child: SuggestedProductScreen(),
                //             type: PageTransitionType.fade));
                //   },
                // ),
              ],
            ),
          );
        });
  }
}

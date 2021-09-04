import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/ui/inventory/add_product/add_product_screen.dart';
import 'package:vendor/ui/inventory/sale_return/sale_return_screen.dart';
import 'package:vendor/ui/inventory/view_product/select_category.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  CustomAppBar customAppBar = CustomAppBar();
  final options = [
    {"title": "Add Product", "subTitle": "click here to add product", "image": "assets/images/category1.png", "id": 1},
    {"title": "View Product", "subTitle": "click here to add product", "image": "assets/images/category1.png", "id": 2},
    {"title": "Sale Return", "subTitle": "click here to add product", "image": "assets/images/category1.png", "id": 3},
    {"title": "Purchase Return", "subTitle": "click here to add product", "image": "assets/images/category1.png", "id": 4},
    {"title": "Purchase Order Entry", "subTitle": "click here to add product", "image": "assets/images/category1.png", "id": 5},
    // {"title": "Add Product", "subTitle": "click here to add product", "image": "assets/images/category1.png", "id": 6},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar,
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
                        Navigator.push(context, PageTransition(child: ViewCategoryScreen(), type: PageTransitionType.fade));
                      } else if (options[index]["id"] == 3) {
                        Navigator.push(context, PageTransition(child: SaleReturnScreen(), type: PageTransitionType.fade));
                      } else {
                        Navigator.push(context, PageTransition(child: AddProductScreen(), type: PageTransitionType.fade));
                      }
                    },
                    leading: Icon(Icons.print),
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
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                    ))
              ],
            ),
          );
        },
        itemCount: options.length,
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendor/model/product_model.dart';

class SaleProductScreen extends StatefulWidget {
  @override
  _SaleProductScreenState createState() => _SaleProductScreenState();
}

class _SaleProductScreenState extends State<SaleProductScreen> {
  TextEditingController txtSearch = TextEditingController();
  List<ProductModel> products = [];

  StreamController<List<ProductModel>> streamController = StreamController();

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        title: TextFormField(
          controller: txtSearch,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(242, 242, 242, 1),
            hintText: "Search products",
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
          onChanged: (text) {
            if (text.isNotEmpty) {
              List<ProductModel> searchList = [];

              products.forEach((element) {
                if (element.productName.toLowerCase().contains(text.trim().toLowerCase())) {
                  searchList.add(element);
                }
              });

              print("searchList->$searchList");
              streamController.add(searchList);
            } else {
              streamController.add(products);
            }
          },
        ),
      ),
    );
  }

  void getProducts() {}
}

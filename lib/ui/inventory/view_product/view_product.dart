import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/inventory/edit_product/edit_product_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class ViewProductScreen extends StatefulWidget {
  final categoryId;
  final from;

  ViewProductScreen({this.categoryId, this.from = ""});

  @override
  _ViewProductScreenState createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  List<ProductModel> products = [];

  TextEditingController txtSearch = TextEditingController();
  ScrollController scrollController = ScrollController();

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
              hintText: "search_products_key".tr(),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              focusedErrorBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
        body: StreamBuilder<List<ProductModel>>(
          stream: streamController.stream,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("data-->${snapshot.data}");
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Image(
                    image: AssetImage("assets/images/no_data.gif"),
                  ),
                );
              }
              return ListView.builder(
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    ProductModel product = snapshot.data![index];

                    String variantName = "";

                    if (product.productOption.isNotEmpty) {
                      for (int i = 0; i < product.productOption.length; i++) {
                        if (product.productOption[i].optionName.isNotEmpty) {
                          if (product.productOption.length - 1 == i)
                            variantName += product.productOption[i].value.toString();
                          else
                            variantName += product.productOption[i].value.toString() + ", ";
                        } else {
                          product.productOption.removeAt(i);
                        }
                      }
                    }

                    return InkWell(
                      onTap: () async {
                        await Navigator.push(
                            context, MaterialPageRoute(builder: (_) => EditProductScreen(product: product)));
                        getProducts();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5, top: 5, right: 10),
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
                                  contentPadding: EdgeInsets.only(left: 50, right: 5, top: 20, bottom: 20),
                                  title: Container(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        product.productName + (variantName.isNotEmpty ? "($variantName)" : ""),
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      product.sellingPrice == product.mrp
                                          ? RichText(
                                              text: TextSpan(children: [
                                              TextSpan(
                                                text: "₹ ${product.sellingPrice}\t",
                                                style: TextStyle(
                                                    fontSize: 16, color: ColorPrimary, fontWeight: FontWeight.bold),
                                              ),
                                            ]))
                                          : RichText(
                                              text: TextSpan(children: [
                                              TextSpan(
                                                text: "₹ ${product.sellingPrice}\t",
                                                style: TextStyle(
                                                    fontSize: 16, color: ColorPrimary, fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text: " ₹ ${product.mrp}",
                                                  style: TextStyle(
                                                      color: Colors.black, decoration: TextDecoration.lineThrough))
                                            ]))
                                    ],
                                  )),
                                  trailing: widget.from! == "purchase_order_entry_key".tr()
                                      ? SizedBox(
                                          height: 0,
                                          width: 0,
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            Utility.showSingleAlert(
                                              context,
                                              "Are you sure you want to delete this product?",
                                              onOk: () => deleteProduct(product, index),
                                              title: product.productName +
                                                  (variantName.isNotEmpty ? "($variantName)" : ""),
                                              okText: "delete_key".tr(),
                                            );
                                          },
                                          padding: EdgeInsets.all(2),
                                          splashRadius: 15,
                                          iconSize: 25,
                                          icon: Image(
                                            image: AssetImage("assets/images/delete.png"),
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
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
                                            image: NetworkImage(snapshot.data![index].productImages.first.productImage),
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
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length);
            }
            return Container();
          },
        ));
  }

  void getProducts() async {
    if (await Network.isConnected()) {
      ProductByCategoryResponse response;
      if (widget.categoryId == null) {
        response = await apiProvider.getAllVendorProducts();
      } else {
        if (widget.from == "purchase_order_entry_key".tr()) {
          response = await apiProvider.getAllVendorProducts();
        } else {
          response = await apiProvider.getProductByCategories(widget.categoryId.toString());
        }
      }

      if (response.success) {
        products = response.data!;

        // products.sort((a, b) => int.parse(b.sellingPrice).compareTo(int.parse(a.sellingPrice)));
        streamController.add(products);
      } else {
        Utility.showToast(msg: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);

      // EasyLoading.showError(Constant.INTERNET_ALERT_MSG);
    }
  }

  void deleteProduct(ProductModel product, int index) async {
    if (await Network.isConnected()) {
      Map input = <String, dynamic>{"product_id": "${product.productId}", "id": "${product.id}"};
      EasyLoading.show();
      CommonResponse response = await apiProvider.deleteProduct(input);
      EasyLoading.dismiss();
      if (response.success) {
        products.remove(product);
        streamController.add(products);
        // scrollController.
      } else {
        Utility.showToast(msg: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}

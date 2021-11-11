import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/common_response.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class SelectProductToReturn extends StatefulWidget {
  final categoryId;

  SelectProductToReturn({this.categoryId});

  @override
  _SelectProductToReturnState createState() => _SelectProductToReturnState();
}

class _SelectProductToReturnState extends State<SelectProductToReturn> {
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
                if (element.productName.toLowerCase().contains(text
                        .trim()
                        .toLowerCase()) /* &&
                    element.productName.toLowerCase().startsWith(text.toLowerCase())*/
                    ) {
                  searchList.add(element);
                }
              });

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
                      if (product.productOption.length - 1 == i)
                        variantName += product.productOption[i].value.toString();
                      else
                        variantName += product.productOption[i].value.toString() + ", ";
                    }
                  }

                  return Container(
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
                                  Text("${product.productName} ($variantName)"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(text: "₹ ${product.sellingPrice}\t", style: TextStyle(color: ColorPrimary)),
                                    TextSpan(
                                        text: "₹ ${product.mrp}",
                                        style: TextStyle(color: Colors.black, decoration: TextDecoration.lineThrough))
                                  ])),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          // color: Colors.amber,
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(color: Colors.black)),
                                      height: 25,
                                      // width: 90,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 30,
                                            child: IconButton(
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  if (product.returnQty > 1) {
                                                    product.returnQty = product.returnQty - 1;
                                                    streamController.add(products);
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
                                            height: 25,
                                            color: ColorPrimary,
                                            child: Center(
                                              child: Text(
                                                "${product.returnQty}",
                                                style: TextStyle(color: Colors.white, fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            width: 30,
                                            child: IconButton(
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  if (product.returnQty < product.stock) {
                                                    product.returnQty = product.returnQty + 1;
                                                    streamController.add(products);
                                                  }
                                                },
                                                iconSize: 20,
                                                splashRadius: 10,
                                                icon: Icon(
                                                  Icons.add,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                                ],
                              )),
                              trailing: Checkbox(
                                value: product.check,
                                onChanged: (value) {
                                  products[index].check = value!;
                                  streamController.add(products);
                                },
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
                  );
                },
                itemCount: snapshot.data!.length);
          }
          return Container();
        },
      ),
      bottomNavigationBar: Container(
        child: MaterialButton(
          elevation: 0,
          onPressed: () {
            List<ProductModel> returnProductList = products.where((element) => element.check).toList();

            purchaseReturn(returnProductList);
          },
          color: ColorPrimary,
          shape: RoundedRectangleBorder(),
          disabledColor: Colors.grey,
          height: 50,
          disabledTextColor: Colors.white,
          child: Text("DONE"),
        ),
      ),
    );
  }

  void purchaseReturn(List<ProductModel> returnProductList) async {
    if (await Network.isConnected()) {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      String id = "";
      String stock = "";
      for (int i = 0; i < returnProductList.length; i++) {
        if (i == returnProductList.length - 1) {
          id += returnProductList[i].id;
          stock += returnProductList[i].returnQty.toString();
        } else {
          id += returnProductList[i].id + ",";
          stock += returnProductList[i].returnQty.toString() + ",";
        }
      }
      input["id"] = id;
      input["stock"] = stock;

      EasyLoading.show();

      CommonResponse response = await apiProvider.purchaseReturnApi(input);
      EasyLoading.dismiss();
      if (response.success) {
        Utility.showToast(response.message);
        Navigator.of(context).pop();
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);

      // EasyLoading.showError(Constant.INTERNET_ALERT_MSG);
    }
  }

  void getProducts() async {
    if (await Network.isConnected()) {
      ProductByCategoryResponse response;
      if (widget.categoryId == null) {
        response = await apiProvider.getAllVendorProducts();
      } else {
        response = await apiProvider.getProductByCategories(widget.categoryId.toString());
      }

      if (response.success) {
        products = response.data!;

        // products.sort((a, b) => int.parse(b.sellingPrice).compareTo(int.parse(a.sellingPrice)));
        streamController.add(products);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);

      // EasyLoading.showError(Constant.INTERNET_ALERT_MSG);
    }
  }
}

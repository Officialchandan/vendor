import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class ProductListScreen extends StatefulWidget {
  final String? categoryId;
  const ProductListScreen({this.categoryId, Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
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
        initialData: products,
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  ProductModel product = snapshot.data![index];
                  return InkWell(
                    onTap: () async {
                      // await Navigator.push(context, MaterialPageRoute(builder: (_) => EditProductScreen(product: product)));
                      // getProducts();
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
                                contentPadding: EdgeInsets.only(left: 50, right: 5, top: 5, bottom: 5),
                                title: Container(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${product.productName}"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "₹ ${product.sellingPrice}\t", style: TextStyle(color: ColorPrimary)),
                                      // TextSpan(
                                      //     text: "₹ ${product.total}",
                                      //     style: TextStyle(color: Colors.black, decoration: TextDecoration.lineThrough))
                                    ])),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                                trailing: Checkbox(
                                  value: product.check,
                                  onChanged: (value) {
                                    product.check = value!;

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
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container();
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
            Navigator.of(context).pop(returnProductList);

            print("returnProductList-->$returnProductList");
          },
          color: ColorPrimary,
          shape: RoundedRectangleBorder(),
          disabledColor: Colors.grey,
          height: 50,
          disabledTextColor: Colors.white,
          child: Text("done_key".tr()),
        ),
      ),
    );
  }

  void getProducts() async {
    if (await Network.isConnected()) {
      ProductByCategoryResponse response;
      if (widget.categoryId == null || widget.categoryId!.isEmpty) {
        response = await apiProvider.getAllVendorProducts();
      } else {
        response = await apiProvider.getProductByCategories(widget.categoryId.toString());
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
}

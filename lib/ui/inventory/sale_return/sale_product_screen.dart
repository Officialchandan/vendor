import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/utility.dart';

class SaleProductScreen extends StatefulWidget {
  final List<PurchaseProductModel> products;

  SaleProductScreen(this.products);

  @override
  _SaleProductScreenState createState() => _SaleProductScreenState();
}

class _SaleProductScreenState extends State<SaleProductScreen> {
  TextEditingController txtSearch = TextEditingController();
  List<PurchaseProductModel> products = [];

  StreamController<List<PurchaseProductModel>> streamController = StreamController();

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    products = widget.products;

    // getProducts();
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
              List<PurchaseProductModel> searchList = [];

              products.forEach((element) {
                if (element.productName.toLowerCase().contains(text.trim().toLowerCase())) {
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
      body: StreamBuilder<List<PurchaseProductModel>>(
        initialData: products,
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SmartRefresher(
              controller: _refreshController,
              onRefresh: () {
                Future.delayed(Duration(seconds: 2), () {
                  _refreshController.refreshCompleted();
                  streamController.add(products);
                });
              },
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    PurchaseProductModel product = snapshot.data![index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
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
                                        TextSpan(text: "₹ ${product.price}\t", style: TextStyle(color: ColorPrimary)),
                                        // TextSpan(
                                        //     text: "₹ ${product.total}",
                                        //     style: TextStyle(color: Colors.black, decoration: TextDecoration.lineThrough))
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
                                                      if (product.returnQty < product.qty) {
                                                        product.returnQty = product.returnQty + 1;
                                                        streamController.add(products);
                                                      } else {
                                                        Utility.showToast(
                                                            msg: "Can't return more than ${product.qty} products");
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
                                    activeColor: ColorPrimary,
                                    value: product.checked,
                                    onChanged: (value) {
                                      product.checked = value!;

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
                                            image: NetworkImage(snapshot.data![index].productImages.first),
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
                  itemCount: snapshot.data!.length),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: MaterialButton(
          elevation: 0,
          onPressed: () {
            List<PurchaseProductModel> returnProductList = products.where((element) => element.checked).toList();
            Navigator.of(context).pop(returnProductList);
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

  void getProducts() {}
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/utility/color.dart';

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
              List<PurchaseProductModel> searchList = [];

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
      body: StreamBuilder<List<PurchaseProductModel>>(
        initialData: widget.products,
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  PurchaseProductModel product = snapshot.data![index];
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
                              elevation: 5,
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
                                      TextSpan(
                                          text: "₹ ${product.total}",
                                          style: TextStyle(color: Colors.black, decoration: TextDecoration.lineThrough))
                                    ])),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // IntrinsicWidth(
                                    //   child: Container(
                                    //     height: 30,
                                    //     decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.circular(20),
                                    //         border: Border.all(color: Colors.black, width: 1)),
                                    //     child: Row(
                                    //       children: [
                                    //         IconButton(
                                    //           onPressed: () {},
                                    //           icon: Icon(Icons.remove),
                                    //           padding: EdgeInsets.zero,
                                    //           splashRadius: 13,
                                    //           iconSize: 25,
                                    //           constraints: BoxConstraints(maxHeight: 35, minWidth: 40),
                                    //         ),
                                    //         Container(
                                    //           child: Center(
                                    //               child: Text(
                                    //             "1",
                                    //             style: TextStyle(color: Colors.white),
                                    //           )),
                                    //           color: ColorPrimary,
                                    //           height: 30,
                                    //           width: 30,
                                    //         ),
                                    //         IconButton(
                                    //           onPressed: () {},
                                    //           icon: Icon(Icons.add),
                                    //           padding: EdgeInsets.zero,
                                    //           constraints: BoxConstraints(maxHeight: 35, minWidth: 40),
                                    //           splashRadius: 13,
                                    //           iconSize: 25,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
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
                                                  onPressed: () {},
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
                                                  "${product.qty}",
                                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 25,
                                              width: 30,
                                              child: IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: () {},
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
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   child: Container(
                          //     child: Center(
                          //       child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(10),
                          //         child: product.productImages.isNotEmpty
                          //             ? Image(
                          //                 height: 60,
                          //                 width: 60,
                          //                 fit: BoxFit.contain,
                          //                 image: NetworkImage(snapshot.data![index].productImages.first.productImage),
                          //               )
                          //             : Image(
                          //                 image: AssetImage(
                          //                   "assets/images/placeholder.webp",
                          //                 ),
                          //                 height: 60,
                          //                 width: 60,
                          //                 fit: BoxFit.cover,
                          //               ),
                          //       ),
                          //     ),
                          //   ),
                          //   left: 20,
                          //   top: 0,
                          //   bottom: 0,
                          // )
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
    );
  }

  void getProducts() {}
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class SearchProductScreen extends StatefulWidget {
  final categoryId;

  SearchProductScreen({this.categoryId});

  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  List<ProductModel> products = [];

  TextEditingController txtSearch = TextEditingController();

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
              return ListView.separated(
                  itemBuilder: (context, index) {
                    ProductModel product = snapshot.data![index];

                    return ListTile(
                      contentPadding: EdgeInsets.all(20),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshot.data![index].productImage.first),
                        ),
                      ),
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
                            TextSpan(text: "₹ ${product.sellingPrice}\t", style: TextStyle(color: ColorPrimary)),
                            TextSpan(
                                text: "₹ ${product.mrp}",
                                style: TextStyle(color: Colors.black, decoration: TextDecoration.lineThrough))
                          ]))
                        ],
                      )),
                      trailing: Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                              child: Icon(
                                Icons.delete,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            decoration: BoxDecoration(color: ColorPrimary, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Share",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
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
        response = await apiProvider.getProductByCategories(widget.categoryId.toString());
      }

      if (response.success) {
        products = response.data!;
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

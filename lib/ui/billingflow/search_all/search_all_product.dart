import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billingproducts/billing_products.dart';
import 'package:vendor/ui/billingflow/search_all/search_all_event.dart';
import 'package:vendor/ui/billingflow/search_all/search_all_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import 'search_all_bloc.dart';

class SearchAllProduct extends StatefulWidget {
  String mobile;
  String coin;

  SearchAllProduct({required this.mobile, required this.coin});

  @override
  _SearchAllProductState createState() => _SearchAllProductState(this.mobile, this.coin);
}

class _SearchAllProductState extends State<SearchAllProduct> {
  _SearchAllProductState(mobile, coin);

  int count = 1;
  SearchAllBloc searchAllBloc = SearchAllBloc();
  List<ProductModel> products = [];
  List<ProductModel> searchList = [];
  ProductModel? selectedProductList;

  final PublishSubject<List<ProductModel>> subject = PublishSubject();
  String searchText = "";
  bool searching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    subject.close();
  }

  @override
  void initState() {
    super.initState();
    searchAllBloc.add(GetProductsEvent());
    // ApiProvider().getAllVendorProducts();
  }

  // @override
  // void didUpdateWidget(covariant SearchAllProduct oldWidget) {
  //   log("didUpdateWidget${oldWidget}");
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocProvider<SearchAllBloc>(
      create: (context) => searchAllBloc,
      child: BlocConsumer<SearchAllBloc, SearchAllState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                  title: TextFormField(
                    cursorColor: ColorPrimary,
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "search_key".tr(),
                      hintStyle: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                      ),
                      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (text) {
                      searchAllBloc.add(FindCategoriesEvent(searchkeyword: text));
                    },
                  ),
                  leadingWidth: 30,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios))),
              body: Container(
                child: Stack(children: [
                  BlocConsumer<SearchAllBloc, SearchAllState>(
                    listener: (context, state) {
                      if (state is SearchAllIntialState) {
                        searchAllBloc.add(GetProductsEvent());
                      }
                    },
                    builder: (context, state) {
                      if (state is GetSearchState) {
                        products = state.data!;
                        searchList = products;
                        log("${products.length}");
                      }
                      if (state is GetSearchLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is GetSearchFailureState) {
                        return Center(
                          child: Image.asset("assets/images/no_data.gif"),
                        );
                      }
                      if (state is CategoriesSearchState) {
                        if (state.searchword.isEmpty) {
                          searchList = products;
                        } else {
                          List<ProductModel> list = [];
                          products.forEach((element) {
                            if (element.productName.toLowerCase().contains(state.searchword.toLowerCase())) {
                              list.add(element);
                              log("how much -->${state.searchword}");
                            }
                          });

                          if (list.isEmpty) {
                            return Container(
                              height: height,
                              child: Image.asset("assets/images/no_data.gif"),
                            );
                          } else {
                            searchList = list;
                          }
                        }
                      }
                      if (state is GetCheckBoxState) {
                        searchList[state.index].check = state.check;
                      }
                      if(state is GetDecrementState){
                        searchList[state.index].count -= state.count;
                      }
                      if(state is GetIncrementState){
                        searchList[state.index].count += state.count;
                        searchAllBloc.add(GetCheckBoxEvent(check: true, index: state.index));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          String variantName = "";
                          ProductModel product = searchList[index];
                          if (product.productOption.isNotEmpty) {
                            for (int i = 0; i < product.productOption.length; i++) {
                              if (product.productOption.length - 1 == i)
                                variantName += product.productOption[i].value.toString();
                              else
                                variantName += product.productOption[i].value.toString() + ", ";
                            }
                          }
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: Offset(0.0, 0.0), //(x,y)
                                  blurRadius:7.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: searchList[index].productImages.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: searchList[index].productImages[0].productImage.isNotEmpty
                                                    ? Image(
                                                        height: 55,
                                                        width: 55,
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            "${searchList[index].productImages[0].productImage}"),
                                                      )
                                                    : Image(
                                                        image: NetworkImage("${searchList[index].categoryImage}"),
                                                        height: 55,
                                                        width: 55,
                                                        fit: BoxFit.contain,
                                                      ),
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image(
                                                  image: NetworkImage("${searchList[index].categoryImage}"),
                                                  height: 55,
                                                  width: 55,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: width * 0.45,
                                                  child: variantName.isEmpty
                                                      ? Text(
                                                          "${searchList[index].productName} ",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: TextBlackLight, fontWeight: FontWeight.bold, fontSize: 15),

                                                        )
                                                      : Text(
                                                          "${searchList[index].productName} ($variantName)",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: TextBlackLight, fontWeight: FontWeight.bold, fontSize: 15),

                                                        ),
                                                ),
                                                searchList[index].check != true
                                                    ? InkWell(
                                                  onTap: () async {
                                                    if (await Network.isConnected()) {
                                                      searchAllBloc.add(GetCheckBoxEvent(check: true, index: index));
                                                      selectedProductList = searchList[index];
                                                    } else {
                                                      Utility.showToast(
                                                        msg: "please_check_your_internet_connection_key".tr(),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 71,
                                                    decoration: BoxDecoration(
                                                        color: Buttonactive,
                                                        borderRadius: BorderRadius.circular(25),
                                                        border: Border.all(color: ColorPrimary)),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "add_key".tr(),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                color: ColorPrimary),
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Icon(
                                                            Icons.add,
                                                            size: 18,
                                                            color: ColorPrimary,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    : Container(
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    // color: Colors.amber,
                                                      borderRadius: BorderRadius.circular(25),
                                                      border: Border.all(color: ColorPrimary)),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 23,
                                                        child: IconButton(
                                                            padding: EdgeInsets.all(0),
                                                            onPressed: () async {
                                                              if (await Network.isConnected()) {
                                                                searchAllBloc.add(
                                                                    GetDecrementEvent(
                                                                        index: index, count: 1));
                                                                if (searchList[index].count <=1) {
                                                                  searchAllBloc.add(GetCheckBoxEvent(check: false, index: index));
                                                                }
                                                              } else {
                                                                Utility.showToast(
                                                                  msg: "please_check_your_internet_connection_key",
                                                                );
                                                              }
                                                            },
                                                            iconSize: 20,
                                                            splashRadius: 10,
                                                            icon: Icon(
                                                              Icons.remove,
                                                            )),
                                                      ),
                                                      Container(
                                                        width: 23,
                                                        color: ColorPrimary,
                                                        child: Center(
                                                          child: AutoSizeText(
                                                            "${searchList[index].count}",
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                            ),
                                                            maxFontSize: 14,
                                                            minFontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 23,
                                                        child: IconButton(
                                                            padding: EdgeInsets.all(0),
                                                            onPressed: () async {
                                                              if (await Network.isConnected()) {
                                                                searchAllBloc.add(
                                                                    GetIncrementEvent(
                                                                        index: index, count: 1));
                                                              } else {
                                                                Utility.showToast(
                                                                  msg: "please_check_your_internet_connection_key",
                                                                );
                                                              }
                                                            },
                                                            iconSize: 20,
                                                            splashRadius: 10,
                                                            icon: Icon(
                                                              Icons.add,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Container(
                                              width: width * 0.71,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  new RichText(
                                                    text: new TextSpan(
                                                      text:
                                                          '\u20B9 ${double.parse(searchList[index].sellingPrice) * searchList[index].count}  ',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold, color: ColorPrimary,fontSize: 18),
                                                      children: <TextSpan>[
                                                        new TextSpan(
                                                          text:
                                                              '\u20B9${double.parse(searchList[index].mrp) * searchList[index].count}',
                                                          style: new TextStyle(
                                                            color: TextGrey,
                                                            fontSize: 13,
                                                            decoration: TextDecoration.lineThrough,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "earn_key".tr() + ": ",
                                                        style: TextStyle(
                                                            fontSize: 13, fontWeight: FontWeight.bold, color: TextGrey),
                                                      ),
                                                      Container(
                                                          child: Image.asset(
                                                            "assets/images/point.png",
                                                            height: 13,
                                                            width: 13,
                                                          )),
                                                      Text(
                                                        " ${(double.parse(searchList[index].earningCoins) * searchList[index].count).toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                            fontSize: 13, fontWeight: FontWeight.bold, color: ColorPrimary),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ]),
              ),
              bottomNavigationBar: GestureDetector(
                onTap: () async {
                  List<ProductModel> product = searchList.where((element) => element.check).toList();
                  log("$product");
                  if (await Network.isConnected()) {
                    // Navigator.pop(context);
                    if (product.length == 0) {
                      Utility.showToast(msg: "please_atleast_one_product_key".tr());
                    } else {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: BillingProducts(
                                billingItemList: product,
                                mobile: widget.mobile,
                                coin: double.parse(widget.coin),
                              ),
                              type: PageTransitionType.fade));
                    }
                  } else {
                    Utility.showToast(
                      msg: "please_check_your_internet_connection_key",
                    );
                  }
                },
                child: Container(
                  width: width,
                  color: ColorPrimary,
                  child: Center(
                    child: Text(
                      "done_key".tr(),
                      style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  height: height * 0.07,
                ),
              ));
        },
      ),
    );
  }

  void _showModal(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return SizeColorBottomSheet();
      },
    );
  }
}

class SizeColorBottomSheet extends StatefulWidget {
  SizeColorBottomSheet({Key? key}) : super(key: key);

  @override
  _SizeColorBottomSheetState createState() => _SizeColorBottomSheetState();
}

class _SizeColorBottomSheetState extends State<SizeColorBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              "size_key".tr(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 30,
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(children: [
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(50)),
                      child: Center(child: Text("m_key".tr())),
                    ),
                  ]);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              "color_key".tr(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 30,
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(children: [
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: ColorPrimary, borderRadius: BorderRadius.circular(50)),
                      child: Center(
                          child: Icon(
                        Icons.check,
                        color: Colors.white,
                      )),
                    ),
                  ]);
                }),
          ),
          SizedBox(height: 40),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel_key".tr(),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "done_key".tr(),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ColorPrimary),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

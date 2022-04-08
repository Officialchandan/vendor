import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billingproducts/billing_products.dart';
import 'package:vendor/ui/billingflow/search_all/search_all_event.dart';
import 'package:vendor/ui/billingflow/search_all/search_all_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';

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
                      if (state is GetSearchState) {
                        log("chal pdi api");
                      }
                      if (state is GetSearchFailureState) {
                        Fluttertoast.showToast(msg: state.message, backgroundColor: ColorPrimary);
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
                          child: CircularProgressIndicator(
                            backgroundColor: ColorPrimary,
                          ),
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
                          // for (int i = 0; i < product  ``s.length; i++) {
                          //   if (products[i]
                          //       .productName
                          //       .toLowerCase()
                          //       .contains(state.searchword.toLowerCase())) {
                          //     list.add(products[i]);
                          //     log("how much -->${state.searchword}");
                          //   }
                          // }

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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ListView.builder(
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
                            return Stack(
                              children: [
                                Container(
                                  height: searchList[index].productName.length + variantName.length > 30 ? 110 : 98,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
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
                                                              fit: BoxFit.cover,
                                                            ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image(
                                                        image: NetworkImage("${searchList[index].categoryImage}"),
                                                        height: 55,
                                                        width: 55,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Container(
                                                height: searchList[index].productName.length + variantName.length > 30
                                                    ? 68
                                                    : 48,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: width * 0.60,
                                                          child: variantName.isEmpty
                                                              ? AutoSizeText(
                                                                  "${searchList[index].productName} ",
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      color: Colors.black, fontWeight: FontWeight.w600),
                                                                  maxFontSize: 15,
                                                                  minFontSize: 12,
                                                                )
                                                              : AutoSizeText(
                                                                  "${searchList[index].productName} ($variantName)",
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      color: Colors.black, fontWeight: FontWeight.w600),
                                                                  maxFontSize: 15,
                                                                  minFontSize: 12,
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: width * 0.71,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              new RichText(
                                                                text: new TextSpan(
                                                                  text:
                                                                      '\u20B9 ${double.parse(searchList[index].sellingPrice) * searchList[index].count}  ',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold, color: ColorPrimary),
                                                                  children: <TextSpan>[
                                                                    new TextSpan(
                                                                      text:
                                                                          '\u20B9${double.parse(searchList[index].mrp) * searchList[index].count}',
                                                                      style: new TextStyle(
                                                                        color: Colors.grey,
                                                                        decoration: TextDecoration.lineThrough,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 22,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(25),
                                                                border: Border.all(color: Colors.black)),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                BlocBuilder<SearchAllBloc, SearchAllState>(
                                                                  builder: (context, state) {
                                                                    if (state is GetDecrementState) {
                                                                      searchList[index].count = state.count;
                                                                    }
                                                                    return Container(
                                                                      height: 20,
                                                                      width: 22,
                                                                      child: IconButton(
                                                                          padding: EdgeInsets.all(0),
                                                                          onPressed: () async {
                                                                            if (await Network.isConnected()) {
                                                                              if (searchList[index].count > 1) {
                                                                                searchAllBloc.add(GetIncrementEvent(
                                                                                    count: searchList[index].count--));
                                                                              }
                                                                            } else {
                                                                              Fluttertoast.showToast(
                                                                                  msg:
                                                                                      "please_check_your_internet_connection_key"
                                                                                          .tr(),
                                                                                  backgroundColor: ColorPrimary);
                                                                            }
                                                                          },
                                                                          iconSize: 20,
                                                                          splashRadius: 10,
                                                                          icon: Icon(
                                                                            Icons.remove,
                                                                          )),
                                                                    );
                                                                  },
                                                                ),
                                                                Container(
                                                                  width: 22,
                                                                  height: 22,
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
                                                                BlocBuilder<SearchAllBloc, SearchAllState>(
                                                                  builder: (context, state) {
                                                                    if (state is GetDecrementState) {
                                                                      searchList[index].count = state.count;
                                                                    }
                                                                    return Container(
                                                                      height: 20,
                                                                      width: 22,
                                                                      child: IconButton(
                                                                          padding: EdgeInsets.all(0),
                                                                          onPressed: () async {
                                                                            log("true===>$count");
                                                                            if (await Network.isConnected()) {
                                                                              searchAllBloc.add(GetIncrementEvent(
                                                                                  count: searchList[index].count++));
                                                                              searchAllBloc.add(GetCheckBoxEvent(
                                                                                  check: true, index: index));
                                                                            } else {
                                                                              Fluttertoast.showToast(
                                                                                  msg:
                                                                                      "please_check_your_internet_connection_key"
                                                                                          .tr(),
                                                                                  backgroundColor: ColorPrimary);
                                                                            }
                                                                          },
                                                                          iconSize: 20,
                                                                          splashRadius: 10,
                                                                          icon: Icon(
                                                                            Icons.add,
                                                                          )),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "redeem_key".tr() + ": ",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey),
                                                        ),
                                                        Container(
                                                            child: Image.asset(
                                                          "assets/images/point.png",
                                                          width: 13,
                                                          height: 13,
                                                        )),
                                                        Text(
                                                          " ${(double.parse(searchList[index].redeemCoins) * searchList[index].count).toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: ColorPrimary),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "earn_key".tr() + ": ",
                                                  style: TextStyle(
                                                      fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey),
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
                                                      fontSize: 12, fontWeight: FontWeight.w700, color: ColorPrimary),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 14,
                                  child: BlocBuilder<SearchAllBloc, SearchAllState>(
                                    builder: (context, state) {
                                      if (state is GetCheckBoxState) {
                                        searchList[state.index].check = state.check;
                                      }

                                      return Checkbox(
                                        side: BorderSide(color: Colors.black87),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                                        // checkColor: Colors.indigo,
                                        value: searchList[index].check,
                                        activeColor: ColorPrimary,
                                        onChanged: (newvalue) async {
                                          if (await Network.isConnected()) {
                                            log("true===>");
                                            searchAllBloc.add(GetCheckBoxEvent(check: newvalue!, index: index));
                                            selectedProductList = searchList[index];
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "please_check_your_internet_connection_key".tr(),
                                                backgroundColor: ColorPrimary);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  BlocBuilder<SearchAllBloc, SearchAllState>(
                    builder: (context, state) {
                      return searchList.isEmpty
                          ? Container()
                          : Positioned(
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  List<ProductModel> product = searchList.where((element) => element.check).toList();
                                  log("$product");
                                  if (await Network.isConnected()) {
                                    // Navigator.pop(context);
                                    if (product.length == 0) {
                                      Fluttertoast.showToast(
                                          msg: "please_atleast_one_product_key".tr(), backgroundColor: ColorPrimary);
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
                                    Fluttertoast.showToast(
                                        msg: "please_check_your_internet_connection_key",
                                        backgroundColor: Colors.amber);
                                  }
                                },
                                child: Container(
                                  width: width,
                                  color: ColorPrimary,
                                  child: Center(
                                    child: Text(
                                      "done_key".tr(),
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  height: height * 0.07,
                                ),
                              ));
                    },
                  )
                ]),
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

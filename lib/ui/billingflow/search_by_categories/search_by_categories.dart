import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billingproducts/billing_products.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_bloc.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_event.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';

class SearchByCategory extends StatefulWidget {
  String catid;
  var mobile;
  var coin;
  SearchByCategory(
      {required this.catid, required this.mobile, required this.coin});

  @override
  _SearchByCategoryState createState() =>
      _SearchByCategoryState(this.catid, this.mobile, this.coin);
}

class _SearchByCategoryState extends State<SearchByCategory> {
  TextEditingController _textFieldController = TextEditingController();

  _SearchByCategoryState(String catid, mobile, coin);
  int count = 1;
  List<ProductModel> products = [];
  List<ProductModel> searchList = [];
  SearchByCategoriesBloc searchByCategoriesBloc = SearchByCategoriesBloc();

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
    searchByCategoriesBloc
        .add(GetProductsSearchByCategoriesEvent(input: widget.catid));
    // ApiProvider().getProductByCategories(widget.catid);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocProvider<SearchByCategoriesBloc>(
      create: (context) => searchByCategoriesBloc,
      child: BlocConsumer<SearchByCategoriesBloc, SearchByCategoriesState>(
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
                    hintText: "Search_key".tr(),
                    hintStyle: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (text) {
                    searchByCategoriesBloc
                        .add(FindSearchByCategoriesEvent(searchkeyword: text));
                  },
                ),
                leadingWidth: 30,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios))),
            body: Container(
              child: Stack(
                children: [
                  BlocConsumer<SearchByCategoriesBloc, SearchByCategoriesState>(
                    listener: (context, state) {
                      if (State is SearchByCategoriesInitialState) {
                        searchByCategoriesBloc.add(
                            GetProductsSearchByCategoriesEvent(
                                input: widget.catid));
                      }
                      if (state is GetSearchByCategoriesState) {
                        log("chal pdi api");
                      }
                      if (state is GetSearchByCategoriesFailureState) {
                        Fluttertoast.showToast(
                            msg: state.message, backgroundColor: ColorPrimary);
                      }
                    },
                    builder: (context, state) {
                      if (state is GetSearchByCategoriesState) {
                        products = state.data!;
                        searchList = products;
                        log("${products.length}");
                      }
                      if (state is GetSearchByCategoriesLoadingState) {
                        return Center(
                          child: Container(
                            height: 40,
                            child: CircularProgressIndicator(
                              backgroundColor: ColorPrimary,
                            ),
                          ),
                        );
                      }

                      if (state is SearchByCategoriesSearchState) {
                        if (state.searchword.isEmpty) {
                          searchList = products;
                        } else {
                          List<ProductModel> list = [];
                          for (int i = 0; i < products.length; i++) {
                            if (products[i]
                                .productName
                                .toLowerCase()
                                .contains(state.searchword.toLowerCase())) {
                              list.add(products[i]);
                              log("how much -->${state.searchword}");
                            }
                          }

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
                        padding: const EdgeInsets.only(bottom: 50.0, top: 10),
                        child: ListView.builder(
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            String variantName = "";
                            ProductModel product = searchList[index];
                            if (product.productOption.isNotEmpty) {
                              for (int i = 0;
                                  i < product.productOption.length;
                                  i++) {
                                if (product.productOption.length - 1 == i)
                                  variantName +=
                                      product.productOption[i].value.toString();
                                else
                                  variantName += product.productOption[i].value
                                          .toString() +
                                      ", ";
                              }
                            }
                            return Stack(
                              children: [
                                Container(
                                  height: 100,
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 30, right: 10),
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
                                  child: ListTile(
                                    minLeadingWidth: 20,
                                    contentPadding: EdgeInsets.only(left: 70),
                                    title: Container(
                                      transform:
                                          Matrix4.translationValues(0, -2, 0),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: width * 0.66,
                                                  child: AutoSizeText(
                                                    "${searchList[index].productName} ($variantName)",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    maxFontSize: 14,
                                                    minFontSize: 11,
                                                  ),
                                                ),
                                              ]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              new RichText(
                                                text: new TextSpan(
                                                  text:
                                                      '\u20B9 ${double.parse(searchList[index].sellingPrice) * searchList[index].count}  ',
                                                  style: TextStyle(
                                                      color: ColorPrimary),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                      text:
                                                          '\u20B9${double.parse(searchList[index].mrp) * searchList[index].count}',
                                                      style: new TextStyle(
                                                        color: Colors.grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment.end,
                                              //     children: [
                                              //       searchList[index]
                                              //                   .productOption
                                              //                   .length >=
                                              //               1
                                              //           ? Text(
                                              //               "${searchList[index].productOption[0].optionName} ${searchList[index].productOption[0].value}",
                                              //               style: TextStyle(
                                              //                   fontSize: 15,
                                              //                   color:
                                              //                       ColorTextPrimary),
                                              //             )
                                              //           : Text(
                                              //               "${searchList[index].productOption.length}",
                                              //               style: TextStyle(
                                              //                   fontSize: 15,
                                              //                   color:
                                              //                       ColorTextPrimary),
                                              //             ),
                                              //       SizedBox(
                                              //         width: 10,
                                              //       ),
                                              //     ]),
                                            ],
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      // color: Colors.amber,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  height: 20,
                                                  // width: 90,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      BlocBuilder<
                                                          SearchByCategoriesBloc,
                                                          SearchByCategoriesState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is GetSearchByCategoriesDecrementState) {
                                                            searchList[index]
                                                                    .count =
                                                                state.count;
                                                          }
                                                          return Container(
                                                            height: 20,
                                                            width: 30,
                                                            child: IconButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                onPressed:
                                                                    () async {
                                                                  log("true===>$count");
                                                                  if (await Network
                                                                      .isConnected()) {
                                                                    searchList[index].count >
                                                                            1
                                                                        ? searchByCategoriesBloc.add(GetIncrementSearchByCategoriesEvent(
                                                                            count: searchList[index]
                                                                                .count--))
                                                                        : Fluttertoast.showToast(
                                                                            msg:
                                                                                "Product_cant_be_in_negative_key".tr());
                                                                  } else {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "please_turn_on_internet_key",
                                                                        backgroundColor:
                                                                            ColorPrimary);
                                                                  }
                                                                },
                                                                iconSize: 20,
                                                                splashRadius:
                                                                    10,
                                                                icon: Icon(
                                                                  Icons.remove,
                                                                )),
                                                          );
                                                        },
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        color: ColorPrimary,
                                                        child: Center(
                                                          child: AutoSizeText(
                                                            "${searchList[index].count}",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            maxFontSize: 14,
                                                            minFontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                      BlocBuilder<
                                                          SearchByCategoriesBloc,
                                                          SearchByCategoriesState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is GetSearchByCategoriesDecrementState) {
                                                            searchList[index]
                                                                    .count =
                                                                state.count;
                                                          }
                                                          return Container(
                                                            height: 20,
                                                            width: 30,
                                                            child: IconButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                onPressed:
                                                                    () async {
                                                                  log("true===>$count");

                                                                  if (await Network
                                                                      .isConnected()) {
                                                                    // searchList[index].count <
                                                                    //         searchList[index]
                                                                    //             .stock
                                                                    //     ?
                                                                    searchByCategoriesBloc.add(
                                                                        GetIncrementSearchByCategoriesEvent(
                                                                            count:
                                                                                searchList[index].count++));
                                                                    // : Fluttertoast.showToast(
                                                                    //     msg:
                                                                    //         "Stock Limit reached",
                                                                    //     backgroundColor:
                                                                    //         ColorPrimary);
                                                                  } else {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "please_turn_on_internet_key",
                                                                        backgroundColor:
                                                                            ColorPrimary);
                                                                  }
                                                                },
                                                                iconSize: 20,
                                                                splashRadius:
                                                                    10,
                                                                icon: Icon(
                                                                  Icons.add,
                                                                )),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        child: Image.asset(
                                                      "assets/images/point.png",
                                                      scale: 2.5,
                                                    )),
                                                    Text(
                                                      " ${double.parse(searchList[index].earningCoins) * searchList[index].count}",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: ColorPrimary),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                )
                                              ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 25,
                                  left: 0,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 30, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: searchList[index]
                                            .productImages
                                            .isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: searchList[index]
                                                    .productImages[0]
                                                    .productImage
                                                    .isNotEmpty
                                                ? Image(
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(
                                                        "${searchList[index].productImages[0].productImage}"),
                                                  )
                                                : Image(
                                                    image: AssetImage(
                                                      "assets/images/placeholder.webp",
                                                    ),
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image(
                                              image: AssetImage(
                                                "assets/images/placeholder.webp",
                                              ),
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),

                                    // child: Image.asset(
                                    //   "assets/images/wallpaperflare.com_wallpaper.jpg",
                                    //   fit: BoxFit.fill,
                                    //   height: 80,
                                    //   width: 80,
                                    // ),
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  right: 20,
                                  child: BlocBuilder<SearchByCategoriesBloc,
                                      SearchByCategoriesState>(
                                    builder: (context, state) {
                                      if (state
                                          is GetSearchByCategoriesCheckBoxState) {
                                        searchList[state.index].check =
                                            state.check;
                                      }
                                      return Container(
                                        height: 18,
                                        width: 18,
                                        color: Colors.white,
                                        child: Checkbox(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          // checkColor: Colors.indigo,
                                          value: searchList[index].check,
                                          activeColor: ColorPrimary,
                                          onChanged: (newvalue) async {
                                            log("true===>");
                                            if (await Network.isConnected()) {
                                              searchByCategoriesBloc.add(
                                                  GetCheckBoxSearchByCategoriesEvent(
                                                      check: newvalue!,
                                                      index: index));
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "please_turn_on_internet_key",
                                                  backgroundColor:
                                                      ColorPrimary);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],

                              //   ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  BlocBuilder<SearchByCategoriesBloc, SearchByCategoriesState>(
                    builder: (context, state) {
                      return searchList.isEmpty
                          ? Container()
                          : Positioned(
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  List<ProductModel> product = searchList
                                      .where((element) => element.check)
                                      .toList();
                                  log("$product");
                                  if (await Network.isConnected()) {
                                    // Navigator.pop(context);
                                    if (product.length == 0) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please_select_atlest_one_product_key"
                                                  .tr(),
                                          backgroundColor: ColorPrimary);
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
                                        msg: "please_turn_on_internet_key",
                                        backgroundColor: ColorPrimary);
                                  }
                                },
                                child: Container(
                                  width: width,
                                  color: ColorPrimary,
                                  child: Center(
                                    child: Text(
                                      "DONE_key".tr(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  height: height * 0.07,
                                ),
                              ));
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

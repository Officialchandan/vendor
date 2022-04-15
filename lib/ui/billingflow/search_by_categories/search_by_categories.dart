import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billingproducts/billing_products.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_bloc.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_event.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class SearchByCategory extends StatefulWidget {
  String catid;
  var mobile;
  var coin;
  SearchByCategory({required this.catid, required this.mobile, required this.coin});

  @override
  _SearchByCategoryState createState() => _SearchByCategoryState(this.catid, this.mobile, this.coin);
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
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  refresh() {
    log("refresh hua");
    searchByCategoriesBloc.add(GetProductsSearchByCategoriesEvent(input: widget.catid));
    _refreshController.refreshCompleted();

    //setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    subject.close();
  }

  @override
  void initState() {
    super.initState();
    searchByCategoriesBloc.add(GetProductsSearchByCategoriesEvent(input: widget.catid));
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
                    searchByCategoriesBloc.add(FindSearchByCategoriesEvent(searchkeyword: text));
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
                        searchByCategoriesBloc.add(GetProductsSearchByCategoriesEvent(input: widget.catid));
                      }
                      if (state is GetSearchByCategoriesState) {}
                      // if (state is GetSearchByCategoriesFailureState) {
                      //   Utility.showToast(msg: state.message, backgroundColor: ColorPrimary);
                      // }
                    },
                    builder: (context, state) {
                      log("state---->$state");
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
                      if (state is GetSearchByCategoriesFailureState) {
                        return Center(
                          child: Image.asset("assets/images/no_data.gif"),
                        );
                      }

                      if (state is SearchByCategoriesSearchState) {
                        if (state.searchword.isEmpty) {
                          searchList = products;
                        } else {
                          List<ProductModel> list = [];
                          for (int i = 0; i < products.length; i++) {
                            if (products[i].productName.toLowerCase().contains(state.searchword.toLowerCase())) {
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
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 10, top: 5),
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
                                  height: searchList[index].productName.length + variantName.length > 30 ? 105 : 98,
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
                                                      borderRadius: BorderRadius.circular(10),
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
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                                // color: Colors.amber,
                                                                borderRadius: BorderRadius.circular(25),
                                                                border: Border.all(color: Colors.black)),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                BlocBuilder<SearchByCategoriesBloc,
                                                                    SearchByCategoriesState>(
                                                                  builder: (context, state) {
                                                                    if (state is GetSearchByCategoriesDecrementState) {
                                                                      searchList[index].count = state.count;
                                                                    }
                                                                    return Container(
                                                                      height: 20,
                                                                      width: 20,
                                                                      child: IconButton(
                                                                          padding: EdgeInsets.all(0),
                                                                          onPressed: () async {
                                                                            log("true===>$count");
                                                                            if (await Network.isConnected()) {
                                                                              searchList[index].count > 1
                                                                                  ? searchByCategoriesBloc.add(
                                                                                      GetIncrementSearchByCategoriesEvent(
                                                                                          count: searchList[index]
                                                                                              .count--))
                                                                                  : Utility.showToast(
                                                                                      msg:
                                                                                          "product_cant_be_negative_key"
                                                                                              .tr(),
                                                                                    );
                                                                            } else {
                                                                              Utility.showToast(
                                                                                msg:
                                                                                    "please_check_your_internet_connection_key",
                                                                              );
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
                                                                  width: 20,
                                                                  height: 20,
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
                                                                BlocBuilder<SearchByCategoriesBloc,
                                                                    SearchByCategoriesState>(
                                                                  builder: (context, state) {
                                                                    if (state is GetSearchByCategoriesDecrementState) {
                                                                      searchList[index].count = state.count;
                                                                    }
                                                                    return Container(
                                                                      height: 20,
                                                                      width: 20,
                                                                      child: IconButton(
                                                                          padding: EdgeInsets.all(0),
                                                                          onPressed: () async {
                                                                            log("true===>$count");

                                                                            if (await Network.isConnected()) {
                                                                              // searchList[index].count <
                                                                              //         searchList[index]
                                                                              //             .stock
                                                                              //     ?
                                                                              searchByCategoriesBloc.add(
                                                                                  GetIncrementSearchByCategoriesEvent(
                                                                                      count:
                                                                                          searchList[index].count++));
                                                                              // : Utility.showToast(
                                                                              //     msg:
                                                                              //         "Stock Limit reached",
                                                                              //     backgroundColor:
                                                                              //         ColorPrimary);
                                                                            } else {
                                                                              Utility.showToast(
                                                                                msg:
                                                                                    "please_check_your_internet_connection_key",
                                                                              );
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
                                            )
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
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 14,
                                  child: BlocBuilder<SearchByCategoriesBloc, SearchByCategoriesState>(
                                    builder: (context, state) {
                                      if (state is GetSearchByCategoriesCheckBoxState) {
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
                                            searchByCategoriesBloc.add(
                                                GetCheckBoxSearchByCategoriesEvent(check: newvalue!, index: index));
                                          } else {
                                            Utility.showToast(
                                              msg: "please_check_your_internet_connection_key".tr(),
                                            );
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
                  BlocBuilder<SearchByCategoriesBloc, SearchByCategoriesState>(
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
                                      Utility.showToast(
                                        msg: "please_select_atlest_one_product_key".tr(),
                                      );
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
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

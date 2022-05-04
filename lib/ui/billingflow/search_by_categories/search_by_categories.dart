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
  final String firstName;
  final String lastName;

  SearchByCategory({required this.catid, required this.mobile, required this.coin, required this.firstName, required this.lastName});

  @override
  _SearchByCategoryState createState() => _SearchByCategoryState(this.catid, this.mobile, this.coin);
}

class _SearchByCategoryState extends State<SearchByCategory> {
  TextEditingController _textFieldController = TextEditingController();

  _SearchByCategoryState(String catid, mobile, coin);

  int count = 1;
  List<ProductModel> products = [];
  List<ProductModel> searchList = [];
  ProductModel? selectedProductList;
  SearchByCategoriesBloc searchByCategoriesBloc = SearchByCategoriesBloc();

  final PublishSubject<List<ProductModel>> subject = PublishSubject();
  String searchText = "";
  bool searching = false;
  TextEditingController _searchController = TextEditingController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  refresh() {
    searchByCategoriesBloc.add(ProductsSearchByCategoriesEvent(input: widget.catid));
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
    searchByCategoriesBloc.add(ProductsSearchByCategoriesEvent(input: widget.catid));
    // ApiProvider().getProductByCategories(widget.catid);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocProvider<SearchByCategoriesBloc>(
      create: (context) => searchByCategoriesBloc,
      child: Scaffold(
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
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: refresh(),
          child: BlocBuilder<SearchByCategoriesBloc, SearchByCategoriesState>(
            builder: (context, state) {
              log("State is $state");
              if (State is SearchByCategoriesInitialState) {
                searchByCategoriesBloc.add(ProductsSearchByCategoriesEvent(input: widget.catid));
              }
              if (state is SearchByCategoriesLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetSearchByCategoriesState) {
                products = state.data!;
                searchList = products;
              }
              if (state is SearchByCategoriesFailureState) {
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
              if (state is SearchByCategoriesDecrementState) {
                searchList[state.index].count -= state.count;
              }
              if (state is SearchByCategoriesIncrementState) {
                searchList[state.index].count += state.count;
                searchByCategoriesBloc.add(CheckBoxSearchByCategoriesEvent(check: true, index: state.index));
              }
              if (state is SearchByCategoriesCheckBoxState) {
                searchList[state.index].check = state.check;
              }

              return ListView.builder(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                                image:
                                                    NetworkImage("${searchList[index].productImages[0].productImage}"),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                    searchByCategoriesBloc.add(
                                                        CheckBoxSearchByCategoriesEvent(check: true, index: index));
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
                                                              searchByCategoriesBloc.add(
                                                                SearchByCategoriesDecrementEvent(
                                                                    index: index, count: 1));
                                                              if (searchList[index].count <=1) {
                                                                searchByCategoriesBloc.add(CheckBoxSearchByCategoriesEvent(check: false, index: index));
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
                                                              searchByCategoriesBloc.add(
                                                                  SearchByCategoriesIncrementEvent(
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              new RichText(
                                                text: new TextSpan(
                                                  text:
                                                      '\u20B9 ${double.parse(searchList[index].sellingPrice) * searchList[index].count}  ',
                                                  style: TextStyle(
                                                      fontSize: 18, fontWeight: FontWeight.bold, color: ColorPrimary),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                      text:
                                                          '\u20B9${double.parse(searchList[index].mrp) * searchList[index].count}',
                                                      style: new TextStyle(
                                                        fontSize: 13,
                                                        color: TextGrey,
                                                        decoration: TextDecoration.lineThrough,
                                                      ),
                                                    ),
                                                  ],
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
                                                    fontSize: 13, fontWeight: FontWeight.bold, color: ColorTextPrimary),
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
                              )
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
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                            firstName: widget.firstName,
                            lastName: widget.lastName,
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
          ),
        ),
      ),
    );
  }
}

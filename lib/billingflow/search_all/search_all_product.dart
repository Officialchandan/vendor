import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/billingflow/search_all/search_all_bloc.dart';
import 'package:vendor/billingflow/search_all/search_all_event.dart';
import 'package:vendor/billingflow/search_all/search_all_state.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/utility/color.dart';

class SearchAllProduct extends StatefulWidget {
  SearchAllProduct({Key? key}) : super(key: key);

  @override
  _SearchAllProductState createState() => _SearchAllProductState();
}

class _SearchAllProductState extends State<SearchAllProduct> {
  int count = 1;
  SearchAllBloc searchAllBloc = SearchAllBloc();
  List<ProductModel> products = [];
  List<ProductModel> searchList = [];

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
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
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
                  BlocConsumer<SearchAllBloc, SearchAllState>(listener: (context, state) {
                    if (state is SearchAllIntialState) {
                      searchAllBloc.add(GetProductsEvent());
                    }
                    if (state is GetSearchState) {
                      log("chal pdi api");
                    }
                    if (state is GetSearchFailureState) {
                      Fluttertoast.showToast(msg: state.message, backgroundColor: ColorPrimary);
                    }
                  }, builder: (context, state) {
                    if (state is GetSearchState) {
                      products = state.data!;
                      searchList = products;
                      log("${products.length}");
                    }
                    if (state is GetSearchLoadingState) {
                      return Center(
                        child: Container(
                          height: 40,
                          child: CircularProgressIndicator(
                            backgroundColor: ColorPrimary,
                          ),
                        ),
                      );
                    }

                    if (state is CategoriesSearchState) {
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
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: ListView.builder(
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                height: 100,
                                margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 10),
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
                                    transform: Matrix4.translationValues(0, -2, 0),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${searchList[index].productName}",
                                              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                    child: Image.asset(
                                                  "assets/images/point.png",
                                                  scale: 2.5,
                                                )),
                                                Text(
                                                  " ${searchList[index].earningCoins}",
                                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: ColorPrimary),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            new RichText(
                                              text: new TextSpan(
                                                text: '\u20B9 ${searchList[index].sellingPrice}  ',
                                                style: TextStyle(color: ColorPrimary),
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                    text: '\u20B9${searchList[index].mrp}',
                                                    style: new TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                              searchList[index].productOption.length >= 1
                                                  ? Text(
                                                      "${searchList[index].productOption[0].optionName} ${searchList[index].productOption[0].value}",
                                                      style: TextStyle(fontSize: 15, color: ColorTextPrimary),
                                                    )
                                                  : Text(
                                                      "${searchList[index].productOption.length}",
                                                      style: TextStyle(fontSize: 15, color: ColorTextPrimary),
                                                    ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ]),
                                          ],
                                        ),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                // color: Colors.amber,
                                                borderRadius: BorderRadius.circular(25),
                                                border: Border.all(color: Colors.black)),
                                            height: 20,
                                            // width: 90,
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
                                                      width: 30,
                                                      child: IconButton(
                                                          padding: EdgeInsets.all(0),
                                                          onPressed: () {
                                                            log("true===>$count");
                                                            searchList[index].count > 1
                                                                ? searchAllBloc
                                                                    .add(GetIncrementEvent(count: searchList[index].count--))
                                                                : Fluttertoast.showToast(msg: "Product cant be in negative");
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
                                                    child: Text(
                                                      "${searchList[index].count}",
                                                      style: TextStyle(color: Colors.white, fontSize: 14),
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
                                                      width: 30,
                                                      child: IconButton(
                                                          padding: EdgeInsets.all(0),
                                                          onPressed: () {
                                                            log("true===>$count");
                                                            searchList[index].count < searchList[index].stock
                                                                ? searchAllBloc
                                                                    .add(GetIncrementEvent(count: searchList[index].count++))
                                                                : Fluttertoast.showToast(
                                                                    msg: "Stock Limit reached", backgroundColor: ColorPrimary);
                                                          },
                                                          iconSize: 20,
                                                          splashRadius: 10,
                                                          icon: Icon(
                                                            Icons.add,
                                                          )),
                                                    );
                                                  },
                                                ),
                                                // InkWell(
                                                //   onTap: () {
                                                //     _showModal(context);
                                                //   },
                                                //   child: Container(
                                                //     padding:
                                                //         EdgeInsets.only(left: 3),
                                                //     decoration: BoxDecoration(
                                                //       color: ColorPrimary,
                                                //       borderRadius:
                                                //           BorderRadius.circular(25),
                                                //     ),
                                                //     height: 20,
                                                //     child: Row(
                                                //       mainAxisSize:
                                                //           MainAxisSize.min,
                                                //       children: [
                                                //         Container(
                                                //             height: 17,
                                                //             width: 17,
                                                //             decoration: BoxDecoration(
                                                //                 color: Colors.white,
                                                //                 borderRadius:
                                                //                     BorderRadius
                                                //                         .circular(
                                                //                             50)),
                                                //             child: Icon(
                                                //               Icons.add_outlined,
                                                //               size: 15,
                                                //             )),
                                                //         Text(
                                                //           "  ADD  ",
                                                //           style: TextStyle(
                                                //               color: Colors.white,
                                                //               fontSize: 12),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                            searchList[index].productOption.length >= 2
                                                ? Text(
                                                    "${searchList[index].productOption[1].optionName} ${searchList[index].productOption[1].value}",
                                                    style: TextStyle(fontSize: 15, color: ColorTextPrimary),
                                                  )
                                                : Text(
                                                    "${searchList[index].productOption.length}",
                                                    style: TextStyle(fontSize: 15, color: ColorTextPrimary),
                                                  ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ]),
                                        ]),
                                      ],
                                    ),
                                  ),
                                  // trailing: ButtonTheme(
                                  //   minWidth: 80,
                                  //   height: 32,
                                  //   // ignore: deprecated_member_use
                                  //   child: RaisedButton(
                                  //     padding: EdgeInsets.all(0),
                                  //     color: Color.fromRGBO(102, 87, 244, 1),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(7),
                                  //     ),
                                  //     onPressed: () async {
                                  //       FocusScope.of(context).unfocus();
                                  //       //int id;
                                  //       // if (_tap == true) {
                                  //       //   _tap = false;
                                  //       //   getVendorId(
                                  //       //       category[index].id, category[index].categoryName);
                                  //       // }
                                  //     },
                                  //     child: Text(
                                  //       "See Category",
                                  //       style: TextStyle(
                                  //           color: Colors.white,
                                  //           fontSize: 12,
                                  //           fontWeight: FontWeight.w600),
                                  //     ),
                                  //   ),
                                  //  ),
                                ),
                              ),
                              Positioned(
                                top: 25,
                                left: 0,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 30, bottom: 10),

                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: searchList[index].productImages.isEmpty
                                            ? NetworkImage(
                                                "https://www.google.com/imgres?imgurl=https%3A%2F%2Fimage.shutterstock.com%2Fimage-vector%2Fempty-placeholder-image-icon-design-260nw-1366372628.jpg&imgrefurl=https%3A%2F%2Fwww.shutterstock.com%2Fsearch%2Fplaceholder%2Bimage&tbnid=S28DYxXD39mDFM&vet=12ahUKEwisjfyBifTyAhXXe30KHWYkCGIQMygPegUIARDwAQ..i&docid=_eukPVibkcyRgM&w=260&h=280&q=image%20place%20holder%20image&ved=2ahUKEwisjfyBifTyAhXXe30KHWYkCGIQMygPegUIARDwAQ")
                                            : NetworkImage("${searchList[index].productImages[0]}"),
                                        fit: BoxFit.contain,
                                      )),
                                  // child: Image.asset(
                                  //   "assets/images/wallpaperflare.com_wallpaper.jpg",
                                  //   fit: BoxFit.fill,
                                  //   height: 80,
                                  //   width: 80,
                                  // ),
                                ),
                              ),
                              Positioned(
                                top: -10,
                                right: 10,
                                child: BlocBuilder<SearchAllBloc, SearchAllState>(
                                  builder: (context, state) {
                                    if (state is GetCheckBoxState) {
                                      searchList[state.index].check = state.check;
                                    }
                                    return Checkbox(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      // checkColor: Colors.indigo,
                                      value: searchList[index].check,
                                      activeColor: ColorPrimary,
                                      onChanged: (newvalue) {
                                        log("true===>");
                                        searchAllBloc.add(GetCheckBoxEvent(check: newvalue!, index: index));
                                      },
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
                  }),
                  searchList.isEmpty
                      ? Container()
                      : Positioned(
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              List<ProductModel> product = searchList.where((element) => element.check).toList();
                              log("$product");
                            },
                            child: Container(
                              width: width,
                              color: ColorPrimary,
                              child: Center(
                                child: Text(
                                  "DONE",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              height: height * 0.07,
                            ),
                          ))
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
              "Size",
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
                      child: Center(child: Text("M")),
                    ),
                  ]);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              "Color",
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
                    "Cancel",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Done",
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

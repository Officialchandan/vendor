import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/billingflow/search_all/search_all_bloc.dart';
import 'package:vendor/billingflow/search_all/search_all_event.dart';
import 'package:vendor/billingflow/search_all/search_all_state.dart';
import 'package:vendor/model/product_by_category_response.dart';
import 'package:vendor/provider/api_provider.dart';
import 'package:vendor/utility/color.dart';

class SearchAllProduct extends StatefulWidget {
  SearchAllProduct({Key? key}) : super(key: key);

  @override
  _SearchAllProductState createState() => _SearchAllProductState();
}

class _SearchAllProductState extends State<SearchAllProduct> {
  var count;
  SearchAllBloc searchAllBloc = SearchAllBloc();
  List<ProductModel> products = [];
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
                      Fluttertoast.showToast(
                          msg: state.message, backgroundColor: ColorPrimary);
                    }
                  }, builder: (context, state) {
                    if (state is GetSearchState) {
                      products = state.data!;
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
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
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
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${products[index].productName}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
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
                                                " ${products[index].earningCoins}",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorPrimary),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new RichText(
                                            text: new TextSpan(
                                              text:
                                                  '\u20B9 ${products[index].sellingPrice}  ',
                                              style: TextStyle(
                                                  color: ColorPrimary),
                                              children: <TextSpan>[
                                                new TextSpan(
                                                  text:
                                                      '\u20B9${products[index].mrp}',
                                                  style: new TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Size : ${products[index].size}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: ColorTextPrimary),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ]),
                                        ],
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  // color: Colors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              height: 20,
                                              // width: 90,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  BlocBuilder<SearchAllBloc,
                                                      SearchAllState>(
                                                    builder: (context, state) {
                                                      if (state
                                                          is GetDecrementState) {
                                                        products[index].count =
                                                            state.count;
                                                      }
                                                      return Container(
                                                        height: 20,
                                                        width: 30,
                                                        child: IconButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed: () {
                                                              log("true===>$count");

                                                              searchAllBloc.add(
                                                                  GetIncrementEvent(
                                                                      count:
                                                                          count++));
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
                                                        "${products[index].count}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    width: 30,
                                                    child: IconButton(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        onPressed: () {
                                                          log("true===>");
                                                        },
                                                        iconSize: 20,
                                                        splashRadius: 10,
                                                        icon: Icon(
                                                          Icons.add,
                                                        )),
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
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  RichText(
                                                    text: new TextSpan(
                                                      text: ' Color : ',
                                                      style: TextStyle(
                                                          color:
                                                              ColorTextPrimary),
                                                      children: <TextSpan>[
                                                        new TextSpan(
                                                          text:
                                                              '${products[index].colorName}',
                                                          style: new TextStyle(
                                                              color: Color(
                                                            int.parse(products[
                                                                    index]
                                                                .colorCode
                                                                .replaceAll("#",
                                                                    "0xff")),
                                                          )),
                                                        ),
                                                      ],
                                                    ),
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
                                margin: EdgeInsets.only(
                                    left: 10, right: 30, bottom: 10),

                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "${products[index].productImage[0]}"),
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
                                    products[state.index].check = state.check;
                                  }
                                  return Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    // checkColor: Colors.indigo,
                                    value: products[index].check,
                                    activeColor: ColorPrimary,
                                    onChanged: (newvalue) {
                                      log("true===>");
                                      searchAllBloc.add(GetCheckBoxEvent(
                                          check: newvalue!, index: index));
                                    },
                                  );
                                },
                              ),
                            )
                          ],

                          //   ),
                        );
                      },
                    );
                  }),
                  Positioned(
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          List<ProductModel> product = products
                              .where((element) => element.check)
                              .toList();
                          log("$product");
                        },
                        child: Container(
                          width: width,
                          color: ColorPrimary,
                          child: Center(
                            child: Text(
                              "DONE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(50)),
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
                      decoration: BoxDecoration(
                          color: ColorPrimary,
                          borderRadius: BorderRadius.circular(50)),
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
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ColorPrimary),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

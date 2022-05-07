import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/ui/billingflow/billing/billing_bloc.dart';
import 'package:vendor/ui/billingflow/billing/billing_event.dart';
import 'package:vendor/ui/billingflow/billing/billing_state.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_billing.dart';
import 'package:vendor/ui/billingflow/search_all/search_all_product.dart';
import 'package:vendor/ui/billingflow/search_by_categories/search_by_categories.dart';
import 'package:vendor/ui/home/home.dart';
import 'package:vendor/ui/inventory/add_product/add_product_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/utility/validator.dart';

class BillingScreen extends StatefulWidget {
  BillingScreen({Key? key}) : super(key: key);

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  CustomerNumberResponseBloc customerNumberResponseBloc = CustomerNumberResponseBloc();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<CategoryModel> category = [];

  var check;
  var coins;
  String customerCoins = "0.0";
  String firstName = "You";
  String lastName = "";
  var message;
  var userStatus;
  var status;
  var status1;
  int navig = 1;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  refresh() {
    customerNumberResponseBloc.add(GetVendorCategoryEvent());
    _refreshController.refreshCompleted();

    //setState(() {});
  }

  Widget show() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            child: Image.asset(
          "assets/images/point.png",
          scale: 2,
        )),
        Text(
          "  0.0",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ColorPrimary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
        return true;
      },
      child: BlocProvider<CustomerNumberResponseBloc>(
        create: (context) => customerNumberResponseBloc,
        child: BlocConsumer<CustomerNumberResponseBloc, CustomerNumberResponseState>(
          listener: (context, state) async {
            userStatus = await SharedPref.getIntegerPreference(SharedPref.USERSTATUS);
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("billing_key".tr(), style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(width: 5),
                  Image.asset(
                    "assets/images/point.png",
                    width: 25,
                  ),
                  SizedBox(
                    width: 35,
                  ),
                ]),
                leadingWidth: 100,
                leading: userStatus == 1
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context, PageTransition(child: DirectBilling(), type: PageTransitionType.fade));
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                Text(
                                  "direct_billing_key".tr(),
                                  style: TextStyle(color: ColorPrimary, fontWeight: FontWeight.bold),
                                ),
                                Image.asset(
                                  "assets/images/point.png",
                                  scale: 3,
                                ),
                              ]),
                            ),
                          ),
                        ),
                      )
                    : Text(""),
                centerTitle: true,
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context,
                          PageTransition(child: HomeScreen(), type: PageTransitionType.fade), ModalRoute.withName("/"));
                      // Navigator.pop(context);
                      log("$userStatus");
                      log("${SharedPref.getIntegerPreference(SharedPref.VENDORID)}");
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/home.png"),
                    ),
                  )
                ],
              ),
              body: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: () {
                  refresh();
                },
                child: SingleChildScrollView(
                  child: Stack(children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 14,
                        right: 14,
                        top: 10,
                      ),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  child: Image.asset(
                                "assets/images/point.png",
                                width: 24,
                              )),
                              mobileController.text.length == 10
                                  ? Text(
                                      " $customerCoins",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ColorPrimary),
                                    )
                                  : Text(
                                      " 0.0",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ColorPrimary),
                                    ),
                            ],
                          ),
                          BlocConsumer<CustomerNumberResponseBloc, CustomerNumberResponseState>(
                            listener: (context, state) {
                              if (state is GetCustomerNumberResponseState) {
                                check = state.succes;
                                coins = state.data;
                                customerCoins = state.data;
                              }
                              if (state is GetCustomerNumberResponseFailureState) {
                                check = state.succes;
                                log("======>$check");
                                message = state.message;
                                status = state.status;
                                log("status ===>$status");
                              }

                              if (state is GetBillingPartialUserState) {}

                              if (state is GetBillingPartialUserFailureState) {}
                            },
                            builder: (context, state) {
                              // if (state is GetCustomerNumberResponseState) {
                              //   status = state.status;
                              //   log("status ===>$status");
                              //   return Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       Container(
                              //           child: Image.asset(
                              //         "assets/images/point.png",
                              //         scale: 2,
                              //       )),
                              //       mobileController.text.length == 10
                              //           ? Text(
                              //               "  ${state.data}",
                              //               style: TextStyle(
                              //                   fontSize: 20,
                              //                   fontWeight: FontWeight.w700,
                              //                   color: ColorPrimary),
                              //             )
                              //           : Text(
                              //               "  0.0",
                              //               style: TextStyle(
                              //                   fontSize: 20,
                              //                   fontWeight: FontWeight.w700,
                              //                   color: ColorPrimary),
                              //             ),
                              //     ],
                              //   );
                              // }

                              // if (state
                              //     is GetCustomerNumberResponseLoadingstate) {
                              //   log("hello1");
                              //   return Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       Container(
                              //           child: Image.asset(
                              //         "assets/images/point.png",
                              //         scale: 2,
                              //       )),
                              //       Text(
                              //         "  0.0",
                              //         style: TextStyle(
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.w700,
                              //             color: ColorPrimary),
                              //       ),
                              //     ],
                              //   );
                              // }
                              // return show();
                              return Container();
                            },
                          ),
                          BlocConsumer<CustomerNumberResponseBloc, CustomerNumberResponseState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return Container(
                                child: Column(children: [
                                  TextFormField(
                                      controller: mobileController,
                                      keyboardType: TextInputType.number,
                                      validator: (numb) => Validator.validateMobile(numb!, context),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(fontSize: 12),
                                        labelStyle: TextStyle(fontSize: 16, color: TextBlackLight),
                                        hintStyle: TextStyle(fontSize: 16, color: TextBlackLight),
                                        hintText: 'enter_customer_phone_number_key'.tr(),
                                        labelText: 'mobile_number_key'.tr(),
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(0),
                                        fillColor: Colors.transparent,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: textFieldBorderColor, width: 1.5)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                      ),
                                      onChanged: (length) {
                                        if (mobileController.text.length == 10) {
                                          customerNumberResponseBloc
                                              .add(GetCustomerNumberResponseEvent(mobile: mobileController.text));
                                        }
                                        if (mobileController.text.length == 9) {
                                          customerCoins = "0.0";
                                          customerNumberResponseBloc
                                              .add(GetCustomerNumberResponseEvent(mobile: mobileController.text));
                                        }
                                      }),
                                  status == 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: TextFormField(
                                              controller: nameController,
                                              inputFormatters: [FilteringTextInputFormatter.allow(Validator.name)],
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(fontSize: 12),
                                                hintStyle: TextStyle(fontSize: 16, color: TextBlackLight),
                                                labelStyle: TextStyle(fontSize: 16, color: TextBlackLight),
                                                hintText: 'enter_customer_name_key'.tr(),
                                                labelText: 'full_name_key'.tr(),
                                                counterText: "",
                                                contentPadding: EdgeInsets.all(0),
                                                fillColor: Colors.transparent,
                                                enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: textFieldBorderColor, width: 1.5)),
                                                focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: ColorPrimary, width: 1.5)),
                                              ),
                                              onChanged: (length) {}),
                                        )
                                      : Container(),
                                ]),
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              if (await Network.isConnected()) {
                                if (mobileController.text.length == 10) {
                                  if (check == false) {
                                    if (status == 0) {
                                      if (nameController.text.length > 1) {
                                        //   userRegister(context);
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: SearchAllProduct(
                                                      mobile: mobileController.text,
                                                      coin: coins = 0.toString(),
                                                      lastName: lastName,
                                                      firstName: nameController.text,
                                                    ),
                                                    type: PageTransitionType.fade))
                                            .then((value) {
                                          // nameController.clear();
                                          // mobileController.clear();
                                          FocusScope.of(context).unfocus();
                                        });
                                      } else {
                                        Utility.showToast(msg: "please_enter_name_key".tr());
                                      }
                                    }
                                  } else {
                                    if (check == true) {
                                      FocusScope.of(context).unfocus();
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: SearchAllProduct(
                                                lastName: lastName,
                                                firstName: nameController.text,
                                                mobile: mobileController.text,
                                                coin: coins,
                                              ),
                                              type: PageTransitionType.fade));
                                    } else {
                                      Utility.showToast(msg: "$message");
                                    }
                                  }
                                } else {
                                  Utility.showToast(msg: "please_enter_vailid_number_first_key".tr());
                                }
                              } else {
                                Utility.showToast(
                                  msg: "please_check_your_internet_connection_key".tr(),
                                );
                              }
                            },
                            child: TextFormField(
                              cursorColor: ColorPrimary,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                filled: true,
                                enabled: false,
                                // fillColor: Colors.black,
                                hintText: "search_all_products_key".tr(),
                                hintStyle: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.black),
                                contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onChanged: (text) {},
                            ),
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: MediaQuery.of(context).size.height * 0.065,
                            //   padding: EdgeInsets.only(left: 10),
                            //   color: Colors.grey[300],
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.search, color: TextBlackLight),
                            //       Text(
                            //         "search_all_products_key".tr(),
                            //         style: TextStyle(fontSize: 16, color: TextBlackLight, fontWeight: FontWeight.bold),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "search_by_category_key".tr(),
                            style: TextStyle(fontSize: 16, color: TextBlackLight, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BlocConsumer<CustomerNumberResponseBloc, CustomerNumberResponseState>(
                            listener: (context, state) {
                              if (state is GetCategoryByVendorIdState) {
                                // Utility.showToast(
                                //     backgroundColor: ColorPrimary,
                                //     textColor: Colors.white,
                                //     msg: state.message);
                              }
                              if (state is GetCategoryByVendorIdFailureState) {
                                Utility.showToast(
                                  msg: state.message,
                                );
                              }
                              if (state is GetCategoryByVendorIdLoadingstate) {
                                CircularProgressIndicator(
                                  backgroundColor: ColorPrimary,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is CustomerNumberResponseIntialState) {
                                customerNumberResponseBloc.add(GetVendorCategoryEvent());
                              }
                              if (state is GetCategoryByVendorIdState) {
                                category = state.data!;
                              }
                              if (state is GetCategoryByVendorIdLoadingstate) {
                                return Container(
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    backgroundColor: ColorPrimary,
                                  ),
                                );
                              }
                              // return Stack(children: [
                              return Container(
                                  color: Colors.transparent,
                                  //   padding: EdgeInsets.only(bottom: 80),
                                  height: MediaQuery.of(context).size.height * 0.42,
                                  child: categoryListWidget(category));
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(left: 17, right: 17),
                child: InkWell(
                  onTap: () async {
                    if (await Network.isConnected()) {
                      FocusScope.of(context).unfocus();
                      Navigator.push(context,
                              PageTransition(child: AddProductScreen(status: 0), type: PageTransitionType.fade))
                          .then((value) => FocusScope.of(context).unfocus());
                    } else {
                      Utility.showToast(
                        msg: "please_check_your_internet_connection_key".tr(),
                      );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: ColorPrimary),
                        color: Colors.white),
                    child: Center(
                        child: Text(
                      "add_new_product_key".tr(),
                      style: TextStyle(color: ColorPrimary, fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget categoryListWidget(List<CategoryModel> category) {
    return ListView.builder(
        // padding: EdgeInsets.only(bottom: 80),
        itemCount: category.length,
        itemBuilder: (context, index) {
          return InkWell(
            //focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            //  overlayColor: Colors.transparent,
            onTap: () async {
              if (await Network.isConnected()) {
                if (mobileController.text.length == 10) {
                  if (check == false) {
                    if (status == 0) {
                      if (nameController.text.length > 1) {
                        //  userRegister(context);
                        FocusScope.of(context).unfocus();
                        Navigator.push(
                                context,
                                PageTransition(
                                    child: SearchByCategory(
                                      firstName: nameController.text,
                                      lastName: lastName,
                                      catid: category[index].id.toString(),
                                      mobile: mobileController.text,
                                      coin: coins,
                                    ),
                                    type: PageTransitionType.fade))
                            .then((value) {
                          // nameController.clear();
                          // mobileController.clear();
                        });
                      } else {
                        Utility.showToast(
                          msg: "please_enter_name_key".tr(),
                        );
                      }
                    }
                  } else {
                    if (check == true) {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                          context,
                          PageTransition(
                              child: SearchByCategory(
                                lastName: lastName,
                                firstName: nameController.text,
                                catid: category[index].id.toString(),
                                mobile: mobileController.text,
                                coin: coins,
                              ),
                              type: PageTransitionType.fade));
                    } else {
                      Utility.showToast(
                        msg: "$message",
                      );
                    }
                  }
                } else {
                  Utility.showToast(msg: "please_enter_vailid_number_first_key".tr());
                }
              } else {
                Utility.showToast(
                  msg: "please_check_your_internet_connection_key".tr(),
                );
              }
            },
            child: Container(
              // padding: EdgeInsets.all(10),
              //height: MediaQuery.of(context).size.height * 0.07,

              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: .5),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 7.0,
                  ),
                ],
              ),
              child: ListTile(
                minLeadingWidth: 20,
                leading: CachedNetworkImage(
                  imageUrl: "${category[index].image}",
                  imageBuilder: (context, imageProvider) {
                    return Image(
                        image: imageProvider,
                        color: ColorPrimary,
                        height: 25,
                        width: 25,
                        //colorBlendMode: BlendMode.clear,
                        fit: BoxFit.contain);
                  },
                  progressIndicatorBuilder: (context, url, downloadProgress) => Icon(
                    Icons.image,
                    color: ColorPrimary,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                // Image.network('${result!.data![index].image}', width: 20),
                title: Container(
                  transform: Matrix4.translationValues(0, -2, 0),
                  child: Text(
                    "${category[index].categoryName}",
                    style: TextStyle(fontSize: 16, color: TextBlackLight, fontWeight: FontWeight.bold),
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
          );
        });
  }

  // Future<void> userRegister(BuildContext context) async {
  //   Map<String, dynamic> input = HashMap<String, dynamic>();
  //   input["mobile"] = mobileController.text;
  //   input["first_name"] = nameController.text;
  //
  //   log("=====? $input");
  //   customerNumberResponseBloc.add(GetBillingPartialUserRegisterEvent(input: input));
  // }
}

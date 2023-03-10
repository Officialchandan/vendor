import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vendor/api/Endpoint.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/model/log_out.dart';
import 'package:vendor/model/vendor_profile_response.dart';
import 'package:vendor/ui/account_management/account_management_screen/privacy_policy_screen.dart';
import 'package:vendor/ui/login/login_screen.dart';
import 'package:vendor/ui/web_view_screen/webview_screen.dart';
import 'package:vendor/ui_without_inventory/home/home.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

import '../../main.dart';
import '../../widget/language_bottom_sheet.dart';

// ignore: camel_case_types
class AccountManagementWithoutInventoryScreen extends StatefulWidget {
  const AccountManagementWithoutInventoryScreen({Key? key}) : super(key: key);

  @override
  _AccountManagementWithoutInventoryScreenState createState() =>
      _AccountManagementWithoutInventoryScreenState();
}

class _AccountManagementWithoutInventoryScreenState
    extends State<AccountManagementWithoutInventoryScreen> {
  List<String> textList = [
    "change_language_key".tr(),
    "about_us_key".tr(),
    "contact_us_key".tr(),
    "terms_conditions_key".tr(),
    "logout_key".tr(),
  ];

  List<String> imageList = [
    "assets/images/account-ic14.png",
    "assets/images/account-ic15.png",
    "assets/images/account-ic13.png",
    "assets/images/account-ic10.png",
    "assets/images/account-ic8.png",
  ];
  var message;
  bool? status;
  VendorDetailData? vendorDetailData;
  StreamController<VendorDetailData> controller = StreamController();
  List<VendorDetailData>? data;
  // AccountManagementWithoutInventoryBloc accountManagementBloc =
  //     AccountManagementWithoutInventoryBloc(
  //         AccountManagementWithoutInventoryIntialState());
  @override
  void initState() {
    super.initState();
    getVendorProfileDetail();
    // accountManagementBloc.add(GetAccountManagementWithoutInventoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPrimary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorPrimary,
          ),
          // toolbarHeight: 120,
          title: Text(
            'account_key'.tr(),
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
              color: ColorPrimary,
              child: StreamBuilder<VendorDetailData>(
                stream: controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.vendorImage!.isNotEmpty
                              ? snapshot.data!.vendorImage!.first.image
                                  .toString()
                              : "https://blog.yorksj.ac.uk/amelia-lambert/wp-content/themes/oria/images/placeholder.png",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.ownerName.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 3),
                          Text(snapshot.data!.shopName.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: Text(
                            snapshot.data!.ownerMobile.toString(),
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreenWithoutInventory()),
                    ModalRoute.withName(""));
              },
              child: Container(
                padding: EdgeInsets.only(right: 10),
                height: 30,
                width: 30,
                child: Image.asset("assets/images/home.png"),
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ListView(
            primary: false,
            children: List.generate(textList.length, (index) {
              print("assets/images/account-ic1.png");
              return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xffbdbdbd))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("${imageList[index]}", width: 25),
                        SizedBox(width: 17),
                        Expanded(
                          child: Text(textList[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.black, size: 15),
                      ],
                    ),
                  ),
                  onTap: () {
                    onClick(context, index, vendorDetailData);
                  });
            }),
          ),
        ),
        /*   bottomNavigationBar: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: ColorPrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "Powered By ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Text(
                " Tech Points Concepts Pvt Ltd",
                style: TextStyle(
                    fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),*/
      ),
    );
  }

  Future<void> onClick(BuildContext context, int currentIndex, var data) async {
    switch (currentIndex) {
      case 0:
        languageUpdateSheet(context);
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                    title: "about_us_key".tr(),
                    url: "http://vendor.myprofitinc.com/aboutus",
                  )),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                    title: tr("contact_us_key"),
                    url: "http://vendor.myprofitinc.com/contact",
                  )),
        );
        break;
      case 3:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => WebViewScreen(
        //             title: tr("privacy_policy_key"),
        //             url: "http://vendor.myprofitinc.com/privacypolicy",
        //           )),
        // );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
        break;
      // case 2:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => WebViewScreen(
      //               title: tr("terms_conditions_key"),
      //               url: "http://vendor.myprofitinc.com/terms",
      //             )),
      //   );
      //   break;
      // case 3:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => WebViewScreen(
      //               title: tr("cancellation_refund_policy_key"),
      //               url: "http://vendor.myprofitinc.com/refundpolicy",
      //             )),
      //   );
      //   break;
      case 4:
        logoutDialog(context);
        break;
    }
  }

  logoutDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(25, 10, 0, 0),
            title: Text("logout_key".tr(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            content: Text("are_you_sure_you_want_to_logout_key".tr(),
                style: TextStyle(
                    color: Color.fromRGBO(85, 85, 85, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            actions: [
              MaterialButton(
                child: Text("cancel_key".tr(),
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child: Text("logout_key".tr(),
                    style: TextStyle(
                        color: Color(0xfff4511e), fontWeight: FontWeight.w600)),
                onPressed: () async {
                  log("ndndnd");
                  LogOutResponse logoutData = await ApiProvider().getLogOut();
                  print("kai kroge +${logoutData.success}");
                  await SharedPref.setBooleanPreference(
                      SharedPref.LOGIN, false);
                  print("kai kroge +${logoutData.success}");
                  if (await Network.isConnected()) {
                    SharedPref.clearSharedPreference(context);
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    print("kai kroge +");
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        ModalRoute.withName("/"));

                    Utility.showToast(msg: "logout_successfully_key".tr()
                        // timeInSecForIos: 3
                        );
                  } else {
                    Utility.showToast(
                        msg: "please_check_your_internet_connection_key".tr());
                  }
                },
              ),
            ],
          );
        });
  }

  Future<VendorDetailResponse> getVendorProfileDetail() async {
    try {
      Map input = HashMap<String, dynamic>();

      input["vendor_id"] =
          await SharedPref.getIntegerPreference(SharedPref.VENDORID);

      Response res = await dio.post(
        Endpoint.GET_VENDOR_PROFILE,
        data: input,
      );

      VendorDetailResponse response =
          VendorDetailResponse.fromJson(res.toString());
      vendorDetailData = response.data;
      controller.add(response.data!);
      return response;
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return VendorDetailResponse(success: false, message: message);
    }
  }

  void languageUpdateSheet(BuildContext context) {
    showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        )),
        context: context,
        // barrierColor: Colors.transparent,
        builder: (context) {
          return LanguageBottomSheet();
        });
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/validate_app_version.dart';
import 'package:vendor/ui/home/home.dart';
import 'package:vendor/ui/login/login_screen.dart';
import 'package:vendor/ui_without_inventory/home/home.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  refresh() {
    log("refresh hua");
    validApp();
    _refreshController.refreshCompleted();

    //setState(() {});
  }

  Future<void> validApp() async {
    if (await Network.isConnected()) {
      ValidateAppVersionResponse result = await apiProvider.validateAppVersion();
      if (result.success) {
        getLogin();
      } else {
        validateAppAlert(result.data!.isMandatory);
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
      internetDialog();
    }
  }

  void validateAppAlert(int mandotory) async {
    double devicewidth = 300;

    showDialog(
        barrierDismissible: false,
        context: navigationService.navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
              content: Text("You are using older Version of Vendor App, \n Please Update App For Better Performance."),
              contentPadding: EdgeInsets.all(15),
              actions: [
                TextButton(
                    ////
                    onPressed: () async {
                      StoreRedirect.redirect(
                        androidAppId: "com.myprofit.vendor",
                        iOSAppId: "123456",
                      );
                    },
                    child: Text("Update")),
                mandotory == 9
                    ? Container()
                    : TextButton(
                        onPressed: () async {
                          Navigator.of(context);
                          getLogin();
                        },
                        child: Text("Later"))
              ],
            ));

    // EasyLoading.showError("Your session has been expired! Please login again",);
  }

  void internetDialog() async {
    double devicewidth = 300;

    showDialog(
        barrierDismissible: false,
        context: navigationService.navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
              content: Text("Please Turn On Your Internet Connection"),
              contentPadding: EdgeInsets.all(15),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      validApp();
                    },
                    child: Text("Retry")),
              ],
            ));

    // EasyLoading.showError("Your session has been expired! Please login again",);
  }

  void getLogin() async {
    var log = await SharedPref.getBooleanPreference(SharedPref.LOGIN);
    var lang = await SharedPref.getStringPreference(SharedPref.SELECTEDLANG);
    if (lang.isEmpty) {
      Timer(Duration(seconds: 3),
          () => Navigator.pushNamedAndRemoveUntil(context, Routes.SelectLanguage, (route) => false));
    } else if (log) {
      String token = await SharedPref.getStringPreference(SharedPref.TOKEN);
      int vendorId = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
      int statusId = await SharedPref.getIntegerPreference(SharedPref.USERSTATUS);
      baseOptions.headers.addAll({"languagecode": "${await SharedPref.getStringPreference(SharedPref.SELECTEDLANG)}"});
      print("token-->$token");
      print("vendorId-->$vendorId");
      if (token.isEmpty) {
        Timer(Duration(seconds: 3),
            () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())));
      } else {
        baseOptions.headers.addAll({"Authorization": "bearer $token"});
        if (await SharedPref.getIntegerPreference(SharedPref.USERSTATUS) == 0) {
          Timer(
              Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomeScreenWithoutInventory())));
        } else {
          Timer(Duration(seconds: 3),
              () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())));
        }
      }
    } else {
      Timer(Duration(seconds: 3),
          () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }

  @override
  void initState() {
    super.initState();
    validApp();
  }

// var lang = await SharedPref.getStringPreference(SharedPref.SELECTEDLANG);
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: () {
          refresh();
        },
        child: Scaffold(
            //  backgroundColor: ColorBagroundPrimary,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                elevation: 0,
                // systemOverlayStyle: SystemUiOverlayStyle(
                //   statusBarColor: ColorBagroundPrimary,
                // ),
                // backgroundColor: ColorBagroundPrimary,
              ),
            ),
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset('assets/images/splash-top.png'),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset('assets/images/splash-bottom.png',
                              width: MediaQuery.of(context).size.width * 0.7)),
                    ],
                  ),
                  Positioned(
                      child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: deviceHeight * 0.40,
                    ),
                  )),
                ]),
              ),
            )));
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myprofit_vendorapp/UI/language/select_language.dart';
import 'package:myprofit_vendorapp/utility/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getLogin() async {
    var log = true;//await SharedPref.getBooleanPreference(SharedPref.LOGIN);
    var lang ; //await SharedPref.getStringPreference(SharedPref.SELECTEDLANG);
    // if (lang.isEmpty) {
        Timer(
            Duration(seconds: 3),
            () =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SelectLanguage())));
      // } else if (log == true) {
      //   Timer(
      //       Duration(seconds: 3),
      //       () => Text("")
      //       // Navigator.pushReplacement(context,
      //       //     MaterialPageRoute(builder: (context) => TabContainer(0)))
      //           );
      // } else {
      //   Timer(
      //       Duration(seconds: 3),
      //       () =>  Text("")
      //       // Navigator.pushReplacement(
      //       //     context, MaterialPageRoute(builder: (context) => LoginScreen()))
      //           );
      // }
  }
   
  

  @override
  void initState() {
    super.initState();
    getLogin();
  }

// var lang = await SharedPref.getStringPreference(SharedPref.SELECTEDLANG);
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset('assets/images/splash-top.png',
                  width: deviceWidth * 0.35),
            ),
            Image.asset(
              'assets/images/logo.png',
              height: deviceHeight * 0.35,
            ),
            Image.asset('assets/images/splash-bottom.png',
                width: double.infinity),
          ],
        ),
      ),
    );
  }
}

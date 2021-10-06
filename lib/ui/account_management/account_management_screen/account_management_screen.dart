import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/model/log_out.dart';
import 'package:vendor/provider/api_provider.dart';
import 'package:vendor/ui/account_management/delivery_setting/delivery_setting.dart';
import 'package:vendor/ui/account_management/discount_codes/discounts_codes.dart';
import 'package:vendor/ui/account_management/settings/settings.dart';
import 'package:vendor/ui/account_management/store_qr_code/store_qr_code.dart';
import 'package:vendor/ui/home/home.dart';
import 'package:vendor/ui/inventory/add_product/add_product_screen.dart';
import 'package:vendor/ui/login/login_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';

// ignore: camel_case_types
class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({Key? key}) : super(key: key);

  @override
  _AccountManagementScreenState createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  List<String> TextList = [
    "Discount codes",
    "Settings",
    "Delivery Settings",
    "Video tutorials",
    "Share store link",
    "Get store QR code",
    "Add business hours",
    "Logout"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPrimary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          // toolbarHeight: 120,
          title: Text('Account'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
              color: ColorPrimary,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset(
                        "assets/images/wallpaperflare.com_wallpaper.jpg",
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alexa Parker",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 3),
                      Text("myprofitstore.com/alexa",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
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
            children: List.generate(TextList.length, (index) {
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
                        Image.asset("assets/images/account-ic${index + 1}.png",
                            width: 24),
                        SizedBox(width: 17),
                        Expanded(
                          child: Text(TextList[index],
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
                    onClick(context, index);
                  });
            }),
          ),
        ),
      ),
    );
  }
}

//ontap-function
Future<void> onClick(BuildContext context, int currentIndex) async {
  switch (currentIndex) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DiscountCodes()),
      );
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Settings()),
      );
      break;
    case 2:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DeliverySetting()),
      );
      break;
    case 3:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      break;
    case 4:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      break;
    case 5:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoreQRCode()),
      );
      break;
    case 6:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      break;
    case 7:
      logoutDialog(context);
      break;
  }
}
//ontap-function

//logout-dialog
logoutDialog(context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(25, 10, 0, 0),
          title: Text("Logout",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          content: Text("Are you sure you want to logout?",
              style: TextStyle(
                  color: Color.fromRGBO(85, 85, 85, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          actions: [
            MaterialButton(
              child: Text("Cancel",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text("Logout",
                  style: TextStyle(
                      color: Color(0xfff4511e), fontWeight: FontWeight.w600)),
              onPressed: () async {
                log("ndndnd");
                LogOutResponse logoutData = await ApiProvider().getLogOut();
                print("kai kroge +${logoutData.success}");
                await SharedPref.setBooleanPreference(SharedPref.LOGIN, false);
                print("kai kroge +${logoutData.success}");
                if (await Network.isConnected()) {
                  SystemChannels.textInput.invokeMethod("TextInput.hide");
                  print("kai kroge +");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      ModalRoute.withName("/"));

                  Fluttertoast.showToast(
                      backgroundColor: ColorPrimary,
                      textColor: Colors.white,
                      msg: "Logout Successfully"
                      // timeInSecForIos: 3
                      );
                } else {
                  Fluttertoast.showToast(
                      backgroundColor: ColorPrimary,
                      textColor: Colors.white,
                      msg: "Please turn on  internet");
                }
              },
            ),
          ],
        );
      });
}
//logout-dialog


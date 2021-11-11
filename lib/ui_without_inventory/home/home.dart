import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:vendor/ui/home/bottom_navigation_home.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/due_amount_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/routs.dart';

class HomeScreenWithoutInventory extends StatefulWidget {
  HomeScreenWithoutInventory({Key? key}) : super(key: key);

  @override
  _HomeScreenWithoutInventoryState createState() =>
      _HomeScreenWithoutInventoryState();
}

class _HomeScreenWithoutInventoryState
    extends State<HomeScreenWithoutInventory> {
  List<String> name = [
    "Billing",
    "Performance Tracker + Reports",
    "Money Due - UPI",
    "Account Management"
  ];
  List<String> description = [
    "Billing description",
    "Performance Tracker description",
    "Money Due - UPI description",
    "Account Management description"
  ];

  List<String> images = [
    "assets/images/home1.png",
    "assets/images/home5.png",
    "assets/images/tr-ic3.png",
    "assets/images/home6.png"
  ];

  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share(
        "https://play.google.com/store/apps/details?id=com.tencent.ig");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: Text(""),
        centerTitle: true,
        // backgroundColor: Colors.indigoAccent,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 15,
              right: 15,
            ),
            child: InkWell(
              onTap: () {
                _onShareWithEmptyOrigin(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: ColorPrimary,
                      size: 12,
                    ),
                    Text(
                      " Share Store  ",
                      style: TextStyle(
                          color: ColorPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
          child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    routeManager(index);
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: index == 0
                            ? ColorPrimary
                            : index == 1
                                ? Color(0xff3ebc91)
                                : index == 2
                                    ? Color(0xffee776d)
                                    : index == 3
                                        ? Color(0xffc59280)
                                        : Color(0xffee776d),
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                child: Image.asset(
                              images[index],
                              //height: 70,
                              width: MediaQuery.of(context).size.height * 0.070,
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              name[index],
                              style: TextStyle(
                                color: Colors.white,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                              maxFontSize: 20,
                              minFontSize: 18,
                            ),
                            AutoSizeText(
                              description[index],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              maxFontSize: 13,
                              minFontSize: 11,
                            ),
                          ]),
                    ),
                  ),
                );
              })),
    );
  }

  routeManager(index) {
    log("$index");
    index == 0
        ? Navigator.pushNamed(
            context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY,
            arguments: index)
        : index == 1
            ? Navigator.pushNamed(
                context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY,
                arguments: index)
            : index != 2
                ? Navigator.pushNamed(
                    context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY,
                    arguments: 2)
                : Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DueAmountScreen()));
  }
}

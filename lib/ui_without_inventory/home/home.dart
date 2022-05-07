import 'dart:collection';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share/share.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/notification_screen/model/notification_response.dart';
import 'package:vendor/ui_without_inventory/notification/notification_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class HomeScreenWithoutInventory extends StatefulWidget {
  HomeScreenWithoutInventory({Key? key}) : super(key: key);

  @override
  _HomeScreenWithoutInventoryState createState() => _HomeScreenWithoutInventoryState();
}

class _HomeScreenWithoutInventoryState extends State<HomeScreenWithoutInventory> {
  List<String> name = [
    "coins_key".tr(),
    "performance_tracker_key".tr(),
    "account_management_key".tr(),
    "money_due_upi_title_key".tr(),
    "video_tutorials_key".tr()
  ];
  List<String> description = [
    "generate_redeem_key".tr(),
    // "performance_tracker_description_key".tr(),
    "",
    // "account_management_description_key".tr(),
    "",
    // "money_due_upi_description_key".tr(),
    "",
    "video_tutorials_description_key".tr()
  ];

  List<String> images = [
    "assets/images/point.png",
    "assets/images/home5.png",
    "assets/images/home6.png",
    "assets/images/tr-ic3.png",
    "assets/images/home3.png"
  ];
  List<NotificationData>? notificationData;
  int count = 0;
  int isReadCount = 0;
  int totalNotification = 0;
  String message = "";
  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share("https://play.google.com/store/apps/details?id=com.tencent.ig");
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "home_key".tr(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: Text(""),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                ),
                onPressed: () {
                  message == ""
                      ? Utility.showToast(msg: "no_notification_key".tr())
                      : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WithoutInventoryNotificationScreen(
                            notificationData: notificationData!,
                          ))).then((value) {
                    setState(() {
                      count -= value as int;
                    });
                  });
                },
              ),
              notificationData != null
                  ? Positioned(
                right: 10,
                top: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: new Container(
                    padding: EdgeInsets.all(1.5),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: ColorPrimary,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color: ColorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  : Container()
            ],
          ),
        ],
        // backgroundColor: Colors.indigoAccent,
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(
        //       top: 15,
        //       bottom: 15,
        //       right: 15,
        //     ),
        //     child: InkWell(
        //       onTap: () {
        //         _onShareWithEmptyOrigin(context);
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
        //         child: Row(
        //           children: [
        //             SizedBox(
        //               width: 2,
        //             ),
        //             Icon(
        //               Icons.share,
        //               color: ColorPrimary,
        //               size: 12,
        //             ),
        //             SizedBox(
        //               width: 5,
        //             ),
        //             Text(
        //               "${"share_store_key".tr()} ",
        //               style: TextStyle(color: ColorPrimary, fontWeight: FontWeight.w600, fontSize: 12),
        //             ),
        //             SizedBox(
        //               width: 5,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: Container(
          child: StaggeredGridView.countBuilder(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
        crossAxisCount: 2,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) => new Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: index == 0
                ? Color(0xff6657f4)
                : index == 1
                    ? Color(0xffee776d)
                    : index == 2
                        ? Color(0xfff6ac56)
                        : index == 3
                            ? Color(0xff5086ed)
                            : index == 4
                                ? Color(0xff3ebc91)
                                : Colors.brown,
            //index.isEven ? Colors.indigoAccent : Colors.indigoAccent[100],
          ),
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {
              if (await Network.isConnected()) {
                routeManager(index);
              } else {
                Utility.showToast(
                  msg: "please_check_your_internet_connection_key".tr(),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            name[index],
                            style: TextStyle(
                              color: Colors.white,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                            maxFontSize: 18,
                            minFontSize: 16,
                          ),
                          AutoSizeText(
                            description[index],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            maxFontSize: 13,
                            minFontSize: 11,
                          ),
                        ],
                      )),
                  Container(
                      child: Image.asset(
                    images[index],
                    //height: 70,
                    width: MediaQuery.of(context).size.height * 0.070,
                  ))
                ],
              ),
            ),
          ),
        ),
        staggeredTileBuilder: (int index) => StaggeredTile.count(
          index == 4 ? 2 : 1 // it specifies the number of columns,
          ,
          index == 0
              ? size / 540
              : index == 1
                  ? size / 640
                  : index == 2
                      ? size / 540
                      : index == 3
                          ? size / 640
                          : index == 4
                              ? size / 780
                              : 0.0,
        ),
        mainAxisSpacing: 25.0,
        crossAxisSpacing: 15.0,
      )),
    );
  }

  routeManager(index) {
    log("$index");
    index == 0
        ? Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY, arguments: index)
        : index == 1
            ? Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY, arguments: 1)
            : index == 2
                ? Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY, arguments: 3)
                : index == 3
                    ? Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY, arguments: 2)
                    : index == 4
                        ? Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY, arguments: 3)
                        : Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY, arguments: 3);
  }
  getNotifications() async {
    String userId = (await SharedPref.getIntegerPreference(SharedPref.VENDORID)).toString();
    Map input = HashMap();
    input["vendor_id"] = userId;
    if (await Network.isConnected()) {
      NotificationResponse response = await apiProvider.getNotifications(input);
      message = response.message;
      if (response.success && response.message != "") {
        log("--->${response.data}");
        notificationData = response.data;
        totalNotification = response.data!.length;
        response.data!.forEach((element) {
          if (element.isRead == 1) {
            isReadCount++;
          }
          setState(() {});
          count = totalNotification - isReadCount;
        });
      } else {
        response.message == "" ? Container() : Utility.showToast(msg: response.message);
        message = response.message;
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}

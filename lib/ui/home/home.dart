import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:vendor/api/Endpoint.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/account_management/video_tutorial/video_tutorial.dart';
import 'package:vendor/ui/notification_screen/model/notification_count.dart';
import 'package:vendor/ui/notification_screen/notification_screen.dart';

import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/routs.dart';

import 'bottom_navigation_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CountData> notificationList = [];
  List<String> name = [
    "billing_key".tr(),
    "inventory_key".tr(),
    "money_due_upi_key".tr(),
    "video_tutorials_key".tr(),
    "performance_tracker_key".tr(),
    "account_management_key".tr(),
  ];
  List<String> description = [
    "billing_description_key".tr(),
    "inventory_description_key".tr(),
    "money_due_upi_description_key".tr(),
    "video_tutorials_description_key".tr(),
    "staff_management_description_key".tr(),
    "online_shop_description_key".tr(),
  ];

  List<String> images = [
    "assets/images/home1.png",
    "assets/images/home2.png",
    "assets/images/tr-ic3.png",
    "assets/images/home6.png",
    "assets/images/home4.png",
    "assets/images/home3.png",
  ];
  onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share(
        "https://play.google.com/store/apps/details?id=com.tencent.ig");
  }

  @override
  void initState() {
    super.initState();
    getNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    //print(size);
    //final double itemHeight = size * 0.20;
    // MediaQueryData queryData;
    // queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "home_key".tr(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: Text(""),
        centerTitle: true,
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
        //         decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.all(Radius.circular(5))),
        //         child: Row(
        //           children: [
        //             Icon(
        //               Icons.share,
        //               color: ColorPrimary,
        //               size: 12,
        //             ),
        //             SizedBox(
        //               width: 5,
        //             ),
        //             Text(
        //               "share_store_key".tr(),
        //               style: TextStyle(
        //                   color: ColorPrimary,
        //                   fontWeight: FontWeight.w600,
        //                   fontSize: 12),
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
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
              ),
              notificationList.isNotEmpty
                  ? Positioned(
                      right: 10,
                      top: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: ColorPrimary, width: 1),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                              child: Text(
                                notificationList.length.toString(),
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: ColorPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  : Container()
            ],
          ),
        ],
      ),
      body: StaggeredGridView.countBuilder(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
        crossAxisCount: 2,
        itemCount: 6,
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
                                : index == 5
                                    ? Color(0xffc59280)
                                    : Colors.brown,
            //index.isEven ? Colors.indigoAccent : Colors.indigoAccent[100],
          ),
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {
              log("f");
              if (await Network.isConnected()) {
                routeManager(index);
              } else {
                Fluttertoast.showToast(
                    msg: "please_check_your_internet_connection_key".tr(),
                    backgroundColor: ColorPrimary);
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
                            maxFontSize: 15,
                            minFontSize: 12,
                          ),
                          AutoSizeText(
                            description[index],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            maxFontSize: 12,
                            minFontSize: 10,
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
          1 // it specifies the number of columns,
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
                              ? size / 580
                              : index == 5
                                  ? size / 580
                                  : 0.0,
        ),
        mainAxisSpacing: 25.0,
        crossAxisSpacing: 15.0,
      ),
    );
  }

  routeManager(index) {
    log("$index");
    index == 0
        ? Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME,
            arguments: index)
        : index == 1
            ? Navigator.push(
                context,
                PageTransition(
                  child: BottomNavigationHome(
                    index: 1,
                  ),
                  type: PageTransitionType.fade,
                ))
            : index == 2
                ? Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME,
                    arguments: index)
                : index == 3
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoTutorial()))
                    : index == 4
                        ? Navigator.pushNamed(
                            context, Routes.BOTTOM_NAVIGATION_HOME,
                            arguments: 3)
                        : index == 5
                            ? Navigator.pushNamed(
                                context, Routes.BOTTOM_NAVIGATION_HOME,
                                arguments: 4)
                            : Navigator.pushNamed(
                                context, Routes.BOTTOM_NAVIGATION_HOME,
                                arguments: 4);
  }

  Future<NotificationCount> getNotificationCount() async {
    try {
      Response res = await dio.get(Endpoint.GET_NOTIFICATION_COUNT);
      NotificationCount count = NotificationCount.fromJson(res.toString());
      notificationList = count.data!;
      setState(() {});
      return count;
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      print("Exception occurred: $message stackTrace: $error");
      return NotificationCount(success: false, message: message);
    }
  }
}

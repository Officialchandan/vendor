import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:vendor/api/Endpoint.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/ui/notification_screen/model/notification_response.dart';
import 'package:vendor/ui/notification_screen/model/notification_status.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../../main.dart';

class NotificationScreen extends StatefulWidget {
  final List<NotificationData> notificationData;
  NotificationScreen({Key? key, required this.notificationData})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int isReadCount = 0;
  DateTime today = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(isReadCount);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back_ios),
            //   onPressed: () {
            //     Navigator.of(context).pop(isReadCount);
            //   },
            // ),
            title: Text("notification_key".tr(),
                style: GoogleFonts.fredoka(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1,
                      color: Colors.black),
                )),
            centerTitle: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(isReadCount);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.blue,
                  ))
            ],
          ),
          body: widget.notificationData.isEmpty
              ? Center(
                  child: Image.asset("assets/images/no_data.gif"),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: showNotifications(widget.notificationData)),
        ),
      ),
    );
  }

  Widget showNotifications(List<NotificationData> data) {
    return GroupedListView<NotificationData, dynamic>(
        sort: false,
        useStickyGroupSeparators: true,
        stickyHeaderBackgroundColor: Colors.white,
        elements: data,
        groupBy: (element) => today
                    .difference(new DateFormat('yyyy-MM-dd HH:mm:ss')
                        .parse(element.createdAt))
                    .inDays ==
                0
            ? "today".tr()
            : today
                            .difference(new DateFormat('yyyy-MM-dd HH:mm:ss')
                                .parse(element.createdAt))
                            .inDays >=
                        1 &&
                    today
                            .difference(new DateFormat('yyyy-MM-dd HH:mm:ss')
                                .parse(element.createdAt))
                            .inDays <
                        8
                ? "this_week".tr()
                : "older".tr(),
        reverse: false,
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: InkWell(
              onTap: () async {
                setState(() {
                  if (index.isRead == 0) {
                    isReadCount++;
                  }
                  index.isRead = 1;
                });
                markAsRead(index.id);
              },
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color:
                                index.isRead == 1 ? Colors.white : Colors.blue,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              index.notiListId == 9
                                  ? "assets/images/logo.png"
                                  : "assets/images/3x/rt2.png",
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: RichText(
                                text: TextSpan(
                              text: index.notificationDataDetails!.title + " ",
                              style: GoogleFonts.abel(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    wordSpacing: 2,
                                    height: 1.6,
                                    // textBaseline: TextBaseline.alphabetic,
                                    color: index.isRead == 1
                                        ? Color.fromARGB(192, 17, 17, 17)
                                        : Colors.blue),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: index.notificationDataDetails!.body,
                                    style: GoogleFonts.baumans(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Colors.black,
                                            wordSpacing: 2,
                                            height: 1))),
                              ],
                            )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          today
                                      .difference(
                                          new DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .parse(index.createdAt))
                                      .inDays ==
                                  0
                              ? Text(
                                  "${today.difference(new DateFormat('yyyy-MM-dd HH:mm:ss').parse(index.createdAt)).inHours} " +
                                      "hour_ago".tr(),
                                  style: GoogleFonts.salsa(
                                      textStyle:
                                          TextStyle(color: Colors.black45)),
                                )
                              : today
                                          .difference(new DateFormat(
                                                  'yyyy-MM-dd HH:mm:ss')
                                              .parse(index.createdAt))
                                          .inMinutes <
                                      60
                                  ? Text(
                                      "${today.difference(new DateFormat('yyyy-MM-dd HH:mm:ss').parse(index.createdAt)).inMinutes} " +
                                          "minute_ago".tr())
                                  : Text(
                                      DateFormat("dd MMM").format(
                                              DateTime.parse(index.createdAt)) +
                                          " " +
                                          DateFormat.jm()
                                              .format(DateTime.parse(
                                                  index.createdAt))
                                              .toLowerCase(),
                                      style: TextStyle(
                                          color: index.isRead == 1
                                              ? Colors.grey
                                              : Colors.black54,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        groupSeparatorBuilder: (element) => Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                  child: Text(element.toString(),
                      style: GoogleFonts.merriweather(
                          textStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            ));
  }

  Future<NotificationStatusResponse> markAsRead(int id) async {
    Map input = HashMap();
    String userId =
        (await SharedPref.getIntegerPreference(SharedPref.VENDORID)).toString();

    input["id"] = id;
    input["vendor_id"] = userId;

    try {
      Response res =
          await dio.post(Endpoint.UPDATE_NOTIFICATION_STATUS, data: input);

      NotificationStatusResponse response =
          NotificationStatusResponse.fromJson(res.toString());
      Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME, arguments: 2);
      if (response.success) {
        return NotificationStatusResponse(
            message: response.message, success: true);
      } else {
        return NotificationStatusResponse(
            message: "Data not found!", success: false);
      }
    } catch (error) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Please try again later!";
      }
      return NotificationStatusResponse(success: false, message: message);
    }
  }
}

import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vendor/api/Endpoint.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/notification_screen/model/notification_response.dart';
import 'package:vendor/ui/notification_screen/model/notification_status.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';

class WithoutInventoryNotificationScreen extends StatefulWidget {
  final List<NotificationData> notificationData;
  const WithoutInventoryNotificationScreen({Key? key, required this.notificationData}) : super(key: key);

  @override
  State<WithoutInventoryNotificationScreen> createState() => _WithoutInventoryNotificationScreenState();
}

class _WithoutInventoryNotificationScreenState extends State<WithoutInventoryNotificationScreen> {
  int isReadCount = 0;
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop(isReadCount);
              },
            ),
            title: Text(
              "notification_key".tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: widget.notificationData.isEmpty
              ? Center(
            child: Image.asset("assets/images/no_data.gif"),
          )
              : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: showNotificationData(widget.notificationData)),
        ),
      ),
    );
  }
  Widget showNotificationData(List<NotificationData> data) {
    return ListView.separated(
      itemCount: data.length,
      reverse: false,
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: InkWell(
            onTap: () async {
              setState(() {
                if (data[index].isRead == 0) {
                  isReadCount++;
                }
                data[index].isRead = 1;
              });
              markRead(data[index].id);
            },
            child: Container(
              height: 65,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          data[index].notificationDataDetails!.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: data[index].isRead == 1 ? Colors.grey : Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          data[index].notificationDataDetails!.body,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: data[index].isRead == 1 ? Colors.grey : Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat("dd MMM").format(DateTime.parse(data[index].createdAt)) +
                            " " +
                            DateFormat.jm().format(DateTime.parse(data[index].createdAt)).toLowerCase(),
                        style: TextStyle(
                            color: data[index].isRead == 1 ? Colors.grey : Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.black54,
      ),
    );
  }
  Future<NotificationStatusResponse> markRead(int id) async {
    Map input = HashMap();
    String userId = (await SharedPref.getIntegerPreference(SharedPref.VENDORID)).toString();
    input["id"] = id;
    input["vendor_id"] = userId;
    try {
      Response res = await dio.post(Endpoint.UPDATE_NOTIFICATION_STATUS, data: input);

      NotificationStatusResponse response = NotificationStatusResponse.fromJson(res.toString());
      Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME_WITHOUTINVENTORY, arguments: 2);
      if (response.success) {
        return NotificationStatusResponse(message: response.message, success: true);
      } else {
        return NotificationStatusResponse(message: "Data not found!", success: false);
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

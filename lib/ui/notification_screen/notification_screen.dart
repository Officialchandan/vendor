import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vendor/api/Endpoint.dart';
import 'package:vendor/api/server_error.dart';
import 'package:vendor/ui/notification_screen/bloc/notification_bloc.dart';
import 'package:vendor/ui/notification_screen/bloc/notification_state.dart';
import 'package:vendor/ui/notification_screen/bloc/notofication_event.dart';
import 'package:vendor/ui/notification_screen/model/notification_response.dart';
import 'package:vendor/ui/notification_screen/model/notification_status.dart';
import 'package:vendor/ui/performance_tracker/money_due_upi/money_due_screen.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../../main.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationBloc notificationBloc = NotificationBloc();
  @override
  void initState() {
    super.initState();

    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => notificationBloc,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "notification_key".tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: BlocBuilder<NotificationBloc, NotificationStates>(
                builder: (context, state) {
                  if (state is GetNotificationLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is GetNotificationSuccessState) {
                    return showNotifications(state.data!);
                  }

                  if (state is GetNotificationFailureState) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showNotifications(List<NotificationData> data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: InkWell(
            onTap: () async {
              setState(() {
                data[index].isRead = 1;
              });
              markAsRead(data[index].id);
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
                            color: data[index].isRead == 1
                                ? Colors.grey
                                : Colors.black87,
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
                            color: data[index].isRead == 1
                                ? Colors.grey
                                : Colors.black87,
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
                        DateFormat.jm()
                            .format(DateTime.parse(data[index].createdAt)),
                        style: TextStyle(
                            color: data[index].isRead == 1
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
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.black54,
      ),
    );
  }

  void getNotifications() async {
    notificationBloc.add(GetNotificationEvent());
  }

  Future<NotificationStatusResponse> markAsRead(int id) async {
    Map input = HashMap();
    String userId =
        (await SharedPref.getIntegerPreference(SharedPref.VENDORID)).toString();

    input["id"] = id;
    input["vendor_id"] = userId;
    notificationBloc.add(MarkAsReadEvent(input: input));

    try {
      Response res =
          await dio.post(Endpoint.UPDATE_NOTIFICATION_STATUS, data: input);

      NotificationStatusResponse response =
          NotificationStatusResponse.fromJson(res.toString());
      Navigator.pushNamed(context, Routes.BOTTOM_NAVIGATION_HOME, arguments: 4);
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

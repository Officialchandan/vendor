import 'dart:collection';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/notification_screen/bloc/notification_state.dart';
import 'package:vendor/ui/notification_screen/bloc/notofication_event.dart';
import 'package:vendor/ui/notification_screen/model/notification_response.dart';
import 'package:vendor/ui/notification_screen/model/notification_status.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationStates> {
  NotificationBloc() : super(GetNotificationInitialState());
  @override
  Stream<NotificationStates> mapEventToState(NotificationEvents event) async* {
    if (event is GetNotificationEvent) {
      yield GetNotificationLoadingState();
      yield* getNotifications(event);
    }
  }

  Stream<NotificationStates> getNotifications(
      GetNotificationEvent event) async* {
    String userId =
        (await SharedPref.getIntegerPreference(SharedPref.VENDORID)).toString();
    Map input = HashMap();
    input["vendor_id"] = userId;
    if (await Network.isConnected()) {
      NotificationResponse response = await apiProvider.getNotifications(input);
      if (response.success) {
        yield GetNotificationSuccessState(data: response.data!);
      } else {
        yield GetNotificationFailureState(message: response.message);
      }
    } else {
      yield GetNotificationFailureState(message: Constant.INTERNET_ALERT_MSG);
    }
  }
}

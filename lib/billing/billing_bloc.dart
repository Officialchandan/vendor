import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/billing/billing_event.dart';
import 'package:vendor/billing/billing_state.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/utility/network.dart';

class CustomerNumberResponseBloc extends Bloc<CustomerNumberResponseEvent, CustomerNumberResponseState> {
  CustomerNumberResponseBloc() : super(CustomerNumberResponseIntialState());

  @override
  Stream<CustomerNumberResponseState> mapEventToState(CustomerNumberResponseEvent event) async* {
    if (event is GetCustomerNumberResponseEvent) {
      yield* getCustomerNumberResponse(
        event.mobile,
      );
    }
  }

  Stream<CustomerNumberResponseState> getCustomerNumberResponse(mobile) async* {
    if (await Network.isConnected()) {
      yield GetCustomerNumberResponseLoadingstate();
      try {
        CustomerNumberResponse result = await apiProvider.getCustomerCoins(mobile);
        log("$result");
        if (result.success) {
          yield GetCustomerNumberResponseState(message: result.message);
        } else {
          yield GetCustomerNumberResponseFailureState(message: result.message);
        }
      } catch (error) {
        yield GetCustomerNumberResponseFailureState(message: "internal Server error");
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
    }
  }
}

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/upi_tansfer_detail_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/upi_transfer/without_inventory_upi_transfer_detail/without_inventory_upi_transfer_detail_bloc/without_inventory_upi_transfer_detail_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/upi_transfer/without_inventory_upi_transfer_detail/without_inventory_upi_transfer_detail_bloc/without_inventory_upi_transfer_detail_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class UpiTansferHistoryDetailBloc extends Bloc<UpiTansferHistoryDetailEvent, UpiTansferHistoryDetailState> {
  UpiTansferHistoryDetailBloc() : super(GetUpiTansferHistoryDetailInitialState());

  @override
  Stream<UpiTansferHistoryDetailState> mapEventToState(UpiTansferHistoryDetailEvent event) async* {
    if (event is GetUpiTansferHistoryDetailEvent) {
      yield GetUpiTansferHistoryDetailLoadingState();
      yield* getUpiTansferHistoryDetailApi(event.input);
    }
  }

  Stream<UpiTansferHistoryDetailState> getUpiTansferHistoryDetailApi(input) async* {
    if (await Network.isConnected()) {
      log("=====>");
      UpiHistroyOrdersResponse response = await apiProvider.upiPaymentHistoryDetail(input);
      if (response.success) {
        List<UpiHistroyOrdersData> orderList = [];
        orderList = response.data!;
        orderList.sort((a, b) => b.date.compareTo(a.date));
        // log(orderList);
        yield GetUpiTansferHistoryDetailState(data: orderList);
      } else {
        yield GetUpiTansferHistoryDetailFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}

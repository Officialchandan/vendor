import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_master_ledger_history.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_event.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_bloc/normal_ledger_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class NormalLedgerHistoryBloc extends Bloc<NormalLedgerHistoryEvent, NormalLedgerHistoryState> {
  NormalLedgerHistoryBloc() : super(GetNormalLedgerHistoryInitialState());

  @override
  Stream<NormalLedgerHistoryState> mapEventToState(NormalLedgerHistoryEvent event) async* {
    if (event is GetNormalLedgerHistoryEvent) {
      yield* getNormalLedgerHistoryApi(event.input);
    }
  }

  Stream<NormalLedgerHistoryState> getNormalLedgerHistoryApi(input) async* {
    if (await Network.isConnected()) {
      GetNormalLedgerHistoryResponse response = await apiProvider.getNormalLedgerHistory(input);
      if (response.success) {
        List<CommonLedgerHistory> products = [];
        for (var data in response.data!) {
          CommonLedgerHistory commonLedgerHistory = CommonLedgerHistory(
            vendorId: data.vendorId,
            mobile: data.mobile,
            orderId: data.orderId,
            billingId: data.billingId,
            orderTotal: data.orderTotal,
            myprofitRevenue: data.myprofitRevenue,
            status: data.status,
            dateTime: data.dateTime,
            isReturn: int.parse(""),
            orderDetails: data.orderDetails,
            billingDetails: [],
          );
          products.add(commonLedgerHistory);
        }
        for (var data in response.directBilling!) {
          CommonLedgerHistory commonLedgerHistory = CommonLedgerHistory(
            vendorId: data.vendorId,
            mobile: data.mobile,
            orderId: data.,
            billingId: data.billingId,
            orderTotal: data.orderTotal,
            myprofitRevenue: data.myprofitRevenue,
            status: data.status,
            dateTime: data.dateTime,
            isReturn: data.isReturn,
            orderDetails: [],
            billingDetails: data.billingDetails,
          );
          products.add(commonLedgerHistory);
        }
        yield GetNormalLedgerHistoryState(data: response.data);
      } else {
        yield GetNormalLedgerHistoryFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}

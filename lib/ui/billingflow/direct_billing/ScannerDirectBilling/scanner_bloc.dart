import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/qr_code.dart';
import 'package:vendor/ui/billingflow/direct_billing/ScannerDirectBilling/scanner_event.dart';
import 'package:vendor/ui/billingflow/direct_billing/ScannerDirectBilling/scanner_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(IntitalScannerstate());
  @override
  Stream<ScannerState> mapEventToState(ScannerEvent event) async* {
    if (event is GetScannerEvent) {
      yield* scannerApi(event.data);
    }
  }
}

Stream<ScannerState> scannerApi(input) async* {
  if (await Network.isConnected()) {
    EasyLoading.show();
    QrcodeResponse response = await apiProvider.getQRcode(input);
    EasyLoading.dismiss();
    if (response.success) {
      yield GetScannerState(
          message: response.message, succes: response.success);
    } else {
      EasyLoading.dismiss();
      Utility.showToast(response.message);
    }
  } else {
    Utility.showToast("please_check_your_internet_connection_key".trim());
  }
}

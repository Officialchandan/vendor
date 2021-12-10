import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/model/gift_deliverd.dart';

import 'package:vendor/model/gift_scheme_response.dart';
import 'package:vendor/ui/account_management/gift%20scheme/git_scheme_event.dart';
import 'package:vendor/ui/account_management/gift%20scheme/git_scheme_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';

import '../../../main.dart';

class GiftSchemeBloc extends Bloc<GiftSchemeEvent, GiftSchemeState> {
  GiftSchemeBloc(GiftSchemeState initialState) : super(initialState);

  @override
  Stream<GiftSchemeState> mapEventTostate(GiftSchemeEvent event) async* {
    if (event is GetGiftSchemeEvent) {
      yield* getGiftScheme();
    }
  }

  Stream<GiftSchemeState> getGiftScheme() async* {
    if (await Network.isConnected()) {
      yield GetGiftSchemeLoadingstate();
      try {
        GiftSchemeResponse result = await apiProvider.getVendorGiftScheme();
        log("$result");
        if (result.success) {
          yield GetGiftSchemestate(
              succes: result.success,
              message: result.message,
              data: result.data);
        } else {
          yield GetGiftSchemeLoadingstate();
        }
      } catch (error) {
        yield GetGiftSchemeFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Fluttertoast.showToast(
          msg: "please_check_your_internet_connection_key".tr(),
          backgroundColor: ColorPrimary);
    }
  }
}

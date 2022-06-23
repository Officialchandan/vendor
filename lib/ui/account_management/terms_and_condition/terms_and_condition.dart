import 'dart:async';
import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/account_management/terms_and_condition/t&c_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  StreamController<TermsData> controller = StreamController();

  @override
  void initState() {
    getTncData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "t&c_with_signature".tr(),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<TermsData>(
            stream: controller.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: MediaQuery.of(context).size.height - 84,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasData) {
                return Container(
                  height: MediaQuery.of(context).size.height - 84,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 5,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "${snapshot.data!.termAndCondition.isEmpty ? "terms_and_condition_not_available_key".tr() : snapshot.data!.termAndCondition}",
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: TextBlackLight,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!.ownerSignature,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) =>
                                Center(child: Text("signature_not_available_key".tr())),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.70,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                height: MediaQuery.of(context).size.height - 84,
                child: Column(
                  children: [
                    Flexible(
                      flex: 5,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          "${snapshot.data!.termAndCondition.isEmpty ? "terms_and_condition_not_available_key".tr() : snapshot.data!.termAndCondition}",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: TextBlackLight,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.ownerSignature,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                          errorWidget: (context, url, error) => Center(child: Text("signature_not_available_key".tr())),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.70,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  getTncData() async {
    Map<String, dynamic> input = HashMap();
    input["vendor_id"] = await SharedPref.getIntegerPreference(SharedPref.VENDORID);
    if (await Network.isConnected()) {
      TermsResponse response = await apiProvider.tncWithSignature(input);
      controller.add(response.data!);
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}

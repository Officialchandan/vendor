import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/web_view_screen/webview_screen.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  List<String> textList = [
    "privacy_policy_key".tr(),
    "terms_conditions_key".tr(),
    "cancellation_refund_policy_key".tr(),
    "t&c_with_signature".tr(),
  ];

  List<String> imageList = [
    "assets/images/account-ic16.png",
    "assets/images/account-ic10.png",
    "assets/images/account-ic12.png",
    "assets/images/account-ic11.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed:(){Navigator.pop(context);},
        ),
        elevation: 0,
        // toolbarHeight: 120,
        title: Text(
          "terms_conditions_key".tr(),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        primary: false,
        children: List.generate(textList.length, (index) {
          print("assets/images/account-ic1.png");
          return GestureDetector(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xffbdbdbd))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(imageList[index], width: 26),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(textList[index],
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800)),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15),
                  ],
                ),
              ),
              onTap: () async {
                if (await Network.isConnected()) {
                  onClick(index);
                } else {
                  Utility.showToast(
                    msg: "please_check_your_internet_connection_key".tr(),
                  );
                }
              });
        }),
      ),
    );
  }

  Future<void> onClick(int currentIndex) async {
    switch (currentIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                    title: tr("privacy_policy_key"),
                    url: "http://vendor.myprofitinc.com/privacypolicy",
                  )),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                    title: tr("terms_conditions_key"),
                    url: "http://vendor.myprofitinc.com/terms",
                  )),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                    title: tr("cancellation_refund_policy_key"),
                    url: "http://vendor.myprofitinc.com/refundpolicy",
                  )),
        );
        break;
    }
  }
}

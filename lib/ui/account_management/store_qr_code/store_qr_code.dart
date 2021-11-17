import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor/utility/color.dart';

class StoreQRCode extends StatefulWidget {
  const StoreQRCode({Key? key}) : super(key: key);

  @override
  _StoreQRCodeState createState() => _StoreQRCodeState();
}

class _StoreQRCodeState extends State<StoreQRCode> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPrimary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("get_store_qr_code_key".tr()),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 105),
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 100),
                  decoration: BoxDecoration(
                    color: Color(0xff4639c0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.asset("assets/images/user.png",
                                width: 35, height: 35, fit: BoxFit.cover),
                          ),
                          SizedBox(width: 10),
                          Text("alexa_parker_key".tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("myprofitstore_alexa_key".tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 12),
                      Text("scan_qr_to_check_our_products_key".tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Positioned(
                  top: 130,
                  left: MediaQuery.of(context).size.width / 4,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset("assets/images/qr-code.png",
                        width: 160, fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 0),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(width: 1, color: Colors.white),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: ColorPrimary,
                      textColor: Colors.white,
                      child: Text("download_qr_key".tr().toUpperCase(),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(width: 1, color: Colors.white),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: Colors.white,
                      textColor: ColorPrimary,
                      child: Text("share_key".tr().toUpperCase(),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

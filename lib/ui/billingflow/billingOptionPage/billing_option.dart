import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/ui/billingflow/billingOptionPage/bloc/billing_option_bloc_bloc.dart';

import '../../../utility/color.dart';
import '../../../utility/sharedpref.dart';
import '../../home/home.dart';
import '../billing/billing.dart';
import '../direct_billing/direct_billing.dart';

class BillingOptions extends StatefulWidget {
  var userStatus;
  BillingOptions({Key? key, required this.userStatus}) : super(key: key);

  @override
  State<BillingOptions> createState() => _BillingOptionsState();
}

class _BillingOptionsState extends State<BillingOptions> {
  BillingOptionBlocBloc billingResponseBloc = BillingOptionBlocBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.userStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "billing_option_key".tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          leading: Text(""),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
                },
                icon: Icon(Icons.home))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customcard("billing_key".tr(), "assets/images/invoice.png",
                  Colors.white, false),
              widget.userStatus == 1 || widget.userStatus == 3
                  ? customcard("direct_billing_key".tr(),
                      "assets/images/direct-debit.png", Colors.white, true)
                  : Container(),
            ],
          ),
        ));
  }

  Widget customcard(String type, String image, Color color, bool iscolor) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () async {
          if (iscolor) {
            Navigator.push(
                context,
                PageTransition(
                    child: DirectBilling(
                        usertype: await SharedPref.getIntegerPreference(
                            SharedPref.USERSTATUS)),
                    type: PageTransitionType.fade));
          } else {
            Navigator.push(
                context,
                PageTransition(
                  child: BillingScreen(),
                  type: PageTransitionType.bottomToTop,
                ));
          }
          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => instruction()));
        },
        child: Material(
          color: color,

          borderRadius: BorderRadius.circular(14.0),
          elevation: 2.5,
          child: Container(
            decoration: BoxDecoration(
              border: Border(

                bottom: BorderSide(width: 2.0, color: ColorPrimary),
              ),
              color: Colors.white,
            ),
            height: 200.0,
            width: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                 Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: 200,
                    height: 70,

                    child: Image.asset(image,color: ColorPrimary,),
                     ),
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        type,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

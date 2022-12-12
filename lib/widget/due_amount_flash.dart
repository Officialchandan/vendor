// ignore_for_file: deprecated_member_use
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:vendor/utility/color.dart';

class DueAmountFlash extends StatefulWidget {
  final amount;
  String? lastpayamount;
  Function navigatetoUpi;
  DueAmountFlash(
      {Key? key, this.amount, required this.navigatetoUpi, this.lastpayamount})
      : super(key: key);

  @override
  State<DueAmountFlash> createState() => _DueAmountFlashState();
}

class _DueAmountFlashState extends State<DueAmountFlash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      //color: Colors.redAccent,
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Marquee(
                  text: 'your_last_Pay_Key'.tr() +
                      "${widget.lastpayamount}" +
                      "your_total_pay_key".tr() +
                      "${widget.amount}" +
                      "due_amount_flash".tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 236, 2, 2)),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 40.0,
                  velocity: 20.0,
                  pauseAfterRound: Duration(seconds: 1),
                  startPadding: 4.0,
                  accelerationDuration: Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
            ),
            SizedBox(
              width: 95,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
                child: MaterialButton(
                  // borderRadius: BorderRadius.all(Radius.circular(0)),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  color: ColorPrimary,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontFamily: 'Agne',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: Duration(milliseconds: 100),
                      animatedTexts: [
                        ScaleAnimatedText(
                          'pay_now'.tr(),
                        ),
                      ],
                      onTap: () {
                        setState(() {
                          widget.navigatetoUpi();
                        });
                      },
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

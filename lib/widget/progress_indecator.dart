import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:vendor/utility/color.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.60,
        child: Center(
          child: SizedBox(
            width: 45,
            child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: [
                  Color(0xFFABA2F6),
                  Color(0xFF887BFC),
                  Color(0xFF796AFF),
                  Color(0xFF5344F8),
                  Color(0xFF4530FC),
                  ColorPrimary,
                ],
                strokeWidth: 2,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.black),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/utility/color.dart';

class AppButton extends StatelessWidget {
  final onPressed;
  final title;
  final double width;
  final double height;

  AppButton({this.title, this.onPressed, this.width = 220, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      height: height,
      padding: const EdgeInsets.all(8.0),
      textColor: Colors.white,
      color: ColorPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey.shade300,
      onPressed: onPressed,
      child: new Text(
        "$title",
        style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
      ),
    );
  }
}

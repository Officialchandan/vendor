import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../../utility/color.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ColorPrimary,
        child: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
                Text(
                  "Select Language",
                  style: GoogleFonts.openSans(
                      fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700, decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "Please select your language",
                  style: GoogleFonts.openSans(
                      fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: GestureDetector(
                            child: Container(
                              child: Center(
                                child: Text(
                                  'English',
                                  style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      letterSpacing: 0.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(75),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: Color(0xff9b67d8), spreadRadius: 10, blurRadius: 0),
                                ],
                              ),
                              height: 100,
                              width: 100,
                            ),
                            onTap: () {
                              context.locale = Locale('en');

                              SharedPref.setStringPreference(SharedPref.SELECTEDLANG, "en");
                              Navigator.pushNamed(context, Routes.LoginScreen);
                            }),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: GestureDetector(
                            child: Container(
                              child: Center(
                                child: Text(
                                  'हिंदी',
                                  style: GoogleFonts.openSans(
                                      fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(75),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: Color(0xff9b67d8), spreadRadius: 10, blurRadius: 0),
                                ],
                              ),
                              height: 100,
                              width: 100,
                            ),
                            onTap: () {
                              context.locale = Locale('hi');

                              SharedPref.setStringPreference(SharedPref.SELECTEDLANG, "hi");
                              Navigator.pushNamed(context, Routes.LoginScreen);
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

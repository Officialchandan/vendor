import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/localization/app_translations.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';

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
        color: Color(0xff6657f4),
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
                                  BoxShadow(color: Color(0xff897ef7), spreadRadius: 10, blurRadius: 0),
                                ],
                              ),
                              height: 100,
                              width: 100,
                            ),
                            onTap: () {
                              AppTranslations.load(Locale("en")).then((value) {
                                SharedPref.setStringPreference(SharedPref.SELECTEDLANG, "en");
                                Navigator.pushNamed(context, Routes.LoginScreen);
                              });
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
                                  BoxShadow(color: Color(0xff897ef7), spreadRadius: 10, blurRadius: 0),
                                ],
                              ),
                              height: 100,
                              width: 100,
                            ),
                            onTap: () {
                              AppTranslations.load(Locale("hi")).then((value) {
                                SharedPref.setStringPreference(SharedPref.SELECTEDLANG, "hi");
                                Navigator.pushNamed(context, Routes.LoginScreen);
                              });
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

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

class ChangeLanGuage extends StatefulWidget {
  const ChangeLanGuage({Key? key}) : super(key: key);

  @override
  _ChangeLanGuageState createState() => _ChangeLanGuageState();
}

class _ChangeLanGuageState extends State<ChangeLanGuage> {
  var lang, toggle;
  clr() async {
    toggle = context.locale.languageCode;
    lang = context.locale.languageCode;
    print(context.locale.toString());

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/images/back.png",
            scale: 9,
          ),
        ),
        title: Text(
          "change_language_key".tr(),
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Center(
            child: Container(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      Text(
                        "change_language_key".tr(),
                        style: GoogleFonts.openSans(
                            fontSize: 30,
                            color: ColorPrimary,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "please_select_your_language_key".tr(),
                        style: GoogleFonts.openSans(
                            fontSize: 15,
                            color: ColorPrimary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none),
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
                                            color: toggle == "en"
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(75),
                                      color: toggle == "en"
                                          ? ColorPrimary
                                          : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 10,
                                            blurRadius: 0),
                                      ],
                                    ),
                                    height: 100,
                                    width: 100,
                                  ),
                                  onTap: () {
                                    context.locale = Locale('en');
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
                                        '???????????????',
                                        style: GoogleFonts.openSans(
                                            fontSize: 20,
                                            color: toggle == "hi"
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(75),
                                      color: toggle == "hi"
                                          ? ColorPrimary
                                          : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 10,
                                            blurRadius: 0),
                                      ],
                                    ),
                                    height: 100,
                                    width: 100,
                                  ),
                                  onTap: () {
                                    context.locale = Locale('hi');
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 10,
                    child: MaterialButton(
                      minWidth: 220,
                      height: 50,
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: ColorPrimary,
                      disabledColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: lang == toggle
                          ? null
                          : () async {
                              // await AppTranslations.load(Locale("${toggle}"));
                              // log("${toggle}");
                              SharedPref.setStringPreference(
                                  SharedPref.SELECTEDLANG, "${toggle}");
                              // Navigator.pushAndRemoveUntil(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SplashScreen()),
                              //     (Route<dynamic> route) => false);
                            },
                      child: new Text(
                        "update_button_key".tr(),
                        style: GoogleFonts.openSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

import 'UI/splash/splash_screen.dart';
import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';

Dio dio = Dio();
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate? _newLocaleDelegate = AppTranslationsDelegate(newLocale: Locale("en", ""));

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Color(0xff493ad6));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
        primaryColor: ColorPrimary,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorTextFeild,
          hintStyle: GoogleFonts.openSans(
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      localizationsDelegates: [
        _newLocaleDelegate!,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("hi", ""),
      ],
    );
  }

  void onLocaleChange(Locale locale) {
    print("${locale}");
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  init() async {
    var lang = await SharedPref.getStringPreference(SharedPref.SELECTEDLANG);
    print("${lang}");
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: Locale(lang.isEmpty ? "en" : lang, ""));
    setState(() {});
    application.onLocaleChanged = onLocaleChange;
  }
}

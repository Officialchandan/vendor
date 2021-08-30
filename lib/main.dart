import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendor/UI/home/home.dart';
import 'package:vendor/UI/language/select_language.dart';
import 'package:vendor/UI/login/login_screen.dart';
import 'package:vendor/provider/NavigationService.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/routs.dart';

import 'UI/splash/splash_screen.dart';
import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';

Dio dio = Dio();
NavigationService navigationService = NavigationService();
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate? _newLocaleDelegate =
      AppTranslationsDelegate(newLocale: Locale("en", ""));

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    const MaterialColor themeColor = const MaterialColor(
      0xFF6657f4,
      const <int, Color>{
        50: const Color(0xFF6657f4),
        100: const Color(0xFF6657f4),
        200: const Color(0xFF6657f4),
        300: const Color(0xFF6657f4),
        400: const Color(0xFF6657f4),
        500: const Color(0xFF6657f4),
        600: const Color(0xFF6657f4),
        700: const Color(0xFF6657f4),
        800: const Color(0xFF6657f4),
        900: const Color(0xFF6657f4),
      },
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      // statusBarColor is used to set Status bar color in Android devices.
      statusBarColor: Color(0xff493ad6),

      // To make Status bar icons color white in Android devices.
      statusBarIconBrightness: Brightness.light,

      // statusBarBrightness is used to set Status bar icon color in iOS.
      statusBarBrightness: Brightness.light,
      // Here light means dark color Status bar icons.
    ));

    // FlutterStatusbarcolor.setStatusBarColor(Color(0xff493ad6));
    return MaterialApp(
      title: 'My Profit vendor',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: themeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.openSans().fontFamily,
        // fontFamily: TextStyle().fontFamily,
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
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
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
      onGenerateRoute: (route) {
        switch (route.name) {
          case "/":
            return PageTransition(
                type: PageTransitionType.fade, child: SplashScreen());

          case Routes.SplashScreen:
            return PageTransition(
                type: PageTransitionType.fade, child: SplashScreen());
          case Routes.SelectLanguage:
            return PageTransition(
                type: PageTransitionType.fade, child: SelectLanguage());

          case Routes.LoginScreen:
            return PageTransition(
                type: PageTransitionType.fade, child: LoginScreen());

          case Routes.HomeScreen:
            return PageTransition(
                type: PageTransitionType.fade, child: HomeScreen());
        }
      },
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
    _newLocaleDelegate = AppTranslationsDelegate(
        newLocale: Locale(lang.isEmpty ? "en" : lang, ""));
    setState(() {});
    application.onLocaleChanged = onLocaleChange;
  }
}

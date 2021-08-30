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

ThemeData themeData = ThemeData(

    // backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.black,
    primarySwatch: MaterialColor(
      ColorPrimary.value,
      <int, Color>{
        50: Color(0xFFFFFFFF),
        100: Color(0xFFD4D1FD),
        200: Color(0xFFABA2F6),
        300: Color(0xFF887BFC),
        400: Color(0xFF796AFF),
        500: Color(ColorPrimary.value),
        600: Color(0xFF5344F8),
        700: Color(0xFF4530FC),
        800: Color(0xFF2C17FF),
        900: Color(0xFF1500F5),
      },
    ),
    iconTheme: IconThemeData(
      color: ColorPrimary,
      opacity: 1,
    ),
    // accentTextTheme: Theme.of(context).textTheme,
    fontFamily: GoogleFonts.openSans().fontFamily,
    primaryColor: ColorPrimary,
    primaryColorDark: ColorPrimary,
    accentColor: ColorPrimary,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      buttonColor: ColorPrimary,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color.fromRGBO(242, 242, 242, 1),
        hintStyle: TextStyle(
          color: Color.fromRGBO(85, 85, 85, 1.0),
          fontSize: 13,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15)),
    appBarTheme: AppBarTheme(
      elevation: 1,
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: Colors.red,
      //   // statusBarIconBrightness: Brightness.light,
      // ),
      brightness: Brightness.dark,
      backgroundColor: ColorPrimary,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      centerTitle: true,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      // toolbarTextStyle: Theme.of(context).textTheme.headline6!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      // titleTextStyle: Theme.of(context).textTheme.headline6!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ));
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorPrimary,
  ));

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
      title: 'Vendor',
      theme: themeData,
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
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: Locale(lang.isEmpty ? "en" : lang, ""));
    setState(() {});
    application.onLocaleChanged = onLocaleChange;
  }
}

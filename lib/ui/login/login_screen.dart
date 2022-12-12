import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:vendor/ui/login/login_bloc.dart';
import 'package:vendor/ui/login/login_event.dart';
import 'package:vendor/ui/login/login_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/routs.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';
import 'package:vendor/utility/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode focusNode = new FocusNode();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();

  // bool _passwordVisible = true;
  LoginBloc loginBloc = LoginBloc();
  // String _code = "";
  String signature = "{{ app signature }}";
  bool isResendOTPpage = false;
  Timer? _timer;
  int _counter = 0;
  StreamController<int> events = StreamController.broadcast();
  bool _tap = true;
  var email;

  // void _toggle() {
  //   setState(() {
  //     _passwordVisible = !_passwordVisible;
  //   });
  // }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "email_is_required_key".tr();
    } else if (!regExp.hasMatch(value)) {
      return "invalid_email_key".tr();
    } else {
      return null;
    }
  }

  void startTimer() {
    _counter = 60;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_counter > 0) ? _counter-- : _timer!.cancel();
      //});
      // print(_counter);
      events.sink.add(_counter);
    });
  }

  onTouchKeyBoard() {
    return GestureDetector(onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    });
  }

  _displayDialog(BuildContext context, mobile) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StreamBuilder<int>(
              stream: events.stream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (snapshot.hasData) {
                  return WillPopScope(
                    onWillPop: () async {
                      if (_counter > 0) {
                        Utility.showToast(
                            msg: "try_after".tr() +
                                " $_counter " +
                                "seconds".tr() +
                                " " +
                                "try_after_hi".tr());
                        return Future.value(false);
                      } else {
                        isResendOTPpage = false;
                        return Future.value(true);
                      }
                    },
                    child: AlertDialog(
                      titlePadding: const EdgeInsets.only(
                          left: 18, right: 18, top: 10, bottom: 0),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      actionsPadding: const EdgeInsets.only(
                          left: 12, right: 12, top: 0, bottom: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: RichText(
                        text: TextSpan(
                          text: "${"otp_verification_key".tr()}\n",
                          style: GoogleFonts.openSans(
                            fontSize: 25.0,
                            height: 2.0,
                            color: TextBlackLight,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: "${"please_verify_your_otp_on_key".tr()}\n",
                              style: GoogleFonts.openSans(
                                fontSize: 14.0,
                                height: 1.5,
                                color: ColorTextPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "+91 $mobile",
                              style: GoogleFonts.openSans(
                                fontSize: 14.0,
                                height: 1.5,
                                color: ColorTextPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                      content: Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: _textFieldController,
                          cursorColor: ColorPrimary,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            counterText: "",
                            // fillColor: Colors.black,
                            hintText: "enter_otp_key".tr(),
                            hintStyle: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, right: 14, top: 0, bottom: 8),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                height: 50,
                                textColor: Colors.white,
                                color: ColorPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (_textFieldController.text.isEmpty) {
                                    Utility.showToast(
                                        msg: "please_enter_password_key".tr());
                                  } else {
                                    log("===>${_textFieldController.text}");
                                    EasyLoading.show();

                                    loginBloc.add(GetLoginOtpEvent(
                                        mobile: mobileController.text,
                                        otp: _textFieldController.text));
                                  }
                                  // loginApiCall(
                                  //     mobileController.text, _textFieldController.text);
                                },
                                child: new Text(
                                  "verify_key".tr(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              //  width: MediaQuery.of(context).size.width,
                              child: snapshot.data! > 0
                                  ? Text(
                                      "resend_OTP_after".tr() +
                                          " " +
                                          "${snapshot.data.toString()} " +
                                          "seconds".tr(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                          color: ColorTextPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none),
                                    )
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      onPressed: () {
                                        if (mobileController.text.isEmpty) {
                                          Utility.showToast(
                                              msg: "please_enter_username_key"
                                                  .tr());
                                        } else {
                                          log("===>${_textFieldController.text}");
                                          //  EasyLoading.show();
                                          // if (_tap == true) {
                                          //   _tap = false;
                                          //   loginApiOtpCall(
                                          //       mobileController.text);
                                          // }
                                          loginBloc.add(GetotpResendEvent(
                                              mobile: mobileController.text));
                                        }
                                        // loginApiCall(
                                        //     mobileController.text, _textFieldController.text);
                                      },
                                      child: new Text(
                                        "otp_resend".tr(),
                                        style: GoogleFonts.openSans(
                                            color: ColorPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  debugPrint("Please Wait some time stream are runing");
                  return Container();
                }
                return Container();
              });
        });
  }

  loginApiOtpCall(mobile) async {
    if (mobileController.text.isEmpty) {
      Utility.showToast(msg: "please_enter_username_key".tr());
      _tap = true;
    } else if (mobileController.text.length != 10) {
      Utility.showToast(msg: "please_enter_valid_mobile_key".tr());
      _tap = true;
    } else {
      EasyLoading.show();
      if (!isResendOTPpage) {
        startTimer();
      }
      loginBloc.add(GetLoginEvent(mobile: mobileController.text));
      log("===>$_tap");

      _tap = true;
    }
  }

  _onrefresh() {
    setState(() {});
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    //  events.sink.close();
    _timer!.cancel();
    _counter = 0;
    events.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    Widget mobileNumber = TextFormField(
      keyboardType: TextInputType.number,
      validator: (numb) => Validator.validateMobile(numb!, context),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 10,
      controller: mobileController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(242, 242, 242, 1),
        counterText: "",
        hintText: "please_enter_mobile_number_key".tr(),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "  +91  ",
              style: TextStyle(color: ColorPrimary),
            ),
            Container(
              height: 25,
              width: 1.5,
              margin: EdgeInsets.all(2),
              color: ColorTextPrimary,
            )
          ],
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        prefixIconConstraints: BoxConstraints(
            minWidth: 50, minHeight: 25, maxWidth: 51, maxHeight: 25),
        // errorText: Validator.validateMobile(edtMobile.text, context),
      ),
    );
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) async {
          await SharedPref.getIntegerPreference(SharedPref.USERSTATUS);
          if (state is GetLoginState) {
            _displayDialog(context, mobileController.text);
          }
          if (state is GetResendOptState) {
            if (state.isCheckStatus) {
              startTimer();
              Utility.showToast(msg: "otp_resend_successfully".tr());
            } else {
              //   Utility.showToast(msg: "");
            }
          }

          if (state is GetLoginOtpState) {
            _timer!.cancel();
            if (await SharedPref.getIntegerPreference(SharedPref.USERSTATUS) ==
                0) {
              Navigator.pushNamedAndRemoveUntil(context,
                  Routes.HomeScreenWithoutInventory, ModalRoute.withName("/"));
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.HomeScreen, ModalRoute.withName("/"));
            }
          }

          if (state is GetLoginFailureState) {
            Utility.showToast(msg: state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: RefreshIndicator(
                  onRefresh: () {
                    return _onrefresh();
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                            // height: deviceHeight,Ftex
                            //width: 400,
                            child: Image.asset(
                          "assets/images/bg.png",
                          // height: deviceHeight - 50,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        )),
                        Positioned(
                            right: 12,
                            top: 30,
                            child: Image.asset(
                              "assets/images/logo2.png",
                              // height: deviceHeight - 50,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                          left: 20,
                          right: 20,
                          top: deviceHeight * 0.17,
                          child: Container(
                            width: 500,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "login_key".tr(),
                                    style: GoogleFonts.openSans(
                                        fontSize: 28,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "add_your_details_to_login_key".tr(),
                                    style: GoogleFonts.openSans(
                                        fontSize: 17,
                                        color: ColorTextPrimary,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  mobileNumber,
                                  SizedBox(
                                    height: 80,
                                  ),
                                  Center(
                                    child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            minWidth: deviceWidth,
                                            height: 50,
                                            padding: const EdgeInsets.all(8.0),
                                            textColor: Colors.white,
                                            color: ColorPrimary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            onPressed: () {
                                              _textFieldController.clear();

                                              print(
                                                  "kuch to ${mobileController.text}");

                                              if (_tap == true) {
                                                _tap = false;
                                                FocusScope.of(context)
                                                    .unfocus();
                                                loginApiOtpCall(
                                                    mobileController.text);
                                              }
                                              // _displayDialog(
                                              //     context, mobileController.text);
                                            },
                                            child: new Text(
                                              "login_key".tr(),
                                              style: GoogleFonts.openSans(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          // Column(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   mainAxisAlignment: MainAxisAlignment.center,
                                          //   crossAxisAlignment: CrossAxisAlignment.stretch,
                                          //   children: <Widget>[
                                          //     PhoneFieldHint(controller: mobileController),
                                          //     //  Spacer(),
                                          //
                                          //     ElevatedButton(
                                          //       onPressed: () {
                                          //         Navigator.of(context)
                                          //             .push(MaterialPageRoute(builder: (_) => CodeAutoFillTestPage()));
                                          //       },
                                          //       child: Text("Test CodeAutoFill mixin"),
                                          //     )
                                          //   ],
                                          // ),
                                        ]),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Powered By ",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                    Text(
                      "TechPoints Concepts Pvt Ltd",
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorPrimary),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CodeAutoFillTestPage extends StatefulWidget {
  @override
  _CodeAutoFillTestPageState createState() => _CodeAutoFillTestPageState();
}

class _CodeAutoFillTestPageState extends State<CodeAutoFillTestPage>
    with CodeAutoFill {
  String? appSignature;
  String? otpCode;

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code!;
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        title: Text("Listening for code"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
            child: Text(
              "This is the current app signature: $appSignature",
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Builder(
              builder: (_) {
                if (otpCode == null) {
                  return Text("Listening for code...", style: textStyle);
                }
                return Text("Code Received: $otpCode", style: textStyle);
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

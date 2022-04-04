import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/splash/splash_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/sharedpref.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({Key? key}) : super(key: key);

  @override
  _LanguageBottomSheetState createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        child: Column(
          children: [
            Column(
              children: List.generate(Constant.langList.length, (index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color(0xffa2a2a2))),
                  ),
                  child: RadioListTile<int>(
                    activeColor: ColorPrimary,
                    contentPadding: EdgeInsets.all(0),
                    title: Text("${Constant.langList[index]["name"]}",
                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
                    value: index,
                    groupValue: _groupValue,
                    onChanged: (value) async {
                      setState(() {
                        _groupValue = value!;
                        print("x===>${_groupValue}");
                      });
                      _groupValue == 0
                          ? baseOptions.headers.addAll({
                              "languagecode": "${await SharedPref.setStringPreference(SharedPref.SELECTEDLANG, "en")}"
                            })
                          : baseOptions.headers.addAll({
                              "languagecode": "${await SharedPref.setStringPreference(SharedPref.SELECTEDLANG, "hi")}"
                            });
                    },
                  ),
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                TextButton(
                    onPressed: () {
                      if (_groupValue != -1) {
                        context.locale = Constant.langList[_groupValue]["code"] as Locale;
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()),
                            (Route<dynamic> route) => false);
                      }
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: ColorPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

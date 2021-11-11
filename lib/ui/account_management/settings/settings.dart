import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:vendor/ui/account_management/settings/about_us/about_us.dart';
import 'package:vendor/widget/language_bottom_sheet.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> textList = ["Change language", "About us", "Rate us", "Share app"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Settings"),
        ),
        body: ListView(
          children: List.generate(textList.length, (index) {
            return GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Color(0xffbdbdbd))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/images/setting-ic${index + 1}.png", width: 24),
                      SizedBox(width: 17),
                      Expanded(
                        child: Text(textList[index], style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15),
                    ],
                  ),
                ),
                onTap: () {
                  onClick(context, index);
                });
          }),
        ),
      ),
    );
  }
}

//on tap-function
Future<void> onClick(BuildContext context, int currentIndex) async {
  switch (currentIndex) {
    case 0:
      languageUpdateSheet(context);
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutUs()),
      );
      break;
    case 2:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AddProductScreen()),
      // );
      break;
    case 3:
      shareApp();
      break;
  }
}

void shareApp() async {
  Share.share("text");
}

void languageUpdateSheet(BuildContext context) {
  showMaterialModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(15),
        topLeft: Radius.circular(15),
      )),
      context: context,
      // barrierColor: Colors.transparent,
      builder: (context) {
        return LanguageBottomSheet();
      });
}

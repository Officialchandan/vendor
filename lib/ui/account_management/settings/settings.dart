import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:vendor/ui/account_management/settings/about_us/about_us.dart';
import 'package:vendor/ui/inventory/add_product/add_product_screen.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

//change-language
enum ChangeLanguageRadio { English, Hindi }
ChangeLanguageRadio? _character = ChangeLanguageRadio.English;
//change-language

class _SettingsState extends State<Settings> {
  List<String> TextList = ["Change language", "About us", "Rate us", "Share app"];

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
          children: List.generate(TextList.length, (index) {
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
                        child: Text(TextList[index], style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
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

//ontap-function
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddProductScreen()),
      );
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
  showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Wrap(
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  var requestRadioGlobal;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        )),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1, color: Color(0xffa2a2a2))),
                          ),
                          child: RadioListTile<ChangeLanguageRadio>(
                            contentPadding: EdgeInsets.all(0),
                            title: Text("English", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
                            value: ChangeLanguageRadio.English,
                            groupValue: _character,
                            onChanged: (ChangeLanguageRadio? value) {
                              setState(() {
                                _character = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1, color: Color(0xffa2a2a2))),
                          ),
                          child: RadioListTile<ChangeLanguageRadio>(
                            contentPadding: EdgeInsets.all(0),
                            title: Text("हिन्दी", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                            value: ChangeLanguageRadio.Hindi,
                            groupValue: _character,
                            onChanged: (ChangeLanguageRadio? value) {
                              setState(() {
                                _character = value;
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            child:
                                Text("Cancel", style: TextStyle(color: Color(0xffbe1919), fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        );
      });
}
//ontap-function

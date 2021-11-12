import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/account_management/delivery_setting/delivery_setting.dart';
import 'package:vendor/utility/color.dart';

class DeliveryAreas extends StatefulWidget {
  const DeliveryAreas({Key? key}) : super(key: key);

  @override
  _DeliveryAreasState createState() => _DeliveryAreasState();
}

class _DeliveryAreasState extends State<DeliveryAreas> {
  List<String> DeliveryAreasText = [
    "345, Harrison Avenue",
    "4780, Old Narcross Road"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Delivery_Areas_key".tr()),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Color(0xff555555),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 6),
                        labelText: "Add_serviceable_radius_key".tr(),
                        labelStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        suffixText: "KM_key".tr(),
                        suffixStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xff555555)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: Color(0xff555555),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 6),
                        labelText: "Add_serviceable_areas_key".tr(),
                        labelStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xff555555)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("serviceable_areas_key".tr(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                children: List.generate(DeliveryAreasText.length, (index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xffcacaca)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DeliveryAreasText[index],
                            style: TextStyle(
                                color: Color(0xff555555),
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        Image.asset("assets/images/delete.png", width: 20),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MaterialButton(
          minWidth: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text("DONE_key".tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          color: ColorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliverySetting()),
            );
          },
        ),
      ),
    );
  }
}

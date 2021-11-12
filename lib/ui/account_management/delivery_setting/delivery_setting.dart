import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/account_management/delivery_setting/delivery_areas/delivery_areas.dart';
import 'package:vendor/ui/account_management/delivery_setting/delivery_fee/delivery_fee.dart';
import 'package:vendor/ui/account_management/delivery_setting/delivery_time/delivery_time.dart';
import 'package:vendor/utility/color.dart';

class DeliverySetting extends StatefulWidget {
  const DeliverySetting({Key? key}) : super(key: key);

  @override
  _DeliverySettingState createState() => _DeliverySettingState();
}

class _DeliverySettingState extends State<DeliverySetting> {
  var DeliveryTitle = [
    "Delivery_Areas_key".tr(),
    "Delivery_time_key".tr(),
    "Delivery_Fee_key".tr(),
    "Accept_delivery_instructions_key".tr()
  ];

  var DeliverySubTitle = [
    "Add_serviceable_areas_key".tr(),
    "Add_estimated_time_for_delivery_key".tr(),
    "Free_Delivery_key".tr(),
    "Allow_customers_to_add_delivery_instructions_while_placing_orders_key".tr()
  ];

  bool DeliverySwitch = false;

  final List<Widget> DeliveryNavigate = [
    DeliveryAreas(),
    DeliveryTime(),
    DeliveryFee(),
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
          title: Text("Delivery_Setting_key".tr()),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: List.generate(DeliveryTitle.length, (index) {
              return GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 16, 0, 16),
                      decoration: BoxDecoration(
                        color: Color(0xfff4f4f4),
                        // borderRadius: BorderRadius.circular(6),
                        border: Border(
                          left: BorderSide(width: 4, color: ColorPrimary),
                        ),
                      ),
                      child: Row(
                        children: [
                          index < 3
                              ? Image.asset(
                                  "assets/images/home${index + 1}.png",
                                  width: 42)
                              : Container(),
                          index < 3 ? SizedBox(width: 20) : Container(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DeliveryTitle[index],
                                        style: TextStyle(
                                            color: Color(0xff303030),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    index > 2
                                        ? SizedBox(
                                            width: 60,
                                            height: 25,
                                            child: Switch(
                                              value: DeliverySwitch,
                                              onChanged: (value) {
                                                setState(() {
                                                  DeliverySwitch = value;
                                                });
                                              },
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              inactiveTrackColor:
                                                  Color(0xffdadada),
                                              activeTrackColor:
                                                  Color(0xffc2bcfb),
                                              activeColor: Color(0xff6657f4),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(DeliverySubTitle[index],
                                    style: TextStyle(
                                        color: Color(0xff555555),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  index < 3
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryNavigate[index]),
                        )
                      : Container();
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

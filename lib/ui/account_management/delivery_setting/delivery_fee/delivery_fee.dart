import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor/utility/color.dart';

class DeliveryFee extends StatefulWidget {
  const DeliveryFee({Key? key}) : super(key: key);

  @override
  _DeliveryFeeState createState() => _DeliveryFeeState();
}

enum FreePaidRadio {Free, Paid}
FreePaidRadio? _character = FreePaidRadio.Paid;

class _DeliveryFeeState extends State<DeliveryFee> {

  bool AddConditionSwitch = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("Delivery Fee"),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select delivery types", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),

              Row(
                children: [
                  Expanded(
                      child: RadioListTile<FreePaidRadio>(
                        dense: true,
                        contentPadding: EdgeInsets.all(0),
                        title: Text("Free Delivery", style: TextStyle(color: Color(0xff555555), fontSize: 15, fontWeight: FontWeight.w600)),
                        value: FreePaidRadio.Free,
                        groupValue: _character,
                        onChanged: (FreePaidRadio? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  Expanded(
                    child: RadioListTile<FreePaidRadio>(
                      dense: true,
                      contentPadding: EdgeInsets.all(0),
                      title: Text("Paid Delivery", style: TextStyle(color: Color(0xff555555), fontSize: 15, fontWeight: FontWeight.w600)),
                      value: FreePaidRadio.Paid,
                      groupValue: _character,
                      onChanged: (FreePaidRadio? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              _character ==  FreePaidRadio.Paid ? Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 6),
                      labelText: "Delivery fee",
                      labelStyle: TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.w500),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xff555555)),
                      ),
                    ),
                  ),

                  SizedBox(height: 28),
                  Container(
                    padding: EdgeInsets.fromLTRB(12, 16, 0, 16),
                    decoration: BoxDecoration(
                      color: Color(0xfff4f4f4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add condition", style: TextStyle(color: Color(0xff303030), fontSize: 15, fontWeight: FontWeight.w600)),
                        SizedBox(
                          width: 60,
                          height: 25,
                          child: Switch(
                            value: AddConditionSwitch,
                            onChanged: (value) {
                              setState(() {
                                AddConditionSwitch = value;
                              });
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            inactiveTrackColor: Color(0xffdadada),
                            activeTrackColor: Color(0xffc2bcfb),
                            activeColor: Color(0xff6657f4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  AddConditionSwitch == true ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 6),
                          labelText: "Free delivery on orders above",
                          labelStyle: TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.w500),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Color(0xff555555)),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      Text("Delivery fee of ₹50, on all order below ₹285", style: TextStyle(color: ColorPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  )
                      : Container(),
                ],
              )
                  : Container(),
            ],
          ),
        ),

      ),
    );
  }
}

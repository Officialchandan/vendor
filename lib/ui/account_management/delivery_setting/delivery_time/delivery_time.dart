import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor/utility/color.dart';
import '../delivery_setting.dart';

class DeliveryTime extends StatefulWidget {
  const DeliveryTime({Key? key}) : super(key: key);

  @override
  _DeliveryTimeState createState() => _DeliveryTimeState();
}

class _DeliveryTimeState extends State<DeliveryTime> {

  final openingDateController = TextEditingController();
  final closingDateController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    openingDateController.dispose();
    closingDateController.dispose();
    super.dispose();
  }

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
          title: Text("Delivery Time"),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                readOnly: true,
                controller: openingDateController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 6),
                  labelText: "Delivery time",
                  labelStyle: TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.w500),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xff555555)),
                  ),
                ),
                onTap: () async {
                  var date = await showTimePicker(
                    context: context,
                    // initialDate: DateTime.now(),
                    // firstDate: DateTime(1900),
                    // lastDate: DateTime(2100),
                    initialTime: TimeOfDay.now(),
                  );
                  openingDateController.text = date.toString().substring(0, 10);
                },
              ),

              SizedBox(height: 20),
              Text("Provide  an estimated time for the delivery of orders, making it easier for your customers to track orders. For eg, Delivery within 2-4 hours or 1-2 business days.", style: TextStyle(height: 1.5, color: Color(0xff303030), fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),

        bottomNavigationBar: MaterialButton(
          minWidth: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text("SAVE", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          color: ColorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
          onPressed: (){
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

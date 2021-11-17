import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/utility/color.dart';

class DueAmountScreen extends StatefulWidget {
  const DueAmountScreen({Key? key}) : super(key: key);

  @override
  _DueAmountScreenState createState() => _DueAmountScreenState();
}

class _DueAmountScreenState extends State<DueAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPrimary,
      appBar: AppBar(
        title: Text("money_due_upi_key".tr()),
        backgroundColor: ColorPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "₹ 5000",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .merge(TextStyle(color: Colors.white)),
            ),
            Text(
              "company_due_amount_key".tr(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: MaterialButton(
          onPressed: () {},
          height: 50,
          shape: RoundedRectangleBorder(),
          color: Colors.white,
          child: Text(
            "upi_transfer_key".tr(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

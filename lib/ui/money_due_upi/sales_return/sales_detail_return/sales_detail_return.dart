import 'package:flutter/material.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/widget/sales_return_details_bottom_sheet.dart';

class SalesReturnDetails extends StatefulWidget {
  const SalesReturnDetails({Key? key}) : super(key: key);

  @override
  _SalesReturnDetailsState createState() => _SalesReturnDetailsState();
}

class _SalesReturnDetailsState extends State<SalesReturnDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text(
              "Sales Return Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SalesReturnDetailsSheet();
                      });
                },
                icon: Icon(Icons.info_outline),
              ),
            ],
          ),
          body: Container()),
    );
  }
}

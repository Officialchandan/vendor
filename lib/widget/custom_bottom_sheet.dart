import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  final List<Option> options;
  final Function(Option option) onOptionSelect;

  CustomBottomSheet({required this.options, required this.onOptionSelect});

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.50,
          minHeight: MediaQuery.of(context).size.height * 0.40,
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.40,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      widget.onOptionSelect(widget.options[index]);
                      Navigator.pop(context);
                    },
                    title: Text(widget.options[index].optionName),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  );
                },
                itemCount: widget.options.length,
              ),
            ),
            ListTile(
              onTap: () => Navigator.pop(context),
              title: Center(
                child: Text(
                  "cancel_key".tr(),
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Option {
  String optionId;
  String optionName;

  Option({required this.optionName, required this.optionId});
}

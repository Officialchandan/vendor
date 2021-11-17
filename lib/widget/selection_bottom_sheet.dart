import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionBottomSheet extends StatefulWidget {
  final Function() onEdit;
  final Function() onAdd;

  SelectionBottomSheet({required this.onEdit, required this.onAdd});

  @override
  _SelectionBottomSheetState createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<SelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            Navigator.pop(context);
            widget.onAdd();
          },
          title: Text(
            "add_variant_key".tr(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
          height: 1,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            widget.onEdit();
          },
          title: Text(
            "edit_variant_key".tr(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
          height: 1,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          title: Text(
            "cancel_key".tr(),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .merge(TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }
}

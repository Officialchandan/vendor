import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';

class SelectImageBottomSheet extends StatelessWidget {
  final Function openCamera;
  final Function openGallery;

  SelectImageBottomSheet({required this.openCamera, required this.openGallery});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text("camera_key".tr()),
          onPressed: () {
            Navigator.pop(context);
            openCamera();
          },
        ),
        CupertinoActionSheetAction(
          child: Text("gallery_key".tr()),
          onPressed: () {
            Navigator.pop(context);
            openGallery();
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("cancel_key".tr()),
      ),
    );
  }
}

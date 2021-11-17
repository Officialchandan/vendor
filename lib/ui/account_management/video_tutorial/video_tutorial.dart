import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';

class VideoTutorial extends StatefulWidget {
  VideoTutorial({Key? key}) : super(key: key);

  @override
  _VideoTutorialState createState() => _VideoTutorialState();
}

class _VideoTutorialState extends State<VideoTutorial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "video_tutorials_key".tr(),
        ),
        body: Container());
  }
}

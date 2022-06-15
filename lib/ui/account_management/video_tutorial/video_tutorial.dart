import 'package:chewie/chewie.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:video_player/video_player.dart';

class VideoTutorial extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;
  VideoTutorial({
    required this.videoPlayerController,
    required this.looping,
    required this.autoplay,
  });

  @override
  _VideoTutorialState createState() => _VideoTutorialState();
}

class _VideoTutorialState extends State<VideoTutorial> {
  late ChewieController _chewieController;
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // IMPORTANT to dispose of all the used resources
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    _chewieController.pause();
  }

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      allowFullScreen: true,
      fullScreenByDefault: true,
      allowPlaybackSpeedChanging: false,
      allowMuting: false,
      aspectRatio: 4 / 7,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.videoPlayerController.dispose();
        _chewieController.dispose();
        _chewieController.pause();
        return true;
      },
      child: Scaffold(
          backgroundColor: ColorPrimary,
          appBar: CustomAppBar(
            title: "video_tutorials_key".tr(),
          ),
          body: Container(
            child: Chewie(
              controller: _chewieController,
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoTutorial extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final String id;
  final bool looping;
  final bool autoplay;
  VideoTutorial({required this.videoPlayerController, required this.looping, required this.autoplay, required this.id});

  @override
  _VideoTutorialState createState() => _VideoTutorialState();
}

class _VideoTutorialState extends State<VideoTutorial> {
  //late ChewieController _chewieController;

  YoutubePlayerController? _ytbPlayerController;

  // List<YoutubeModel> videosList = [
  //   YoutubeModel(id: 1, youtubeId: '`jA14r2ujQ7s`'),
  //   YoutubeModel(id: 2, youtubeId: 'UQGoVB_zMYQ'),
  //   YoutubeModel(id: 3, youtubeId: 'FLcRb289uEM'),
  //   YoutubeModel(id: 4, youtubeId: 'g2nMKzhkvxw'),
  //   YoutubeModel(id: 5, youtubeId: 'qoDPvFAk2Vg'),
  // ];
  // @override
  // void dispose() {
  //   super.dispose();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //   ]);
  //   // IMPORTANT to dispose of all the used resources
  //   widget.videoPlayerController.dispose();
  //   _chewieController.dispose();
  //   _chewieController.pause();
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _chewieController = ChewieController(
  //     videoPlayerController: widget.videoPlayerController,
  //     allowFullScreen: true,
  //     fullScreenByDefault: true,
  //     allowPlaybackSpeedChanging: false,
  //     allowMuting: false,
  //     aspectRatio: 4 / 8.5,
  //     autoInitialize: true,
  //     autoPlay: widget.autoplay,
  //     looping: widget.looping,
  //     errorBuilder: (context, errorMessage) {
  //       return Center(
  //         child: Text(
  //           errorMessage,
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();

    // _setOrientation([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _ytbPlayerController = YoutubePlayerController(
          initialVideoId: widget.id,
          params: YoutubePlayerParams(
            showFullscreenButton: true,
            autoPlay: true,
            desktopMode: true,
            loop: true,
            showControls: true,
            startAt: Duration(seconds: 30),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _ytbPlayerController!.close();
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.videoPlayerController.dispose();

        return true;
      },
      child: _ytbPlayerController != null
          ? SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.black,
                  body: Container(
                    child: Center(
                      child: _buildYtbView(),
                    ),
                  )),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 4 / 8,
      child: _ytbPlayerController != null
          ? YoutubePlayerIFrame(controller: _ytbPlayerController)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
//   _buildMoreVideoTitle() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(14, 10, 182, 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             "More videos",
//             style: TextStyle(fontSize: 16, color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _buildMoreVideosView() {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         child: ListView.builder(
//             itemCount: videosList.length,
//             physics: AlwaysScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   final _newCode = videosList[index].youtubeId;
//                   _ytbPlayerController.load(_newCode);
//                   _ytbPlayerController.stop();
//                 },
//                 child: Container(
//                   height: MediaQuery.of(context).size.height / 5,
//                   margin: EdgeInsets.symmetric(vertical: 7),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(18),
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: <Widget>[
//                         Positioned(
//                           child: CachedNetworkImage(
//                             imageUrl: "https://img.youtube.com/vi/${videosList[index].youtubeId}/0.jpg",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Image.asset(
//                               'assets/ytbPlayBotton.png',
//                               height: 30,
//                               width: 30,
//                             ),
//                           ),
//                         ),
//                       ],2
//                     ),
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }

// class YoutubeModel {
//   final int id;
//   final String youtubeId;
//
//   const YoutubeModel({required this.id, required this.youtubeId});
// }

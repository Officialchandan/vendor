import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/api/api_provider.dart';
import 'package:vendor/model/videoresponse.dart';
import 'package:vendor/ui/account_management/video_tutorial/video_tutorial.dart';
import 'package:vendor/utility/color.dart';
import 'package:video_player/video_player.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  StreamController<List<VideoPlayerData>> controller = StreamController();
  VideoPlayerResponse? videoPlayerResponse;
  getVideolist() async {
    videoPlayerResponse = await ApiProvider().getVideo();
    log('${videoPlayerResponse!.data}');
    controller.add(videoPlayerResponse!.data!);
    return videoPlayerResponse!.data!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("video_tutorials_key".tr()),
        ),
        body: StreamBuilder<List<VideoPlayerData>>(
            stream: controller.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: ColorPrimary));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("data_not_found_key".tr()),
                );
              }

              return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoTutorial(
                                      videoPlayerController:
                                          VideoPlayerController.network('${snapshot.data![index].url}'),
                                      looping: false,
                                      autoplay: true,
                                      id: "${snapshot.data![index].videoId}",
                                    ),
                                  ));
                            },
                            child: Stack(
                              children: [
                                Image.network("${snapshot.data![index].image}"),
                                Positioned(
                                    bottom: 10,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 5),
                                      width: MediaQuery.of(context).size.width * 0.75,
                                      child: Text(
                                        "${snapshot.data![index].title}",
                                        maxLines: 2,
                                        style: GoogleFonts.openSans(
                                            fontSize: 20, color: ColorPrimary, fontWeight: FontWeight.w600),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }));
            }));
  }
}

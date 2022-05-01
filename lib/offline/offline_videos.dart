import 'dart:io';
import 'dart:typed_data';

import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:cloudyml_app2/module/assignment_screen.dart';
import 'package:cloudyml_app2/module/quiz_screen.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoScreenOffline extends StatefulWidget {
  final int? sr;
  const VideoScreenOffline({this.sr});

  @override
  _VideoScreenOfflineState createState() => _VideoScreenOfflineState();
}

class _VideoScreenOfflineState extends State<VideoScreenOffline> {
  bool? loading = true;
  List<OfflineModel> videos = [];

  Future<void> getVideos() async {
    DatabaseHelper _dbhelper = DatabaseHelper();
    videos = await _dbhelper.getTasks();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: loading!
            ? Center(
                child: CircularProgressIndicator(),
              )
            : videos.length == 0
                ? Center(
                    child: Text(
                      'No downloaded videos',
                      style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.4)),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    child: Expanded(
                        child: ListView.builder(
                            itemCount: videos.length,
                            itemBuilder: (ctx, index) {
                              print('getting info--${videos[index].path}');
                              return OfflineViewer(
                                topic: videos[index].topic,
                                module: videos[index].module,
                                course: videos[index].course,
                                path: videos[index].path,
                              );
                            })),
                  ));
  }
}

class OfflineViewer extends StatefulWidget {
  final String? topic;
  final String? module;
  final String? course;
  final String? path;
  const OfflineViewer(
      {Key? key, this.topic, this.module, this.course, this.path})
      : super(key: key);

  @override
  State<OfflineViewer> createState() => _OfflineViewerState();
}

class _OfflineViewerState extends State<OfflineViewer> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;
  bool? loading = true;
  void getData() async {
    //--/data/user/0/com.example.cloudyml_app/app_flutter/file.mp4
    //--/data/user/0/com.example.cloudyml_app/app_flutter/LogicalOperators.mp4

    File videoFile = File(widget.path!);

    try {
      _videoController = VideoPlayerController.file(
        videoFile,
      )..initialize().then((value) {
          _videoController!.setLooping(false);
          _chewieController = ChewieController(
            materialProgressColors: ChewieProgressColors(
                playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
            cupertinoProgressColors: ChewieProgressColors(
                playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
            videoPlayerController: _videoController!,
            looping: false,
          );
          setState(() {
            loading = false;
          });
        });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loading!
            ? Container()
            : Container(
                height: (MediaQuery.of(context).size.width * 9) / 16,
                width: MediaQuery.of(context).size.width,
                child: Theme(
                    data: ThemeData.light().copyWith(
                      platform: TargetPlatform.android,
                    ),
                    child: Chewie(controller: _chewieController!))),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            widget.topic!,
            style: TextStyle(
                fontFamily: 'Bold', fontSize: 24, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Text(
                widget.course!,
                style: TextStyle(
                    fontFamily: 'SemiBold',
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7)),
              ),
              Text('  . ${widget.module!}',
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.5))),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

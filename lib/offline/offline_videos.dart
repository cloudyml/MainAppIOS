import 'dart:io';
import 'dart:typed_data';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
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
  bool showVideo = false;
  List<OfflineModel> videos = [];
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;

  Future<void> getVideos() async {
    DatabaseHelper _dbhelper = DatabaseHelper();
    videos = await _dbhelper.getTasks();
    setState(() {
      loading = false;
    });
  }

  void getData() async {
    //--/data/user/0/com.cloudyml.cloudymlapp/app_flutter/file.mp4
    //--/data/user/0/com.cloudyml.cloudymlapp/app_flutter/LogicalOperators.mp4
    File videoFile = File(videos[0].path!);

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

  void initializeVideoController(String path) {
    File videoFile = File(path);
    try {
      final _oldVideoController = _videoController;
      final _oldChewieController = _chewieController;
      if (_oldVideoController != null) {
        _videoController!.dispose();
      }
      if (_oldChewieController != null) {
        _chewieController!.dispose();
      }
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
    super.initState();
    getData();
    getVideos();
  }

  @override
  void dispose() {
    _videoController!.dispose();
    _chewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF7860DC),
              // gradient: gradient
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            // height: MediaQuery.of(context).size.height*.1 ,
            padding: const EdgeInsets.only(left: 0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .08),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Text(
                      'Offline-Videos',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .04),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .04),
          loading!
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : videos.length == 0
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 250, 0, 50),
                      child: Center(
                        child: Text(
                          'No downloaded videos',
                          style: TextStyle(
                              fontFamily: 'Medium',
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.4)),
                        ),
                      ),
                    )
                  : Expanded(
                      flex: 2,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            showVideo
                                ? AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: _chewieController != null
                                        ? Container(
                                            child: Chewie(
                                                controller: _chewieController!),
                                          )
                                        : Container(
                                            color: Colors.black,
                                            child: Center(
                                              child: Text(
                                                'Tap on downloaded Videos to play',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                  )
                                : Container(),
                            Expanded(
                              flex: loading! ? 10 : 2,
                              child: ListView.builder(
                                itemCount: videos.length,
                                itemBuilder: (ctx, index) {
                                  print('getting info--${videos[index].path}');
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showVideo = true;
                                        });
                                        initializeVideoController(
                                            videos[index].path!);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: index < 9
                                                        ? Text(
                                                            '  ${index + 1}',
                                                            style: TextStyle(
                                                                // fontSize: 18,
                                                                ),
                                                          )
                                                        : Text(
                                                            '${index + 1}',
                                                            style: TextStyle(
                                                                // fontSize: 17,
                                                                ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Text(
                                                  videos[index].topic!,
                                                  style: TextStyle(
                                                      fontFamily: 'Bold',
                                                      // fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Icon(
                                                Icons.download_done_sharp,
                                                color: Color(0xFF7860DC),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}

// class OfflineViewer extends StatefulWidget {
//   final String? topic;
//   final String? path;
//   const OfflineViewer(
//       {Key? key, this.topic, /* this.module, this.course,*/ this.path})
//       : super(key: key);

//   @override
//   State<OfflineViewer> createState() => _OfflineViewerState();
// }

// class _OfflineViewerState extends State<OfflineViewer> {
//   ChewieController? _chewieController;
//   VideoPlayerController? _videoController;
//   bool? loading = true;
//   void getData() async {
//     //--/data/user/0/com.cloudyml.cloudymlapp/app_flutter/file.mp4
//     //--/data/user/0/com.cloudyml.cloudymlapp/app_flutter/LogicalOperators.mp4

//     File videoFile = File(widget.path!);

//     try {
//       _videoController = VideoPlayerController.file(
//         videoFile,
//       )..initialize().then((value) {
//           _videoController!.setLooping(false);
//           _chewieController = ChewieController(
//             materialProgressColors: ChewieProgressColors(
//                 playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
//             cupertinoProgressColors: ChewieProgressColors(
//                 playedColor: Color(0xFFaefb2a), handleColor: Color(0xFFaefb2a)),
//             videoPlayerController: _videoController!,
//             looping: false,
//           );
//           setState(() {
//             loading = false;
//           });
//         });
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         loading!
//             ? Container()
//             : Container(
//                 height: (MediaQuery.of(context).size.width * 9) / 16,
//                 width: MediaQuery.of(context).size.width,
//                 child: Theme(
//                     data: ThemeData.light().copyWith(
//                       platform: TargetPlatform.android,
//                     ),
//                     child: Chewie(controller: _chewieController!))),
//         SizedBox(
//           height: 20,
//         ),
//         // Padding(
//         //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//         //   child: Text(
//         //     widget.topic!,
//         //     style: TextStyle(
//         //         fontFamily: 'Bold', fontSize: 24, color: Colors.black),
//         //   ),
//         // ),
//         // Padding(
//         //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//         //   child: Row(
//         //     children: [
//         //       Text(
//         //         widget.course!,
//         //         style: TextStyle(
//         //             fontFamily: 'SemiBold',
//         //             fontSize: 16,
//         //             color: Colors.black.withOpacity(0.7)),
//         //       ),
//         //       Text('  . ${widget.module!}',
//         //           style: TextStyle(
//         //               fontFamily: 'Medium',
//         //               fontSize: 16,
//         //               color: Colors.black.withOpacity(0.5))),
//         //     ],
//         //   ),
//         // ),
//         SizedBox(
//           height: 30,
//         ),
//       ],
//     );
//   }
// }

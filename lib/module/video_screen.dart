import 'dart:io';

import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:cloudyml_app2/module/assignment_screen.dart';
import 'package:cloudyml_app2/module/quiz_screen.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final int? sr;
  final bool? isdemo;
  const VideoScreen({required this.isdemo, this.sr});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;
  bool? loading = true;
  bool? downloading = false;
  Map<String, dynamic>? data;
  String? progressString = '';

  void getData() async {
    var dt = await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .doc(moduleId)
        .collection('Topics')
        .where('sr', isEqualTo: widget.sr)
        .get()
        .then((value) {
      setState(() {
        data = value.docs[0].data();
        topicId = value.docs[0].id;
      });
    });

    try {
      _videoController = VideoPlayerController.network(
        data!['url'],
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

  void getPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future download(Dio dio, String url, String savePath, String fileName) async {
    getPermission();
    var directory = await getApplicationDocumentsDirectory();
    try {
      setState(() {
        downloading = true;
      });
      Response response = await dio.get(
        url,
        onReceiveProgress: (rec, total) {
          print("Rec: $rec, Total:$total");
          print("path: ${directory.path}/${fileName}.mp4");
          setState(() {
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        },
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      print('savepath--$savePath');

      raf.writeFromSync(response.data);
      await raf.close();
      DatabaseHelper _dbhelper = DatabaseHelper();
      OfflineModel video = OfflineModel(
          topic: data!['name'],
          module: 'Module 1',
          course: 'Python for beginners',
          path: '${directory.path}/${fileName.replaceAll(' ', '')}.mp4');
      _dbhelper.insertTask(video);

      setState(() {
        downloading = false;
      });
    } catch (e) {
      print('e::$e');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          loading!
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      var directory = await getApplicationDocumentsDirectory();
                      download(
                          Dio(),
                          data!['url'],
                          "${directory.path}/${data!['name'].replaceAll(' ', '')}.mp4",
                          data!['name']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(width: 2, color: Color(0xFFaefb2a))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            downloading!
                                ? Text(
                                    progressString!,
                                    style: TextStyle(
                                        fontFamily: 'Medium',
                                        fontSize: 14,
                                        color: Colors.black),
                                  )
                                : Icon(
                                    Icons.download_rounded,
                                    size: 24,
                                    color: Color(0xFFaefb2a),
                                  ),
                            Text(
                              downloading! ? 'Downloading...' : 'Save offline',
                              style: TextStyle(
                                  fontFamily: 'Medium',
                                  fontSize: 14,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
      body: loading!
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFaefb2a),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      data!['name'],
                      style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 24,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Next Topics',
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          fontSize: 24,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.04),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('courses')
                          .doc(courseId)
                          .collection('Modules')
                          .doc(moduleId)
                          .collection('Topics')
                          .orderBy('sr')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data();
                                if (widget.isdemo!) {
                                  if (map['demo']) {
                                    return InkWell(
                                        onTap: () {
                                          setState(() {
                                            topicId =
                                                snapshot.data!.docs[index].id;
                                          });
                                          if (map['type'] == 'video') {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.bounceInOut,
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: VideoScreen(
                                                    sr: map['sr'],
                                                    isdemo: widget.isdemo,
                                                  )),
                                            );
                                          } else if (map['type'] ==
                                              'assignment') {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.bounceInOut,
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: AssignmentScreen(
                                                    isdemo: widget.isdemo!,
                                                    sr: map['sr'],
                                                  )),
                                            );
                                          } else if (map['type'] == 'quiz') {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.bounceInOut,
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: QuizPage(
                                                      //sr: map['sr'].toString(),
                                                      )),
                                            );
                                          }
                                        },
                                        child: NextItem(
                                            title: map['name'],
                                            type: map['type'],
                                            sr: map['sr'],
                                            thisSr: widget.sr));
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          topicId =
                                              snapshot.data!.docs[index].id;
                                        });
                                        if (map['type'] == 'video') {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.bounceInOut,
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: VideoScreen(
                                                  sr: map['sr'],
                                                  isdemo: widget.isdemo,
                                                )),
                                          );
                                        } else if (map['type'] ==
                                            'assignment') {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.bounceInOut,
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: AssignmentScreen(
                                                  isdemo: widget.isdemo!,
                                                  sr: map['sr'],
                                                )),
                                          );
                                        } else if (map['type'] == 'quiz') {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.bounceInOut,
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: QuizPage(
                                                    //sr: map['sr'].toString(),
                                                    )),
                                          );
                                        }
                                      },
                                      child: NextItem(
                                          title: map['name'],
                                          type: map['type'],
                                          sr: map['sr'],
                                          thisSr: widget.sr));
                                }
                              });
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class NextItem extends StatefulWidget {
  final String? title;
  final String? type;
  final int? sr;
  final int? thisSr;

  const NextItem({this.title, this.type, this.sr, this.thisSr});

  @override
  State<NextItem> createState() => _NextItemState();
}

class _NextItemState extends State<NextItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.sr == widget.thisSr
              ? Color(0xFFaefb2a).withOpacity(0.3)
              : Colors.transparent,
          border: widget.sr == widget.thisSr
              ? Border.all(color: Color(0xFFaefb2a).withOpacity(0.8), width: 2)
              : Border.all(color: Colors.transparent)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
        child: Row(
          children: [
            Icon(
              widget.type == 'video'
                  ? Icons.video_library_outlined
                  : widget.type == 'assignment'
                      ? Icons.list_alt_rounded
                      : Icons.quiz_outlined,
              size: 30,
              color: Colors.black.withOpacity(0.3),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 300,
              child: Text(
                widget.title!,
                style: TextStyle(
                    fontFamily: 'Medium', fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

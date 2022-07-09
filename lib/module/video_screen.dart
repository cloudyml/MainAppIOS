import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:cloudyml_app2/module/assignment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/utils/utils.dart';
import 'package:cloudyml_app2/widgets/assignment_bottomsheet.dart';
import 'package:cloudyml_app2/widgets/video_player_widgets/fastforward10.dart';
import 'package:cloudyml_app2/widgets/video_player_widgets/fullscreen_icon.dart';
import 'package:cloudyml_app2/widgets/video_player_widgets/replay10.dart';
import 'package:cloudyml_app2/widgets/video_player_widgets/time_elapsed.dart';
import 'package:cloudyml_app2/widgets/video_player_widgets/time_remaining.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final int? sr;
  final bool? isdemo;
  final String? courseName;
  const VideoScreen(
      {required this.isdemo, required this.sr, required this.courseName});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _videoController;
  bool? downloading = false;
  bool downloaded = false;
  Map<String, dynamic>? data;
  String? videoUrl;
  Future<void>? playVideo;
  bool enablePauseScreen = false;
  bool showAssignment = false;
  int? serialNo;
  String? assignMentVideoUrl;
  bool _disposed = false;
  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration? _duration;
  Duration? _position;
  bool switchTOAssignment = false;
  bool showAssignSol = false;
  bool showMore = false;
  int videoNumOfSection = 0;

  var _delayToInvokeonControlUpdate = 0;
  var _progress = 0.0;

  String? progressString = '';

  void getData() async {
    await setModuleId();
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .doc(moduleId)
        .collection('Topics')
        .where('sr', isEqualTo: 1)
        .get()
        .then((value) {
      setState(() {
        data = value.docs[0].data();
        topicId = value.docs[0].id;
        videoUrl = value.docs[0].data()['url'];
        serialNo = widget.sr;
      });
    });
    try {
      _videoController = VideoPlayerController.network(data!['url']);
      playVideo = _videoController!.initialize().then((value) {
        setState(() {
          _videoController!.addListener(_onVideoControllerUpdate);
          _videoController!.play();
        });
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> setModuleId() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .where('firstType', isEqualTo: 'video')
        .get()
        .then((value) {
      moduleId = value.docs[0].id;
    });
  }

  void _onVideoControllerUpdate() {
    if (_disposed) {
      return;
    }
    // _delayToInvokeonControlUpdate = 0;
    final now = DateTime.now().microsecondsSinceEpoch;
    if (_delayToInvokeonControlUpdate > now) {
      return;
    }
    _delayToInvokeonControlUpdate = now + 500;
    final controller = _videoController;
    if (controller == null) {
      debugPrint("The video controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("The video controller cannot be initialized");
      return;
    }
    if (_duration == null) {
      _duration = _videoController!.value.duration;
    }
    var duration = _duration;
    if (duration == null) return;
    setState(() {});

    var position = _videoController?.value.position;
    setState(() {
      _position = position;
    });
    final buffering = controller.value.isBuffering;
    setState(() {
      _isBuffering = buffering;
    });
    final playing = controller.value.isPlaying;
    if (playing) {
      if (_disposed) return;
      setState(() {
        _progress = position!.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;
  }

  void intializeVidController(String url) async {
    try {
      final oldVideoController = _videoController;
      if (oldVideoController != null) {
        oldVideoController.removeListener(_onVideoControllerUpdate);
        oldVideoController.pause();
        oldVideoController.dispose();
      }
      final _localVideoController = await VideoPlayerController.network(url);
      setState(() {
        _videoController = _localVideoController;
      });
      playVideo = _localVideoController.initialize().then((value) {
        setState(() {
          _localVideoController.addListener(_onVideoControllerUpdate);
          _localVideoController.play();
          _duration = _localVideoController.value.duration;
        });
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  void getPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future download({
    Dio? dio,
    String? url,
    String? savePath,
    String? fileName,
    String? courseName,
    String? topicName,
  }) async {
    getPermission();
    var directory = await getApplicationDocumentsDirectory();
    try {
      setState(() {
        downloading = true;
      });
      Response response = await dio!.get(
        url!,
        onReceiveProgress: (rec, total) {
          print("Rec: $rec, Total:$total");
          print("path: ${directory.path}/${fileName}.mp4");
          setState(() {
            progressString = ((rec / total) * 100).toStringAsFixed(0);
          });
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(response.headers);
      File file = File(savePath!);
      var raf = file.openSync(mode: FileMode.write);
      print('savepath--$savePath');

      raf.writeFromSync(response.data);
      await raf.close();
      DatabaseHelper _dbhelper = DatabaseHelper();
      OfflineModel video = OfflineModel(
          topic: topicName,
          path: '${directory.path}/${fileName!.replaceAll(' ', '')}.mp4');
      _dbhelper.insertTask(video);

      setState(() {
        downloading = false;
        downloaded = true;
      });
    } catch (e) {
      print('e::$e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
    _videoController!.dispose();
    _videoController = null;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    CourseDetails currentCourse =
        course.firstWhere((element) => element.courseDocumentId == courseId);
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.white,
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            final isPortrait = orientation == Orientation.portrait;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        enablePauseScreen = !enablePauseScreen;
                      });
                    },
                    child: Container(
                      color: Colors.black,
                      child: FutureBuilder(
                        future: playVideo,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (ConnectionState.done ==
                              snapshot.connectionState) {
                            return !showAssignSol
                                ? Stack(
                                    children: [
                                      Center(
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: VideoPlayer(_videoController!),
                                        ),
                                      ),
                                      _isBuffering
                                          ? Stack(
                                              children: [
                                                Center(
                                                  child: Container(
                                                    color: Color.fromARGB(
                                                        102, 0, 0, 0),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color.fromARGB(
                                                          114, 255, 255, 255),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      enablePauseScreen
                                          ? Stack(
                                              children: [
                                                Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: Color.fromARGB(
                                                        102, 0, 0, 0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: Icon(Icons
                                                                  .arrow_back_ios_new),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            Text(
                                                              data!['name'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                var directory =
                                                                    await getApplicationDocumentsDirectory();
                                                                download(
                                                                  dio: Dio(),
                                                                  fileName: data![
                                                                      'name'],
                                                                  url: data![
                                                                      'url'],
                                                                  savePath:
                                                                      "${directory.path}/${data!['name'].replaceAll(' ', '')}.mp4",
                                                                  topicName:
                                                                      data![
                                                                          'name'],
                                                                );
                                                                print(directory
                                                                    .path);
                                                              },
                                                              child:
                                                                  downloading!
                                                                      ? Icon(
                                                                          Icons
                                                                              .downloading_outlined,
                                                                          color:
                                                                              Colors.white,
                                                                        )
                                                                      : Icon(
                                                                          !downloaded
                                                                              ? Icons.download_for_offline
                                                                              : Icons.download_done_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            replay10(
                                                              videoController:
                                                                  _videoController,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                if (_isPlaying) {
                                                                  setState(() {
                                                                    _videoController!
                                                                        .pause();
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    enablePauseScreen =
                                                                        !enablePauseScreen;
                                                                    _videoController!
                                                                        .play();
                                                                  });
                                                                }
                                                              },
                                                              child: Icon(
                                                                _isPlaying
                                                                    ? Icons
                                                                        .pause
                                                                    : Icons
                                                                        .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                                size: 40,
                                                              ),
                                                            ),
                                                            fastForward10(
                                                              videoController:
                                                                  _videoController,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      VideoProgressIndicator(
                                                        _videoController!,
                                                        allowScrubbing: true,
                                                        colors:
                                                            VideoProgressColors(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  74,
                                                                  255,
                                                                  255,
                                                                  255),
                                                          bufferedColor:
                                                              Color(0xFFC0AAF5),
                                                          playedColor:
                                                              Color(0xFF7860DC),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                children: [
                                                                  timeElapsedString(
                                                                    position:
                                                                        _position!,
                                                                  ),
                                                                  Text(
                                                                    '/',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  timeRemainingString(
                                                                    duration:
                                                                        _duration!,
                                                                    position:
                                                                        _position!,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            fullScreenIcon(
                                                              isPortrait:
                                                                  isPortrait,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  )
                                : Center(
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        color: Colors.black,
                                        child: Center(
                                          child: Text(
                                            'Watch solution after submission',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              fontFamily: "Medium",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF7860DC),
                              ),
                            );
                          }
                        },
                      ),
                      // },
                      // ),
                    ),
                  ),
                ),
                isPortrait
                    ? Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.white,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  widget.courseName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: "Medium",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            child: Center(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        switchTOAssignment = false;
                                        showAssignSol = false;
                                      });
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Lectures',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          !switchTOAssignment
                                              ? Container(
                                                  height: 3,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  color: Color(0xFF7860DC),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _videoController!.pause();
                                        showAssignmentBottomSheet(
                                          context,
                                          horizontalScale,
                                          verticalScale,
                                        );
                                      });
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Assignments',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          switchTOAssignment
                                              ? Container(
                                                  height: 3,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  color: Color(0xFF7860DC),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                isPortrait
                    ? Expanded(
                        flex: 2,
                        child: !switchTOAssignment
                            ? Container(
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeBottom: true,
                                  removeTop: true,
                                  child: ListView.builder(
                                    itemCount: currentCourse
                                        .curriculum['sectionsName'].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      print(currentCourse);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(
                                                currentCourse.curriculum[
                                                    'sectionsName'][index],
                                                textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              tileColor: Color(0xFFC0AAF5),
                                            ),
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('courses')
                                                  .doc(courseId)
                                                  .collection('Modules')
                                                  .doc(moduleId)
                                                  .collection('Topics')
                                                  .orderBy('sr')
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.data != null) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: showMore
                                                            ? null
                                                            : 130,
                                                        child: MediaQuery
                                                            .removePadding(
                                                          context: context,
                                                          removeBottom: true,
                                                          removeTop: true,
                                                          child:
                                                              ListView.builder(
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      snapshot
                                                                          .data!
                                                                          .docs
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    Map<String,
                                                                            dynamic>
                                                                        map =
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index1]
                                                                            .data();
                                                                    if (currentCourse.curriculum['sectionsName']
                                                                            [
                                                                            index] ==
                                                                        map['section_name']) {
                                                                      if (map['type'] ==
                                                                          'video') {
                                                                        return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              serialNo = map['sr'];
                                                                            });
                                                                            if (map['type'] ==
                                                                                'video') {
                                                                              setState(() {
                                                                                showAssignment = false;
                                                                              });
                                                                              intializeVidController(map['url']);
                                                                            } else if (map['type'] ==
                                                                                'assignment') {
                                                                              setState(() {
                                                                                showAssignment = !showAssignment;
                                                                                serialNo = map['sr'];
                                                                                assignMentVideoUrl = map['solution'];
                                                                              });
                                                                            }
                                                                            setState(() {
                                                                              data = map;
                                                                              downloading = false;
                                                                              downloaded = false;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: serialNo == map['sr'] ? Color(0xFFDDD2FB).withOpacity(0.3) : Colors.transparent,
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 30,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Icon(Icons.play_circle_fill_rounded, size: 15),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        map['name'],
                                                                                        textScaleFactor: min(horizontalScale, verticalScale),
                                                                                        style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: 17,
                                                                                          fontFamily: "Medium",
                                                                                        ),
                                                                                        maxLines: 2,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return Container();
                                                                      }
                                                                    } else {
                                                                      return Container();
                                                                    }
                                                                  }),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            showMore =
                                                                !showMore;
                                                          });
                                                        },
                                                        child: Text(
                                                          showMore
                                                              ? 'Show less'
                                                              : 'Show more',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF7860DC,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : AssignmentScreen(
                                isdemo: false,
                                sr: serialNo,
                              ),
                      )
                    : Container(),
              ],
            );
          },
        ),
      ),
    ));
  }
}

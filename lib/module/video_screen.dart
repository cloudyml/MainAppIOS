import 'dart:io';
import 'dart:math';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:cloudyml_app2/models/video_details.dart';
import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:cloudyml_app2/module/assignment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final int? sr;
  final bool? isdemo;
  final String? courseName;
  const VideoScreen({required this.isdemo, this.sr, this.courseName});

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

  String convertToTwoDigits(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget timeRemainingString() {
    var timeRemaining = _duration?.toString().substring(2, 7);
    final duration = _duration?.inSeconds ?? 0;
    final currentPosition = _position?.inSeconds ?? 0;
    final timeRemained = max(0, duration - currentPosition);
    final mins = convertToTwoDigits(timeRemained ~/ 60);
    final seconds = convertToTwoDigits(timeRemained % 60);
    timeRemaining = '$mins:$seconds';

    return Positioned(
      bottom: 33,
      right: 55,
      child: Text(
        timeRemaining,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget timeElapsedString() {
    var timeElapsedString = "00.00";
    final currentPosition = _position?.inSeconds ?? 0;
    final mins = convertToTwoDigits(currentPosition ~/ 60);
    final seconds = convertToTwoDigits(currentPosition % 60);
    timeElapsedString = '$mins:$seconds';
    return Positioned(
      bottom: 33,
      left: 10,
      right: 0,
      child: Text(
        timeElapsedString,
        style: TextStyle(
            color: Colors.white,
            // fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget progressIndicator() {
    return Positioned(
      bottom: 27,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 95),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Color(0xFFC0AAF5),
            inactiveTrackColor: Color.fromARGB(135, 221, 210, 251),
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 3,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 1,
            ),
            thumbColor: Colors.white,
            overlayColor: Color.fromARGB(80, 255, 255, 255),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: 14,
            ),
            tickMarkShape: RoundSliderTickMarkShape(),
            activeTickMarkColor: Color(0xFFC0AAF5),
            inactiveTickMarkColor: Color(0xFFDDD2FB),
          ),
          child: Slider(
            value: max(0, min(_progress * 100, 100)),
            min: 0,
            max: 100,
            divisions: 100,
            // label: _position?.toString().split(".")[0],
            onChanged: (value) {
              setState(() {
                _progress = value * 0.01;
              });
            },
            onChangeStart: (value) {
              _videoController?.pause();
            },
            onChangeEnd: (value) {
              final duration = _videoController?.value.duration;
              if (duration != null) {
                var newValue = max(0, min(value, 99)) * 0.01;
                var millis = (duration.inMilliseconds * newValue).toInt();
                _videoController?.seekTo(Duration(milliseconds: millis));
                _videoController?.play();
              }
            },
          ),
        ),
      ),
    );
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
    List<VideoDetails> _video = Provider.of<List<VideoDetails>>(context);
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
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: IconButton(
                                                    onPressed: () {
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
                                                    icon: Icon(
                                                      _isPlaying
                                                          ? Icons.pause
                                                          : Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ),
                                                replay10(
                                                    videoController:
                                                        _videoController),
                                                fastForward10(
                                                    videoController:
                                                        _videoController),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(Icons
                                                        .arrow_back_ios_new),
                                                    color: Colors.white),
                                                timeElapsedString(),
                                                timeRemainingString(),
                                                Positioned(
                                                  bottom: 42.5 * verticalScale,
                                                  left: 55 * horizontalScale,
                                                  right: 100 * horizontalScale,
                                                  child: VideoProgressIndicator(
                                                    _videoController!,
                                                    allowScrubbing: true,
                                                    colors: VideoProgressColors(
                                                      backgroundColor:
                                                          Color.fromARGB(74,
                                                              255, 255, 255),
                                                      bufferedColor:
                                                          Color(0xFFC0AAF5),
                                                      playedColor:
                                                          Color(0xFF7860DC),
                                                    ),
                                                  ),
                                                ),
                                                // progressIndicator(),
                                                fullScreenIcon(
                                                    isPortrait: isPortrait),
                                                Positioned(
                                                  top: 15,
                                                  left: 40,
                                                  child: Text(
                                                    data!['name'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      var directory =
                                                          await getApplicationDocumentsDirectory();
                                                      download(
                                                        dio: Dio(),
                                                        fileName: data!['name'],
                                                        url: data!['url'],
                                                        savePath:
                                                            "${directory.path}/${data!['name'].replaceAll(' ', '')}.mp4",
                                                        topicName:
                                                            data!['name'],
                                                      );
                                                      print(directory.path);
                                                    },
                                                    child: downloading!
                                                        ? Icon(
                                                            Icons
                                                                .downloading_outlined,
                                                            color: Colors.white,
                                                          )
                                                        : Icon(
                                                            !downloaded
                                                                ? Icons
                                                                    .download_for_offline
                                                                : Icons
                                                                    .download_done_rounded,
                                                            color: Colors.white,
                                                          ),
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
                                        switchTOAssignment = true;
                                        showAssignSol = true;
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
                                // height: 500,
                                child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _video.length,
                                          itemBuilder: (context, index) {
                                            if(_video[index].type == 'video') {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    serialNo = int.parse(
                                                        _video[index].serialNo);
                                                  });
                                                  if (_video[index].type ==
                                                      'video') {
                                                    setState(() {
                                                      showAssignment = false;
                                                    });
                                                    intializeVidController(
                                                        _video[index].videoUrl);
                                                  } else if (_video[index]
                                                          .type ==
                                                      'assignment') {
                                                    setState(() {
                                                      showAssignment =
                                                          !showAssignment;
                                                      serialNo = int.parse(
                                                          _video[index]
                                                              .serialNo);
                                                      // assignMentVideoUrl =
                                                      //     map['solution'];
                                                    });
                                                  }
                                                  setState(() {
                                                    data = map;
                                                    downloading = false;
                                                    downloaded = false;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: serialNo ==
                                                            int.parse(
                                                                _video[index]
                                                                    .serialNo)
                                                        ? Color(0xFFDDD2FB)
                                                            .withOpacity(0.3)
                                                        : Colors.transparent,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: index < 9
                                                                  ? Text(
                                                                      '  ${index + 1}',
                                                                      style: TextStyle(
                                                                          // fontSize:
                                                                          //     18,
                                                                          ),
                                                                    )
                                                                  : Text(
                                                                      '${index + 1}',
                                                                      style: TextStyle(
                                                                          // fontSize:
                                                                          //     17,
                                                                          ),
                                                                    ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Icon(
                                                              Icons
                                                                  .play_circle_fill_rounded,
                                                              size: 15),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              _video[index]
                                                                  .videoTitle,
                                                              textScaleFactor: min(
                                                                  horizontalScale,
                                                                  verticalScale),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 17,
                                                                fontFamily:
                                                                    "Medium",
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
                                          },)
                               
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

class replay10 extends StatelessWidget {
  const replay10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 100),
        child: IconButton(
          onPressed: (() async {
            final currentPosition = await _videoController!.position;
            final newPosition = currentPosition! - Duration(seconds: 10);
            _videoController!.seekTo(newPosition);
          }),
          icon: Icon(
            Icons.replay_10,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class fastForward10 extends StatelessWidget {
  const fastForward10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // left:0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.only(right: 100),
        child: InkWell(
          onTap: (() async {
            final currentPosition = await _videoController!.position;
            final newPosition = currentPosition! + Duration(seconds: 10);
            _videoController!.seekTo(newPosition);
          }),
          child: Icon(
            Icons.forward_10,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class fullScreenIcon extends StatelessWidget {
  const fullScreenIcon({
    Key? key,
    required this.isPortrait,
  }) : super(key: key);

  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 17,
      // left: 0,
      right: 7,
      child: SafeArea(
        child: IconButton(
          onPressed: () {
            if (isPortrait) {
              AutoOrientation.landscapeRightMode();
            } else {
              AutoOrientation.portraitUpMode();
            }
          },
          icon: Icon(
            isPortrait
                ? Icons.fullscreen_rounded
                : Icons.fullscreen_exit_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

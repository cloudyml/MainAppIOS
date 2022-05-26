import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:video_player/video_player.dart';

class VideoPlayerCustom extends StatefulWidget {
  final String url;
  VideoPlayerCustom({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerCustomState createState() => _VideoPlayerCustomState();
}

class _VideoPlayerCustomState extends State<VideoPlayerCustom> {
  VideoPlayerController? _controller;
  Future<void>? _video;
  Duration? _position;
  Duration? _duration;
  bool _disposed = false;
  bool _isPlaying = false;
  var _delayToInvokeonControlUpdate = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _video = _controller!.initialize().then((_) {
      _controller?.addListener(_onVideoControllerUpdate);
      _controller!.play();
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
    final controller = _controller;
    if (controller == null) {
      debugPrint("The video controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("The video controller cannot be initialized");
      return;
    }
    if (_duration == null) {
      _duration = _controller!.value.duration;
    }
    var duration = _duration;
    if (duration == null) return;
    setState(() {});

    var position = _controller?.value.position;
    setState(() {
      _position = position;
    });
    final playing = controller.value.isPlaying;
    // if (playing) {
    //   if (_disposed) return;
    //   setState(() {
    //     _progress = position!.inMilliseconds.ceilToDouble() /
    //         duration.inMilliseconds.ceilToDouble();
    //   });
    // }
    _isPlaying = playing;
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
      // left: 0,
      right: 20,
      child: Text(
        timeRemaining,
        style: TextStyle(
            color: Colors.white,
            // fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget timeElapsedString() {
    var timeElapsedString = "00.00";
    // final duration = _duration?.inSeconds ?? 0;
    final currentPosition = _position?.inSeconds ?? 0;
    final mins = convertToTwoDigits(currentPosition ~/ 60);
    final seconds = convertToTwoDigits(currentPosition % 60);
    timeElapsedString = '$mins:$seconds';
    return Positioned(
      bottom: 33,
      left: 20,
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

  @override
  void dispose() {
    _disposed = true;
    _controller?.removeListener(_onVideoControllerUpdate);
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _video,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                final isPortrait = orientation == Orientation.portrait;
                return Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                    Positioned(
                      bottom: 45,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        _controller!,
                        allowScrubbing: true,
                        padding: EdgeInsets.all(20.0),
                        colors: VideoProgressColors(
                          playedColor: Color(0xFF7860DC),
                          bufferedColor: Color(0xFFC0AAF5),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          if (_controller!.value.isPlaying) {
                            setState(() {
                              _controller!.pause();
                            });
                          } else {
                            setState(() {
                              _controller!.play();
                            });
                          }
                        },
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Color(0xFFC0AAF5),
                          size: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
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
                                ? Icons.open_in_full_sharp
                                : Icons.close_fullscreen_outlined,
                            color: Color(0xFFC0AAF5),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    timeElapsedString(),
                    timeRemainingString()
                    // Positioned(
                    //   bottom: 10,
                    //   left: 0,
                    //   right: 0,
                    //   child: Text(
                    //     'Duration : ${_controller!.value.duration.toString().substring(3,7)}',
                    //     style: TextStyle(color: Colors.blue),
                    //   ),
                    // )
                  ],
                );
              },
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_controller!.value.isPlaying) {
      //       setState(() {
      //         _controller!.pause();
      //       });
      //     } else {
      //       setState(() {
      //         _controller!.play();
      //       });
      //     }
      //   },
      //   child:
      //       Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow),
      // ),
    );
  }
}

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _video = _controller!.initialize().then((_) => _controller!.play());
  }

  @override
  void dispose() {
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
                      top:0,
                      right:0,
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
                                ? Icons.fullscreen_sharp
                                : Icons.close_fullscreen_outlined,
                            color: Color(0xFFC0AAF5),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
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

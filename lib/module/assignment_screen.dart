import 'dart:io';
import 'package:cloudyml_app2/module/video_screen.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart';

class AssignmentScreen extends StatefulWidget {
  final int? sr;
  final bool isdemo;
  const AssignmentScreen({required this.isdemo, this.sr});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;
  bool? loading = true;
  Map<String, dynamic>? data;
  Map<String, dynamic>? subdata;
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
    var dt2 = await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .doc(moduleId)
        .collection('Topics')
        .where('sr', isEqualTo: widget.sr)
        .get()
        .then((value) {
      setState(() {
        subdata = value.docs[0].data();
      });
    });

    try {
      _videoController = VideoPlayerController.network(
        data!['solution'],
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

  Future<void> addSubmission() async {
    final _storage = FirebaseStorage.instance;

    await Permission.storage.request();
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );
      PlatformFile pdf;
      var fileName = result!.paths.toString().split('/').last;
      if (result != null) {
        setState(() {
          submitting = true;
        });
        var snapshot = await _storage
            .ref()
            .child('$fileName-${FirebaseAuth.instance.currentUser!.uid}')
            .putFile(File(result.files.first.path!));
        var downloadUrl = await snapshot.ref.getDownloadURL();
        Map<String, dynamic> map = {
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'file': downloadUrl.toString(),
          'filename': fileName.toString()
        };
        try {
          await FirebaseFirestore.instance
              .collection('courses')
              .doc(courseId)
              .collection('Modules')
              .doc(moduleId)
              .collection('Topics')
              .doc(topicId)
              .collection('Submissions')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set(map);
          showToast('File submitted successfully');
          setState(() {
            submitting = false;
          });
        } catch (e) {
          setState(() {
            submitting = false;
          });
        }
      }
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
      ),
      body: loading!
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFaefb2a),
              ),
            )
          : SingleChildScrollView(
              primary: true,
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Instructions :',
                      style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Linkify(
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(link.url);
                          } else {
                            showToast('Could not launch $link');
                            throw 'Could not launch $link';
                          }
                        },
                        text: data!['instructions']
                            .toString()
                            .replaceAll("<br>", "\n"),
                        style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 12,
                            color: Colors.black),
                        linkStyle: TextStyle(fontSize: 12, color: Colors.blue),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      data!['name'].toString().replaceAll("<br>", "\n"),
                      style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 24,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      data!['question'].toString().replaceAll("<br>", "\n"),
                      style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('courses')
                          .doc(courseId)
                          .collection('Modules')
                          .doc(moduleId)
                          .collection('Topics')
                          .doc(topicId)
                          .collection('Submissions')
                          .where('uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        Map<String, dynamic> map = {};

                        if (snapshot.data.docs.length != 0) {
                          map = snapshot.data!.docs[0].data();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: InkWell(
                                onTap: () async {
                                  await addSubmission();
                                },
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: snapshot.data.docs.length != 0
                                              ? Colors.white
                                              : Colors.black.withOpacity(0.1),
                                          gradient: snapshot.data.docs.length !=
                                                  0
                                              ? gradient
                                              : LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                  colors: [
                                                      Colors.black
                                                          .withOpacity(0.4),
                                                      Colors.black
                                                          .withOpacity(0.4)
                                                    ])),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text(
                                          snapshot.data.docs.length != 0
                                              ? '✓ Submitted'
                                              : '+ Add Submission',
                                          style: TextStyle(
                                              fontFamily: 'Medium',
                                              fontSize: 20,
                                              color:
                                                  snapshot.data.docs.length != 0
                                                      ? Colors.white
                                                      : Colors.black
                                                          .withOpacity(0.4)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    snapshot.data.docs.length != 0
                                        ? Flexible(
                                            child: InkWell(
                                              onTap: () {
                                                //addSubmission();
                                              },
                                              child: Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black
                                                            .withOpacity(0.1))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: Text(
                                                    '📂 ${map['filename']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'Medium',
                                                        fontSize: 16,
                                                        color: Colors.black
                                                            .withOpacity(0.4)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : submitting
                                            ? Flexible(
                                                child: Container(
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.1))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            'Uploading file...',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Medium',
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4))),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              LinearProgressIndicator(
                                                            color: Colors.blue,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                  ],
                                ),
                              ),
                            ),
                            snapshot.data.docs.length != 0
                                ? Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(
                                      'Solution :',
                                      style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  )
                                : Container(),
                            snapshot.data.docs.length != 0
                                ? Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Container(
                                        height:
                                            (MediaQuery.of(context).size.width *
                                                    9) /
                                                16,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Theme(
                                            data: ThemeData.light().copyWith(
                                              platform: TargetPlatform.android,
                                            ),
                                            child: Chewie(
                                                controller:
                                                    _chewieController!))),
                                  )
                                : Container(),
                          ],
                        );
                      }),
                  SizedBox(
                    height: 60,
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
                                if (widget.isdemo) {
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
                                                    isdemo: widget.isdemo,
                                                    sr: map['sr'],
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
                                                    sr: map['sr'],
                                                    isdemo: widget.isdemo,
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
                                                  isdemo: widget.isdemo,
                                                  sr: map['sr'],
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
                                                  sr: map['sr'],
                                                  isdemo: widget.isdemo,
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
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
    );
  }
}

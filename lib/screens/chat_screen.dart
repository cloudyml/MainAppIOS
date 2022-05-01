import 'dart:async';

import 'package:cloudyml_app2/screens/group_info.dart';
import 'package:cloudyml_app2/widgets/audio_msg_tile.dart';
import 'package:cloudyml_app2/widgets/bottom_sheet.dart';
import 'package:cloudyml_app2/widgets/file_msg_tile.dart';
import 'package:cloudyml_app2/widgets/image_msg_tile.dart';
import 'package:cloudyml_app2/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:image_picker/image_picker.dart";
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../widgets/bottom_sheet.dart';

class ChatScreen extends StatefulWidget {
  final groupData;
  final userData;
  String? groupId;

  ChatScreen({this.groupData, this.groupId, this.userData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
//....................VARIABLES.................................
  TextEditingController _message = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? pickedFile;

  String? pickedFileName;

  Directory? appStorage;

  ScrollController _scrollController = ScrollController();

  final StreamController<List<DocumentSnapshot>> _chatController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int chatLimit = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream<List<DocumentSnapshot>> listenToChatsRealTime() {
    _getChats();
    return _chatController.stream;
  }

  bool textFocusCheck = false;

  Record record = Record();
  bool isRecording = false;

//...............FUNCTIONS.........................

  //getting chats with pagination logic
  void _getChats() {
    var pageChatQuery = _firestore
        .collection("groups")
        .doc(widget.groupData!["id"])
        .collection("chats")
        .orderBy("time", descending: true)
        .limit(chatLimit);

    if (_lastDocument != null) {
      pageChatQuery = pageChatQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) return;

    var currentRequestIndex = _allPagedResults.length;
    pageChatQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalChats = snapshot.docs.toList();
          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalChats;
          } else {
            _allPagedResults.add(generalChats);
          }

          var allChats = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _chatController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalChats.length == chatLimit;
        }
      },
    );
  }

  //image picker from camera logic
  Future getImage() async {
    //to get the image from galary
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        pickedFile = File(xFile.path);
        pickedFileName = xFile.name.toString();
        uploadFile("image");
      }
    });
  }

  //file picker logic
  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File a = File(result.files.single.path.toString());
      pickedFile = a;
      pickedFileName = result.names[0].toString();
      uploadFile("file");
    }
  }

  //storing file/image to firestore database
  Future uploadFile(type) async {
    try {
      var sentData = await _firestore
          .collection("groups")
          .doc(widget.groupData!["id"])
          .collection("chats")
          .add({
        "link": "",
        "message": pickedFileName,
        "sendBy": widget.userData["name"],
        "time": FieldValue.serverTimestamp(),
        "type": type == "image"
            ? "image"
            : type == "audio"
                ? "audio"
                : "file",
      });
      var ref = FirebaseStorage.instance
          .ref()
          .child(type == "image"
              ? "images"
              : type == "audio"
                  ? "aduios"
                  : "files")
          .child(pickedFileName!);

      var uploadTask = await ref.putFile(pickedFile!);

      String fileUrl = await uploadTask.ref.getDownloadURL();

      await sentData.update({"link": fileUrl});
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  //storing message to firestore database
  void onSendMessage() async {
    //to send the text to server
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "message": _message.text,
        "sendBy": widget.userData["name"],
        "type": "text",
        "time": FieldValue.serverTimestamp()
      };

      await _firestore
          .collection("groups")
          .doc(widget.groupData!["id"])
          .collection("chats")
          .add(message);

      _message.clear();
      setState(() {
        textFocusCheck = false;
      });
    }
  }

  void startRecording() async {
    if (await Record().hasPermission()) {
      isRecording = true;
      await record.start(
        path: appStorage!.path.toString() +
            "/audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
        encoder: AudioEncoder.AAC,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
  }

  //stop recording and send audio message to firestore database
  void stopRecording() async {
    if (isRecording) {
      var filePath = await Record().stop();
      print("The audio file path is $filePath");
      pickedFile = File(filePath!);
      pickedFileName = filePath.split("/").last;
      isRecording = false;
      uploadFile("audio");
    }
  }

  //stop recording and delete recorde file
  void cancelRecording() async {
    if (isRecording) {
      var filePath = await Record().stop();
      var recordedFile = File(filePath.toString());
      if (await recordedFile.exists()) {
        await recordedFile.delete();
      }
      isRecording = false;
    }
  }

  //on record show bottom modal and send audio message
  void onSendAudioMessage() async {
    final size = MediaQuery.of(context).size;
    startRecording();
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBottomSheet(
              size: size,
              startRecording: startRecording,
              stopRecording: stopRecording,
              cancelRecording: cancelRecording,
            ),
          );
        });
  }

  //getting path to app's internal storage
  Future getStoragePath() async {
    var s;
    if (await Permission.storage.request().isGranted) {
      s = await getExternalStorageDirectory();
    }
    setState(() {
      appStorage = s;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoragePath();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              (_scrollController.position.maxScrollExtent) &&
          !_scrollController.position.outOfRange) {
        _getChats();
      }
    });
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    print("user name is ${widget.userData["name"]}");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: Colors.purple[800],
        elevation: 0,
        title: Container(
          padding: EdgeInsets.only(left: 0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_back),
                  )),
              CircleAvatar(
                radius: 22,
                backgroundImage:
                    NetworkImage(widget.groupData!["data"]["icon"]),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.52,
                          child: Text(
                            widget.groupData!["data"]["name"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Container(
                    width: width * 0.5,
                    child: const Text("Group Info"),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                print(widget.groupData);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) =>
                        GroupInfoScreen(groupData: widget.groupData!),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: appStorage == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  //Chats container
                  Container(
                    height: size.height / 1.27,
                    width: size.width,
                    child: StreamBuilder<List<DocumentSnapshot>>(
                      stream: listenToChatsRealTime(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.connectionState == ConnectionState.none) {
                          return snapshot.hasData
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Center(
                                  child: Text("Start a Conversation."),
                                );
                        } else {
                          if (snapshot.data != null) {
                            return ListView.builder(
                              reverse: true,
                              controller: _scrollController,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> map =
                                    // messageData =
                                    snapshot.data![index].data()
                                        as Map<String, dynamic>;

                                return messages(size, map, context, appStorage);
                              },
                            );
                          } else {
                            return Container();
                          }
                        }
                      },
                    ),
                  ),
                  //Message Text Field container
                  Container(
                    height: size.height / 10,
                    width: size.width * 1.2,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height / 12,
                      width: size.width / 1.1,
                      child: Row(children: [
                        Container(
                          height: size.height / 12,
                          width: size.width / 1.3,
                          child: TextField(
                            onChanged: (text) {
                              setState(() {
                                if (text.isNotEmpty) {
                                  textFocusCheck = true;
                                } else {
                                  textFocusCheck = false;
                                }
                              });
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _message,
                            autocorrect: true,
                            cursorColor: Colors.purple,
                            decoration: InputDecoration(
                              suffixIcon: Container(
                                width: width * 0.3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () => getFile(),
                                      icon: const Icon(
                                        Icons.attach_file,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.photo),
                                      onPressed: () => getImage(),
                                      color: Colors.purple,
                                    ),
                                  ],
                                ),
                              ),
                              fillColor: const Color.fromARGB(255, 119, 5, 181),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 35, 6, 194),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: "Type A Message",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  (10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Color.fromARGB(255, 141, 5, 136),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            focusColor: Colors.blue,
                            splashRadius: 30,
                            splashColor: Colors.blueGrey,
                            onPressed: textFocusCheck
                                ? onSendMessage
                                : onSendAudioMessage,
                            icon: textFocusCheck
                                ? const Icon(Icons.send)
                                : const Icon(Icons.mic),
                            color: Colors.white,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context,
      Directory? appStorage) {
    //help us to show the text and the image in perfect alignment
    return map['type'] == "text" //checks if our msg is text or image
        ? MessageTile(
            size,
            map,
            widget.userData["name"],
          )
        : map["type"] == "image"
            ? ImageMsgTile(
                map: map,
                displayName: widget.userData["name"],
                appStorage: appStorage)
            : map["type"] == "audio"
                ? Container(
                    child: AudioMsgTile(
                      size: size,
                      map: map,
                      displayName: widget.userData["name"],
                      appStorage: appStorage,
                    ),
                  )
                : FileMsgTile(
                    size: size,
                    map: map,
                    displayName: widget.userData["name"],
                    appStorage: appStorage,
                  );
  }
}

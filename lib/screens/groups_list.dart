import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../Providers/UserProvider.dart';
import '../widgets/group_tile.dart';

class GroupsList extends StatefulWidget {
  // const GroupsList({Key? key}) : super(key: key);
  // final groupData;
  // final userData;
  // String? groupId;

  // GroupsList({
  //   this.groupData,
  //   this.groupId,
  //   this.userData,
  // });

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  dynamic groupData;
  // dynamic userData;
  String? groupId;
  List<int> newchatcount = [];
  bool isLoading = false;
  int? count;
  List? groupsList = [];
  Map? userData = {};
  DateTime now = new DateTime.now();

  void loadGroups() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("groups")
        .where("student_id", isEqualTo: _auth.currentUser!.uid)
        .get()
        .then((value) {
      final groups = value.docs
          .map((doc) => {
                "id": doc.id,
                "data": doc.data(),
              })
          .toList();
      value.docs.forEach(
        (element) {},
      );
      setState(() {
        groupsList = groups;
      });
      print('group list is--$groupsList');
    });
    setState(() {
      isLoading = false;
    });
  }

  loadMentorGroups() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("groups")
        .where("mentors", arrayContains: _auth.currentUser!.uid)
        .get()
        .then((value) {
      print('group data is--{$value}');
      final groups = value.docs
          .map((doc) => {
                "id": doc.id,
                "data": doc.data(),
              })
          .toList();
      print('group data is the--{$groups}');
      setState(() {
        groupsList = groups;
      });
    });
    setState(() {
      isLoading = false;
    });
    print('This is mentor group list$groupsList');
  }

  loadUserData() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      print("user data-- ${value.data()}");
      setState(() {
        userData = value.data();
      });
      userData!["role"] == "student" ? loadGroups() : loadMentorGroups();
    });
    setState(() {
      isLoading = false;
    });
  }

  void getchatcount() async {
    for (var group in groupsList!) {
      await _firestore
          .collection("groups")
          .doc(group['id'])
          .collection("chats")
          .where('role',
              isEqualTo: userData!["role"] == "student" ? "mentor" : "student")
          .get()
          .then((value) {
        print('The value is----------${value.docs.length}');
        // setState(() {
        newchatcount.add(value.docs.length);
        print(newchatcount);
        // });
      });
    }
  }

  // Future<int> getcount() async {
  //   return await _firestore
  //       .collection("groups")
  //       .doc(widget.groupData!["id"])
  //       .get()
  //       .then((value) => value.data()!['count']);
  // }

  // Future<Widget> badges() async {
  //   // if (count > 0) {
  //   //     _showbadge = true;
  //   //   } else {
  //   //     _showbadge = false;
  //   //   }

  //   return Container(
  //     width: 10,
  //     height: 10,
  //     child: Text('${await getchatcount() - await getcount()}'),
  //   );

  //   //  Badge(
  //   //   showBadge: await getchatcount() > await getcount(),
  //   //   position: BadgePosition.topStart(top: 15, start: 15),
  //   //   animationType: BadgeAnimationType.scale,
  //   //   badgeContent: Text('${await getchatcount()- await getcount()}'),
  //   // );
  // }

  // void updatecount() async {
  //   // count =
  //   await _firestore.collection("groups").doc(groupdocid).get().then((value) {
  //     setState(() {
  //       count = value.data()!['count'];
  //     });
  //   });
  //   print('identifier------------------');
  //   print(count.toString());
  //   print('identifier------------------');
  // }

  String? groupdocid;
  // void getusersgroupdocid() async {
  //   await FirebaseFirestore.instance
  //       .collection('groups')
  //       .where('student_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       groupdocid = value.docs.first.id;
  //     });
  //   });
  //   await FirebaseFirestore.instance
  //       .collection('groups')
  //       .where('mentors', arrayContains: FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       groupdocid = value.docs.first.id;
  //     });
  //   });

  //   print('-------------------');
  //   print(groupdocid);
  //   print('-------------------');
  // }

  // void updatenewchatcount(int newchatcount) {
  //   newchatcount = newchatcount;
  // }

  @override
  void initState() {
    loadUserData();
    print(userData!["role"]);
    Future.delayed(Duration(milliseconds: 500), () {
      getchatcount();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title:
      //       Text(userData!["role"] == "student" ? "Groups" : "Groups(Mentor)"),
      //   actions: [],
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
                    Row(
                      children: [
                        Text(
                          'Chat',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      userData!["role"] == "student"
                          ? "Groups For You"
                          : "Groups For Mentors",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .05),
              ],
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : groupsList == null || groupsList!.isEmpty
                  ? Center(
                      heightFactor: 15,
                      child: Text(
                          userData!["role"] == "student"
                              ? "No Groups To Show!\n(Buy Course To Get Mentor's Support)!"
                              : "No Groups To Show!",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey)),
                    )
                  : Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            shrinkWrap: true,
                            reverse: false,
                            itemCount: groupsList!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  userprovider.userModel!.role == 'student'
                                      ? await _firestore
                                          .collection("groups")
                                          .doc(groupsList![index]['id'])
                                          .update({
                                          'studentCount': newchatcount[index]
                                        })
                                      : await _firestore
                                          .collection("groups")
                                          .doc(groupsList![index]['id'])
                                          .update({
                                          _auth.currentUser!.uid:
                                              newchatcount[index]
                                        });
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => ChatScreen(
                                        groupData: groupsList![index],
                                        groupId: groupsList![index]["id"],
                                        userData: userData,
                                      ),
                                    ),
                                  );
                                },
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("groups")
                                        .doc(groupsList![index]['id'])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            documentSnapshot) {
                                      // print((documentSnapshot.data!.data()
                                      //     as Map<String, dynamic>)['count']);
                                      return StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("groups")
                                            .doc(groupsList![index]['id'])
                                            .collection('chats')
                                            .where('role',
                                                isEqualTo: userprovider
                                                            .userModel!.role ==
                                                        'student'
                                                    ? 'mentor'
                                                    : 'student')
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          // print(
                                          //     'the count is ----------$count');
                                          // print(snapshot.data!.docs.length
                                          //     // as QueryDocumentSnapshot <Map<String,dynamic>>).data().length
                                          //     );
                                          if (snapshot.data != null) {
                                            return Badge(
                                              elevation: 3,
                                              badgeColor: Color.fromARGB(
                                                  255, 93, 250, 174),
                                              child: GroupTile(
                                                groupData: groupsList![index],
                                                userData: userData,
                                              ),
                                              showBadge: snapshot
                                                      .data!.docs.length >
                                                  ((userprovider.userModel!
                                                              .role ==
                                                          'student')
                                                      ? (documentSnapshot.data!
                                                              .data()
                                                          as Map<String,
                                                              dynamic>)['studentCount']
                                                      : (documentSnapshot.data!
                                                              .data()
                                                          as Map<String,
                                                              dynamic>)[_auth.currentUser!.uid]),
                                              position: BadgePosition.bottomEnd(
                                                  bottom: 15, end: 15),
                                              animationType:
                                                  BadgeAnimationType.scale,
                                              badgeContent: Text(
                                                '${snapshot.data!.docs.length - ((userprovider.userModel!.role == 'student') ? (documentSnapshot.data!.data() as Map<String, dynamic>)['studentCount'] : (documentSnapshot.data!.data() as Map<String, dynamic>)[_auth.currentUser!.uid])}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              // Text('${ getchatcount()-  getcount()}'),
                                            );
                                          } else
                                            return Container(
                                                // child: Text('abc'),
                                                );
                                        },
                                      );
                                    }),
                              );
                            }),
                      ),
                    ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/course.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home_screen.dart';
import 'package:cloudyml_app2/offline/offline_videos.dart';
import 'package:cloudyml_app2/module/video_screen.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/screens/chat_screen.dart';
import 'package:cloudyml_app2/screens/groups_list.dart';
import 'package:cloudyml_app2/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _selectedIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    Store(),
    VideoScreenOffline(),
    GroupsList()
  ];
  List<String> titles = [
    'Home',
    'Store',
    'Offline Videos',
    'Chat',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('UID--${FirebaseAuth.instance.currentUser!.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          titles[_selectedIndex!],
          style: TextStyle(fontFamily: 'SemiBold', color: Colors.black),
        ),
      ),
      body: PageView.builder(itemBuilder: (ctx, index) {
        return screens[_selectedIndex!];
      }),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(gradient: gradient),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, index) {
                            DocumentSnapshot document =
                                snapshot.data!.docs[index];
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            if (map["id"].toString() ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              return Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    map['mobilenumber'] != null
                                        ? Text(
                                            '+91 ${map['mobilenumber']}',
                                            style: TextStyle(
                                                fontFamily: 'SemiBold',
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontSize: 22),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    map['email'] != null
                                        ? Text(
                                            map['email'],
                                            style: TextStyle(
                                                fontFamily: 'SemiBold',
                                                color: Colors.black,
                                                fontSize: 22),
                                          )
                                        : Container(),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    )),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                      ),
                      Icon(
                        Icons.payment_rounded,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Payments',
                        style: TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 18,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                      ),
                      Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 18,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
                /*Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                      ),
                      Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 18,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),*/
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                      ),
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 18,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40)),
                    child: InkWell(
                      onTap: () {
                        logOut(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_outlined,
                              color: Colors.black, size: 20),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Logout',
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Container(
                      child: Row(
                    children: [
                      Container(
                          height: 30,
                          child: Image.asset(
                            'assets/Linkedin.png',
                            fit: BoxFit.contain,
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                          height: 34,
                          child: Image.asset(
                            'assets/Instagram.jpg',
                            fit: BoxFit.contain,
                          )),
                      Container(
                          height: 34,
                          child: Image.asset(
                            'assets/Telegram.png',
                            fit: BoxFit.contain,
                          ))
                    ],
                  )),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: AnimatedContainer(
          duration: Duration(microseconds: 300),
          child: BottomNavigationBar(
            iconSize: 24,
            backgroundColor: Colors.grey.shade50,
            elevation: 0,
            selectedItemColor: Colors.black,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            currentIndex: _selectedIndex!,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home_outlined,
                  color: Colors.black.withOpacity(0.5),
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                label: ' ',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.store_outlined,
                    color: Colors.black.withOpacity(0.5)),
                activeIcon: Icon(
                  Icons.store,
                  color: Colors.black,
                ),
                label: '   ',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.download_for_offline_outlined,
                    color: Colors.black.withOpacity(0.5)),
                activeIcon: Icon(
                  Icons.download_for_offline,
                  color: Colors.black,
                ),
                label: '   ',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.chat_bubble_outline_sharp,
                    color: Colors.black.withOpacity(0.5)),
                activeIcon: Icon(
                  Icons.chat_bubble_outline_sharp,
                  color: Colors.black,
                ),
                label: '   ',
              ),
            ],
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

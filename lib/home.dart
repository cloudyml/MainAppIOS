import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/aboutus.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/newhome.dart';
import 'package:cloudyml_app2/payments_history.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home_screen.dart';
import 'package:cloudyml_app2/homepage.dart';
import 'package:cloudyml_app2/offline/offline_videos.dart';
import 'package:cloudyml_app2/module/video_screen.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';

import 'package:cloudyml_app2/privacy_policy.dart';

import 'package:cloudyml_app2/screens/groups_list.dart';
import 'package:cloudyml_app2/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _selectedIndex = 0;
  bool openPaymentHistory = false;
  Map<String,dynamic>? userdetails={};
  List<Widget> screens = [Home(), StoreScreen(), VideoScreenOffline(), GroupsList()];
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

  void getuserdetails () async{
    await FirebaseFirestore.instance.collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid).get().
    then((value){

      print(value.data());
      setState(() {
        userdetails=value.data();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
        title: openPaymentHistory
            ? Text(
                'Payment History',
                style: TextStyle(fontFamily: 'SemiBold', color: Colors.black),
              )
            : Text(
                titles[_selectedIndex!],
                style: TextStyle(fontFamily: 'SemiBold', color: Colors.black),
              ),
      ),
      body: PageView.builder(itemBuilder: (ctx, index) {
        if (openPaymentHistory) {
          return PaymentHistory();
        } else {
          return screens[_selectedIndex!];
        }
      }),
      drawer:Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: [
            Container(
                height: height * 0.27,
                //decoration: BoxDecoration(gradient: gradient),
                color: HexColor('7B62DF'),
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
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        if (map["id"].toString() ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          return Padding(
                            padding:  EdgeInsets.all(width*0.05),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: width*0.089,
                                    backgroundImage: AssetImage('assets/user.jpg'),
                                  ),
                                  SizedBox(
                                    height: height*0.01,
                                  ),
                                  map['name'] != null
                                      ? Text(map['name'], style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: width*0.049
                                  ),
                                  )
                                      : Text(map['mobilenumber'], style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: width*0.049
                                  ),
                                  ),
                                  SizedBox(
                                    height: height*0.007,
                                  ),
                                  map['email'] != null
                                      ? Text(
                                    map['email'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width*0.038
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                )),
            InkWell(
              child: ListTile(
                title: Text('Home'),
                leading: Icon(
                  Icons.home,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
              },
            ),
            // InkWell(
            //   child: ListTile(
            //     title: Text('My Account'),
            //     leading: Icon(
            //       Icons.person,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            // ),
            InkWell(
              child: ListTile(
                title: Text('My Courses'),
                leading: Icon(
                  Icons.book,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () async{
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
              },
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentHistory()));
              },
              child: ListTile(
                title: Text('Payment History'),
                leading: Icon(
                  Icons.payment_rounded,
                  color:HexColor('6153D3'),
                ),
              ),
            ),
            Divider(thickness: 2,),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyPolicy()));
              },
              child: ListTile(
                title: Text('Privacy policy'),
                leading: Icon(
                  Icons.privacy_tip,
                  color: HexColor('6153D3'),
                ),
              ),
            ),
            InkWell(
              child: ListTile(
                title: Text('About Us'),
                leading: Icon(
                  Icons.info,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () async{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));
              },
            ),
            InkWell(
              child: ListTile(
                title: Text('LogOut'),
                leading: Icon(
                  Icons.logout,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () {
                logOut(context);
              },
            ),

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
                openPaymentHistory = false;
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


// StreamBuilder<QuerySnapshot>(
// stream: FirebaseFirestore.instance
//     .collection("Users")
// .snapshots(),
// builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
// if (!snapshot.hasData) return const SizedBox.shrink();
// return ListView.builder(
// itemCount: snapshot.data!.docs.length,
// itemBuilder: (BuildContext context, index) {
// DocumentSnapshot document =
// snapshot.data!.docs[index];
// Map<String, dynamic> map = snapshot.data!.docs[0]
//     .data() as Map<String, dynamic>;
// if (map["id"].toString() ==
// FirebaseAuth.instance.currentUser!.uid) {
// print('Printing map ${map}');
// return UserAccountsDrawerHeader(
// // accountEmail: userdetails!=null?Text(userdetails!['email']):Text(''),
// // accountName: userdetails!=null?Text(userdetails!['name']):Text(''),
// accountEmail: map['email'] != null ? Text(map['email']) : Text(' '),
// accountName: map['name'] != null ? Text(map['name']) : Text(' '),
// currentAccountPicture: GestureDetector(
// // onTap: (){
// //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountInfo()));
// // },
// child: CircleAvatar(
// backgroundColor: Colors.transparent,
// backgroundImage: NetworkImage(
// 'https://stratosphere.co.in/img/user.jpg'),
// ),
// ),
// decoration: BoxDecoration(
// color: HexColor('7B62DF'),
// ),
// );
// } else {
// return Container();
// }
// }
// );
// },
// ),
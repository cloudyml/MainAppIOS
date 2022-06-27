
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _formIndex = 1;
  // bool isFirstTime = false;
  // List<DocumentSnapshot> datas =[];
  //
  // getData() async {
  //   if (!isFirstTime) {
  //     QuerySnapshot snap =
  //     await FirebaseFirestore.instance.collection("Notifications").get();
  //     setState(() {
  //       isFirstTime = true;
  //       datas.addAll(snap.docs);
  //     });
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   isFirstTime = false;
  // }

  void initState() {
    Provider.of<UserProvider>(context, listen: false).reloadUserModel();
    // getData();
    // print(datas);
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;

    final userProvider=Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7860DC),
        title: Text('Notification Page'),
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _formIndex=1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary:_formIndex==1?  HexColor('6153D3'):Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(min(horizontalScale, verticalScale) * 5)),
                    ),
                    child: Text(
                      'Users Notifications',
                      textScaleFactor:
                      min(horizontalScale, verticalScale),
                      style: TextStyle(
                        color: _formIndex==1?Colors.white:HexColor('6153D3'),
                        fontSize: 18,
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _formIndex=2;

                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: _formIndex==2?HexColor('6153D3'):Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(min(horizontalScale, verticalScale) * 5)),
                    ),
                    child: Text(
                      'App Notification',
                      textScaleFactor:
                      min(horizontalScale, verticalScale),
                      style: TextStyle(
                        color: _formIndex==2?Colors.white:HexColor('6153D3'),
                        fontSize: 18,
                      ),
                    )),
              ],
            ),
          ),
          AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
            child: (_formIndex==1)?
            (userProvider.userModel?.userNotificationList!.length==0)?
               Column(
                 mainAxisSize: MainAxisSize.max,
                 children: [
                   SizedBox(
                     height: 220*verticalScale,
                   ),
                   Icon(Icons.notifications_none,size: 100,),
                   Text('No Notifications yet',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                   ),
                   Text('When you get notifications,they will show up here',
                     textAlign: TextAlign.center,
                     textScaleFactor: min(horizontalScale, verticalScale),
                     style: TextStyle(
                         fontSize: 20,
                     ),
                   )
                 ],
               )
                : ListView.builder(
                shrinkWrap: true,
                itemCount: userProvider.userModel?.userNotificationList!.length,
                  itemBuilder: (_,index){
                      return Column(
                          children: [
                            SizedBox(height: 10,),
                            ListTile(
                              title: Text(userProvider.userModel?.userNotificationList![index].title??''),
                              subtitle: Text(userProvider.userModel?.userNotificationList![index].body??''),
                              leading: Image.network(userProvider.userModel?.userNotificationList![index].notifyImage??''),
                              trailing: IconButton(
                                icon: Icon(Icons.delete,color: HexColor('#C70000'),),
                                onPressed: (){
                                      userProvider.removeFromNotificationP(userNotificationModel: userProvider.userModel?.userNotificationList![index]);
                                      userProvider.reloadUserModel();
                                },
                              ),
                            ),
                            Divider(thickness: 2,)
                          ],
                        );
                  }
              )
            :StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Notifications').snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    if(snapshot.data!.docs.length!=0){
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map = snapshot.data!.docs[index].data();
                            return Column(
                              children: [
                                SizedBox(height: 4*verticalScale,),
                                ListTile(
                                  title: Text(map['title']??''),
                                  subtitle: Text(map['description']??''),
                                  leading: Image.network(map['icon']??''),
                                ),
                                Divider(thickness: 2,)
                              ],
                            );
                          }
                      );
                    }else{
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 220*verticalScale,
                          ),
                          Icon(Icons.notifications_none,size: 100,),
                          Text('No Notifications yet',
                            textScaleFactor: min(horizontalScale, verticalScale),
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text('When you get notifications,they will show up here',
                            textAlign: TextAlign.center,
                            textScaleFactor: min(horizontalScale, verticalScale),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      );
                    }

                  }else {
                    return Container();
                  }
                }
            ),
          )
        ],
      ),


    );
  }
}



// ListView.builder(
//   shrinkWrap: true,
//   itemCount: datas.length,
//   itemBuilder: (context, index) {
//     //print(datas[index]["index"]);
//     return ListTile(
//       title: Text('${datas[index]["title"]}'??''),
//         subtitle: Text('${datas[index]["description"]}'??''),
//         leading: Image.network('${datas[index]["icon"]}'??''),
//       //   trailing: IconButton(
//       //     icon: Icon(Icons.delete),
//       //     onPressed: (){
//       //       setState((){
//       //         datas.removeAt(index);
//       //       });
//       //     },
//       // )
//     );
//   },
// ),
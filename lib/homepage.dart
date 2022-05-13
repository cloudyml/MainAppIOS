// ignore: import_of_legacy_library_into_null_safe

import 'package:cloudyml_app2/newhome.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:flutter/src/widgets/media_query.dart';
import 'package:intl/intl.dart';
// import 'package:ribbon/ribbon.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:skeleton_text/skeleton_text.dart';
//import 'package:floating_ribbon/floating_ribbon.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> list = [];

  late ScrollController _controller;
  final LinearGradient _gradient = const LinearGradient(
    colors: [Color.fromARGB(255, 3, 133, 7), Color.fromARGB(255, 2, 47, 85)],
  );

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromARGB(255, 180, 29, 206),
                Color.fromARGB(255, 6, 6, 211),
                Colors.teal
              ]
              // [Color(0xFF57ebde), Color(0xFFaefb2a)],
              ),
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image(
                image: AssetImage('assets/5.jpg'),
                height: height * .30,
                width: width * 15,
                fit: BoxFit.fill),
            SizedBox(
              height: 15,
            ),
            Container(
              height: height * .08,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Text(
                  'Welcome To CloudyML',
                  style: TextStyle(
                    fontFamily: 'GideonRoman',
                    color:
                        // Colors.black,
                        Colors.white,
                    fontSize: 23.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .7,
                    // height: .94,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Container(
                height: height * .1,
                width: width * .25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Get Complete Hands on Practical Learning Experience of Data Science with 1-1 Live Doubt Clearance Support Everyday.',
                  style: TextStyle(
                      fontFamily: 'Medium',
                      color:
                          //  Colors.black,
                          Colors.white,
                      fontSize: 12),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Feture Courses',
                style: TextStyle(
                    fontFamily: 'GideonRoman',
                    color:
                        // Colors.black,
                        Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: .9,
                    letterSpacing: 2),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Ribbon(
                    nearLength: 50,
                    farLength: 90,
                    title: 'Sale',
                    titleStyle: TextStyle(
                        color: Colors.black,
                        // Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    color: Color.fromARGB(255, 11, 139, 244),
                    location: RibbonLocation.topStart,
                    child: Container(
                      width: width * .9,
                      height: height * .50,
                      color: Color.fromARGB(255, 5, 10, 70),
                      child: Column(
                        children: [
                          img(width, height, 'assets/6.jpg'),
                          SizedBox(height: 10),
                          colname('Data Science Combo Course', 'By Akash Raj'),
                          SizedBox(
                            height: 10,
                          ),
                          Star(),
                          SizedBox(height: 10),
                          Buttoncombo(width, '10,999', '3,999'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Ribbon(
                    nearLength: 1,
                    farLength: .5,
                    title: '',
                    titleStyle: TextStyle(
                        color: Colors.black,
                        // Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    color: Color.fromARGB(255, 11, 139, 244),
                    location: RibbonLocation.topStart,
                    child: Container(
                      width: width * .9,
                      height: height * .50,
                      color: Color.fromARGB(255, 5, 10, 70),
                      child: Column(
                        children: [
                          img(width, height, 'assets/7.jpg'),
                          SizedBox(height: 10),
                          colname(
                              'Data/Business Analyst Course', 'By Akash Raj'),
                          SizedBox(
                            height: 10,
                          ),
                          Star(),
                          SizedBox(height: 10),
                          Button1(width, '3,999'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Ribbon(
                    nearLength: 1,
                    farLength: .5,
                    title: ' ',
                    titleStyle: TextStyle(
                        color: Colors.black,
                        // Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    color: Color.fromARGB(255, 11, 139, 244),
                    location: RibbonLocation.topStart,
                    child: Container(
                      width: width * .9,
                      height: height * .50,
                      color: Color.fromARGB(255, 5, 10, 70),
                      child: Column(
                        children: [
                          img(width, height, 'assets/8.jpg'),
                          SizedBox(height: 10),
                          colname('AWS Cloud Computing Course', 'By Akash Raj'),
                          SizedBox(
                            height: 10,
                          ),
                          Star(),
                          SizedBox(height: 10),
                          Button1(width, '10,999'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            safearea(),
            SizedBox(height: 15,),
            safearea1()
            
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/coupon_code.dart';
import 'package:cloudyml_app2/curriculam.dart';
import 'package:cloudyml_app2/demo/demo_course.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/payment_portal.dart';
import 'package:cloudyml_app2/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ribbon_widget/ribbon_widget.dart';

class CatelogueScreen extends StatefulWidget {
  const CatelogueScreen({Key? key}) : super(key: key);
  static ValueNotifier<String> coursePrice = ValueNotifier('');
  static ValueNotifier<Map<String, dynamic>>? map = ValueNotifier({});
  static ValueNotifier<double> _currentPosition = ValueNotifier<double>(0.0);
  static ValueNotifier<double> _closeBottomSheetAt = ValueNotifier<double>(0.0);
  @override
  State<CatelogueScreen> createState() => _CatelogueScreenState();
}

class _CatelogueScreenState extends State<CatelogueScreen>
    with SingleTickerProviderStateMixin, CouponCodeMixin {
  TabController? _tabController;
  // var _razorpay = Razorpay();
  var amountcontroller = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  GlobalKey? _positionKey = GlobalKey();

  // double closeBottomSheetAt = 0.0;
  // final scaffoldState = GlobalKey<ScaffoldState>();
  Map<String, dynamic> comboMap = {};

  String coursePrice = "";

  String? id;

  String couponAppliedResponse = "";

  //If it is false amountpayble showed will be the amount fetched from db
  //If it is true which will be set to true if when right coupon code is
  //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
  // declared below same for discount
  bool NoCouponApplied = true;

  String finalamountToDisplay = "";

  String finalAmountToPay = "";

  String discountedPrice = "";

  bool isPayButtonPressed = false;

  bool isPayInPartsPressed = false;

  bool isMinAmountCheckerPressed = false;

  bool isOutStandingAmountCheckerPressed = false;

  bool showCurriculum = false;

  bool bottomSheet = false;

  @override
  void initState() {
    super.initState();
    getCourseName();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  void getCourseName() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .get()
        .then((value) {
      setState(() {
        comboMap = value.data()!;
        coursePrice = value.data()!['Course Price'];
      });
    });
  }

  void _scrollListener() {
    RenderBox? box =
        _positionKey!.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double pixels = position.dy;
    CatelogueScreen._closeBottomSheetAt.value = pixels;
    CatelogueScreen._currentPosition.value = _scrollController.position.pixels;
    print(pixels);
    print(_scrollController.position.pixels);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    couponCodeController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    late final size;
    double height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            // print('Check');
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 20),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      bottomSheet: PayNowBottomSheet(
        currentPosition: CatelogueScreen._currentPosition,
        coursePrice: coursePrice,
        map: comboMap,
        popBottomSheetAt: CatelogueScreen._closeBottomSheetAt,
        // closeBottomSheetAt: closeBottomSheetAt(positionKey),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("courses").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> map =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  if (map["name"].toString() == "null") {
                    return Container();
                  }
                  if (document.id == courseId) {
                    CatelogueScreen.coursePrice.value = map['Course Price'];
                    CatelogueScreen.map!.value = map;
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 00.0, right: 18, left: 18, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(28),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.12,
                                            child: Image.network(
                                              map['image_url'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.58,
                                              child: Text(
                                                map['name'],
                                                style: TextStyle(
                                                    fontFamily: 'Bold',
                                                    color: Colors.black,
                                                    fontSize: 24),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.58,
                                              child: Text(
                                                map['description'],
                                                style: TextStyle(
                                                    fontFamily: 'Regular',
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 65,
                              ),
                              includes(context),
                              Container(
                                child: Curriculam(
                                  map: map,
                                ),
                              ),
                              Container(
                                key: _positionKey,
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
                                  //  key:key,
                                  // width: width * .9,
                                  // height: height * .5,
                                  color: Color.fromARGB(255, 24, 4, 104),
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Column(
                                      //  key:Gkey,
                                      children: [
                                        SizedBox(
                                          height: height * .03,
                                        ),
                                        Text(
                                          'Complete Course Fee',
                                          style: TextStyle(
                                              fontFamily: 'Bold',
                                              fontSize: 21,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '( Everything with Lifetime Access )',
                                          style: TextStyle(
                                              fontFamily: 'Bold',
                                              fontSize: 11,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          map["Course Price"],
                                          style: TextStyle(
                                              fontFamily: 'Medium',
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 35),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentScreen(
                                                          map: CatelogueScreen
                                                              .map!.value)),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Color.fromARGB(
                                                    255, 119, 191, 249),
                                                gradient: gradient),
                                            height: height * .08,
                                            width: width * .6,
                                            child: Center(
                                              child: Text(
                                                'Buy Now',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          ))
        ],
      ),
    );
  }
}

class PayNowBottomSheet extends StatelessWidget {
  ValueListenable<double> currentPosition;
  ValueListenable<double> popBottomSheetAt;
  String coursePrice;
  Map<String, dynamic> map;
  // double closeBottomSheetAt;

  PayNowBottomSheet({
    required this.currentPosition,
    required this.coursePrice,
    required this.map,
    required this.popBottomSheetAt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) {
        return ValueListenableBuilder(
          valueListenable: currentPosition,
          builder: (BuildContext context, double value, Widget? child) {
            return ValueListenableBuilder(
              valueListenable: popBottomSheetAt,
              builder: (BuildContext context, double position, Widget? child) {
                if (value > 0.0 && /*value < 500 && */ value <= position) {
                  return Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    // duration: Duration(milliseconds: 1000),
                    // curve: Curves.easeIn,
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              coursePrice,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Medium',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentScreen(map: map),
                                  ),
                                );
                              },
                              child: Container(
                                height: 60,
                                // width: 300,
                                color: Color(0xFF7860DC),
                                child: Center(
                                  child: Text(
                                    'Pay Now',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Medium',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 0.1,
                  );
                }
              },
            );
          },
        );
      },
      onClosing: () {},
    );
  }
}

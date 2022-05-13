import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/coupon_code.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/payment_portal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ComboStore extends StatefulWidget {
  final List<dynamic>? courses;
  ComboStore({Key? key, this.courses}) : super(key: key);

  @override
  State<ComboStore> createState() => _ComboStoreState();
}

class _ComboStoreState extends State<ComboStore> with CouponCodeMixin {
  // var _razorpay = Razorpay();
  var amountcontroller = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  String? id;
  final ScrollController _scrollController = ScrollController();

  String couponAppliedResponse = "";

  //If it is false amountpayble showed will be the amount fetched from db
  //If it is true which will be set to true if when right coupon code is
  //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
  // declared below same for discount
  bool NoCouponApplied = true;

  bool isPayButtonPressed = false;

  bool isPayInPartsPressed = false;

  bool isMinAmountCheckerPressed = false;

  bool isOutStandingAmountCheckerPressed = false;

  String finalamountToDisplay = "";

  String finalAmountToPay = "";

  String discountedPrice = "";

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   showToast("Payment successful");
  //   addCoursetoUser(id!);
  //   updateCouponDetailsToUser(
  //     couponCodeText: couponCodeController.text,
  //     courseBaughtId: id!,
  //     NoCouponApplied: NoCouponApplied,
  //   );
  //   pushToHome();
  //   print("Payment Done");
  // }

  // void pushToHome() {
  //   // Navigator.push(
  //   //   context,
  //   //   PageTransition(
  //   //       duration: Duration(milliseconds: 400),
  //   //       curve: Curves.bounceInOut,
  //   //       type: PageTransitionType.rightToLeft,
  //   //       child: HomePage()),
  //   // );
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       PageTransition(
  //         duration: Duration(milliseconds: 200),
  //         curve: Curves.bounceInOut,
  //         type: PageTransitionType.rightToLeft,
  //         child: HomePage(),
  //       ),
  //       (route) => false);
  //   print('pushedtohome');
  // }

  // void addCoursetoUser(String id) async {
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .update({
  //     'paidCourseNames': FieldValue.arrayUnion([id])
  //   });
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   showToast("Payment failed");
  //   print("Payment Fail");
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   print("External wallet");
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  // }
  @override
  void dispose() {
    super.dispose();
    couponCodeController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return ListView.builder(
                  // controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (map["name"].toString() == "null") {
                      return Container();
                    }
                    if (widget.courses!.contains(map['id'])) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                        child: InkWell(
                          onTap: () {
                            /*setState(() {
                              courseId = document.id;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CatelogueScreen()),
                            );*/
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width * .8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: Colors.grey.shade200,
                                ),
                                child: Row(
                                  //card on combopage
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      child: Image.network(
                                        map['image_url'].toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            child: Text(
                                              map["name"],
                                              style: const TextStyle(
                                                  fontFamily: 'Bold',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    map["language"],
                                                    style: TextStyle(
                                                        fontFamily: 'Medium',
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: width * .25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color:
                                                          Colors.grey.shade300),
                                                  child: Center(
                                                    child: Text(
                                                      '${map['videosCount']} videos',
                                                      style: TextStyle(
                                                          fontFamily: 'Medium',
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 10),
                                                      // overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: height * .07,
                                                width: width * .29,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    gradient: gradient),
                                                child: Center(
                                                  child: Text(
                                                    map['Amount Payable'],
                                                    style: TextStyle(
                                                        fontFamily: 'Bold',
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                map['Course Price'],
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontFamily: 'Bold',
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 10),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
              flex: 3,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("courses")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> map = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      if (map["name"].toString() == "null") {
                        return Container();
                      }

                      if (document.id == courseId) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 00.0, right: 18, left: 18, bottom: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [],
                                      ),
                                      Text(
                                        "PRICE DETAILS",
                                        style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Coupon code',
                                          style:
                                              TextStyle(fontFamily: 'Medium'),
                                        ),
                                      ),
                                      TextField(
                                        enabled: NoCouponApplied ? true : false,
                                        controller: couponCodeController,
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          fontFamily: 'Medium',
                                        ),
                                        decoration: InputDecoration(
                                          suffixIcon: TextButton(
                                            child: Text(
                                              'Apply',
                                              style: TextStyle(
                                                color: Color(0xFFaefb2a),
                                                fontFamily: 'Medium',
                                                fontSize: 18,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                NoCouponApplied =
                                                    whetherCouponApplied(
                                                  couponCodeText:
                                                      couponCodeController.text,
                                                );
                                                couponAppliedResponse =
                                                    whenCouponApplied(
                                                  couponCodeText:
                                                      couponCodeController.text,
                                                );
                                                finalamountToDisplay =
                                                    amountToDisplayAfterCCA(
                                                  amountPayable:
                                                      map['Amount Payable'],
                                                  couponCodeText:
                                                      couponCodeController.text,
                                                );
                                                finalAmountToPay =
                                                    amountToPayAfterCCA(
                                                  couponCodeText:
                                                      couponCodeController.text,
                                                  amountPayable:
                                                      map['Amount Payable'],
                                                );
                                                discountedPrice =
                                                    discountAfterCCA(
                                                        couponCodeText:
                                                            couponCodeController
                                                                .text,
                                                        amountPayable: map[
                                                            'Amount Payable']);
                                              });
                                              print('Button working');
                                            },
                                          ),
                                          fillColor: Colors.grey.shade100,
                                          filled: true,
                                          suffixIconConstraints: BoxConstraints(
                                              maxHeight: 50, minWidth: 100),
                                          // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          couponAppliedResponse,
                                          style: TextStyle(
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, bottom: 10, right: 18),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Course Price",
                                              style: TextStyle(
                                                fontFamily: 'Medium',
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              map["Course Price"],
                                              style: TextStyle(
                                                fontFamily: 'Medium',
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 10, right: 18),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Discount",
                                              style: TextStyle(
                                                fontFamily: 'Medium',
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              NoCouponApplied
                                                  ? '₹${map["Discount"]} /-'
                                                  : discountedPrice,
                                              style: TextStyle(
                                                fontFamily: 'Medium',
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 20,
                                        thickness: 1,
                                        indent: 0,
                                        endIndent: 0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 10, right: 18),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Amount Payable",
                                              style: TextStyle(
                                                fontFamily: 'Medium',
                                                fontSize: 18,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.grey.shade300),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      14.0),
                                                  child: Text(
                                                    NoCouponApplied
                                                        ? '₹${map["Amount Payable"]} /-'
                                                        : finalamountToDisplay,
                                                    style: TextStyle(
                                                      fontFamily: 'Medium',
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      PaymentButton(
                                        amountString: (double.parse(
                                                    NoCouponApplied
                                                        ? map[
                                                            'Amount_Payablepay']
                                                        : finalAmountToPay) *
                                                100.00)
                                            .toString(),
                                        buttonText:
                                            "Buy Now for ${map['Course Price']}",
                                        buttonTextForCode:
                                            "Buy Now for $finalamountToDisplay",
                                        changeState: () {
                                          setState(() {
                                            isPayButtonPressed =
                                                !isPayButtonPressed;
                                          });
                                        },
                                        courseDescription: map['description'],
                                        courseName: map['name'],
                                        isPayButtonPressed: isPayButtonPressed,
                                        NoCouponApplied: NoCouponApplied,
                                        scrollController: _scrollController,
                                        updateCourseIdToCouponDetails: () {
                                          setState(() {
                                            id = map['id'];
                                          });
                                        },
                                        // isPayInPartsPressed: isPayInPartsPressed,
                                        outStandingAmountString: (double.parse(
                                                    NoCouponApplied
                                                        ? map[
                                                            'Amount_Payablepay']
                                                        : finalAmountToPay) -
                                                1000)
                                            .toString(),
                                        // isMinAmountCheckerPressed:
                                        //     isMinAmountCheckerPressed,
                                        // isOutStandingAmountCheckerPressed:
                                        //     isOutStandingAmountCheckerPressed,
                                        couponCodeText:
                                            couponCodeController.text,
                                        courseId: map['id'],
                                        isItComboCourse: true,
                                        whichCouponCode: whichCouponCode(
                                            couponCodeText:
                                                couponCodeController.text),
                                      ),
                                      /*InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.bounceInOut,
                                          type: PageTransitionType.rightToLeft,
                                          child: DemoCourse()),
                                    );
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 350.0,
                                    color: Colors.transparent,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            gradient: gradient,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0))),
                                        child: const Center(
                                          child: Text(
                                            "Try Demo",
                                            style: TextStyle(
                                                fontFamily: 'Bold',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  ),
                                ),*/
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: 200,
                                        child: Text(
                                          "* Amount payable is inclusive of taxes. TERMS & CONDITIONS APPLY",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Regular',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ]),
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

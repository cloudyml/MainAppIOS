import 'dart:math';

import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/widgets/coupon_code.dart';
import 'package:cloudyml_app2/widgets/payment_portal.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? map;
  final bool isItComboCourse;
  const PaymentScreen(
      {Key? key, required this.map, required this.isItComboCourse})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with CouponCodeMixin {
  var amountcontroller = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // GlobalKey key = GlobalKey();
  // final scaffoldState = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> showBottomSheet = ValueNotifier(false);
  // VoidCallback? _showPersistentBottomSheetCallBack;

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
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
        body: Stack(
            children: [
        Container(
          width: screenWidth,
          height: screenHeight,
          color: Color(0xFF7860DC),
          child: Column(
            children: [
              SizedBox(
                height: 80 * verticalScale,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 29,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Payment Details',
                    textScaleFactor: min(horizontalScale, verticalScale),
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 173,
          left: 0,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              color: Color.fromRGBO(249, 249, 249, 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Courses',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      style: TextStyle(
                          color: Color.fromRGBO(48, 48, 49, 1),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 365.9999694824219,
                      height: 121.99999237060547,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Color.fromRGBO(31, 31, 31, 0.20000000298023224),
                              offset: Offset(2, 10),
                              blurRadius: 20)
                        ],
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.map!['image_url'],
                              fit: BoxFit.fill,
                              height: 110,
                              width: 127,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 194,
                                child: Text(
                                  widget.map!['name'],
                                  textScaleFactor:
                                      min(horizontalScale, verticalScale),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 194,
                                child: Text(
                                  widget.map!['description'],
                                  textScaleFactor:
                                      min(horizontalScale, verticalScale),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    height: 1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                'assets/Rating.png',
                                fit: BoxFit.fill,
                                height: 11,
                                width: 71,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'English  ||  ${widget.map!['videosCount']} Videos',
                                    textAlign: TextAlign.left,
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                        color: Color.fromRGBO(88, 88, 88, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    widget.map!['Course Price'],
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(155, 117, 237, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.bold,
                                        height: 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Coupon Code',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      style: TextStyle(
                          color: Color.fromRGBO(48, 48, 49, 1),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                    SizedBox(
                      height: 10,
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
                        constraints: BoxConstraints(minHeight: 52, minWidth: 366),
                        suffixIcon: TextButton(
                          child: Text(
                            'Apply',
                            style: TextStyle(
                              color: Color(0xFF7860DC),
                              fontFamily: 'Medium',
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              NoCouponApplied = whetherCouponApplied(
                                couponCodeText: couponCodeController.text,
                              );
                              couponAppliedResponse = whenCouponApplied(
                                couponCodeText: couponCodeController.text,
                              );
                              finalamountToDisplay = amountToDisplayAfterCCA(
                                amountPayable: widget.map!['Amount Payable'],
                                couponCodeText: couponCodeController.text,
                              );
                              finalAmountToPay = amountToPayAfterCCA(
                                couponCodeText: couponCodeController.text,
                                amountPayable: widget.map!['Amount Payable'],
                              );
                              discountedPrice = discountAfterCCA(
                                  couponCodeText: couponCodeController.text,
                                  amountPayable: widget.map!['Amount Payable']);
                            });
                            print('Button working');
                          },
                        ),
                        hintText: 'Enter coupon code',
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        suffixIconConstraints:
                            BoxConstraints(minHeight: 52, minWidth: 100),
                        // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Bill Details',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      style: TextStyle(
                          color: Color.fromRGBO(48, 48, 49, 1),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 366,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Color.fromRGBO(31, 31, 31, 0.20000000298023224),
                              offset: Offset(0, 0),
                              blurRadius: 5)
                        ],
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Course Price',
                                  style: TextStyle(
                                    color: Color.fromARGB(223, 48, 48, 49),
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  widget.map!['Course Price'],
                                  style: TextStyle(
                                      color: Color.fromARGB(223, 48, 48, 49),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Discount",
                                  style: TextStyle(
                                      color: Color.fromARGB(223, 48, 48, 49),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                                Text(
                                  NoCouponApplied
                                      ? '₹${widget.map!["Discount"]} /-'
                                      : discountedPrice,
                                  style: TextStyle(
                                      color: Color.fromARGB(223, 48, 48, 49),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                              ],
                            ),
                            DottedLine(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Pay',
                                  style: TextStyle(
                                      color: Color.fromARGB(223, 48, 48, 49),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                                Text(
                                  NoCouponApplied
                                      ? '₹${widget.map!["Amount Payable"]} /-'
                                      : finalamountToDisplay,
                                  style: TextStyle(
                                      color: Color.fromARGB(223, 48, 48, 49),
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: PaymentButton(
                        amountString: (double.parse(NoCouponApplied
                                    ? widget.map!['Amount_Payablepay']
                                    : finalAmountToPay) *
                                100)
                            .toString(),
                        buttonText: NoCouponApplied
                            ? 'Buy Now for ${widget.map!['Course Price']}'
                            : 'Buy Now for ${finalamountToDisplay}',
                        buttonTextForCode: "Buy Now for $finalamountToDisplay",
                        changeState: () {
                          setState(() {
                            isPayButtonPressed = !isPayButtonPressed;
                          });
                        },
                        courseDescription: widget.map!['description'],
                        courseName: widget.map!['name'],
                        isPayButtonPressed: isPayButtonPressed,
                        NoCouponApplied: NoCouponApplied,
                        scrollController: _scrollController,
                        updateCourseIdToCouponDetails: () {
                          void addCourseId() {
                            setState(() {
                              id = widget.map!['id'];
                            });
                          }
                        
                          addCourseId();
                          print(NoCouponApplied);
                        },
                        outStandingAmountString: (double.parse(NoCouponApplied
                                    ? widget.map!['Amount_Payablepay']
                                    : finalAmountToPay) -
                                1000)
                            .toStringAsFixed(2),
                        courseId: widget.map!['id'],
                        couponCodeText: couponCodeController.text,
                        isItComboCourse: widget.isItComboCourse,
                        whichCouponCode: couponCodeController.text,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Positioned(
        //     top: 282.0000305175781,
        //     left: 168.00001525878906,
        //     child: Container(
        //       width: 194,
        //       child: Text(
        //         widget.map!['description'],
        //         textAlign: TextAlign.left,
        //         textScaleFactor: min(horizontalScale, verticalScale),
        //         style: TextStyle(
        //           color: Color.fromRGBO(58, 57, 57, 1),
        //           fontFamily: 'Poppins',
        //           fontSize: 10,
        //           fontWeight: FontWeight.normal,
        //         ),
        //       ),
        //     )),
        // Positioned(
        //   top: 331.0000305175781,
        //   left: 168.00001525878906,
        //   child: Text(
        //     'English  ||  ${widget.map!['videosCount']} Videos',
        //     textAlign: TextAlign.left,
        //     textScaleFactor: min(horizontalScale, verticalScale),
        //     style: TextStyle(
        //         color: Color.fromRGBO(88, 88, 88, 1),
        //         fontFamily: 'Poppins',
        //         fontSize: 12,
        //         letterSpacing:
        //             0 /*percentages not used in flutter. defaulting to zero*/,
        //         fontWeight: FontWeight.normal,
        //         height: 1),
        //   ),
        // ),
        // Positioned(
        //   top: 243.00001525878906,
        //   left: 30.000001907348633,
        //   child: ClipRRect(
        //     child: Container(
        //       width: 126.99999237060547,
        //       height: 109.99999237060547,
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(20),
        //         child: Image.network(widget.map!['image_url']),
        //       ),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   top: 325,
        //   left: 295,
        //   child: Text(
        //     widget.map!['Course Price'],
        //     textScaleFactor: min(horizontalScale, verticalScale),
        //     textAlign: TextAlign.left,
        //     style: TextStyle(
        //         color: Color.fromRGBO(155, 117, 237, 1),
        //         fontFamily: 'Poppins',
        //         fontSize: 18,
        //         letterSpacing:
        //             0 /*percentages not used in flutter. defaulting to zero*/,
        //         fontWeight: FontWeight.bold,
        //         height: 1),
        //   ),
        // ),
        // Positioned(
        //   top: 254.00001525878906,
        //   left: 168.00001525878906,
        //   child: Container(
        //     width: 194.00003051757812,
        //     height: 24.000003814697266,
        //     child: Positioned(
        //       top: 0,
        //       left: 0,
        //       child: Text(
        //         widget.map!['name'],
        //         textAlign: TextAlign.left,
        //         style: TextStyle(
        //             color: Color.fromRGBO(0, 0, 0, 1),
        //             fontFamily: 'Poppins',
        //             fontSize: 16,
        //             letterSpacing:
        //                 0 /*percentages not used in flutter. defaulting to zero*/,
        //             fontWeight: FontWeight.normal,
        //             height: 1),
        //       ),
        //     ),
        //   ),
        // ),
            ],
          )
        // body: Container(
        //   child: Column(children: [
        //     Container(
        //       child: Text(
        //         "PRICE DETAILS",
        //         style: TextStyle(
        //           fontFamily: 'Bold',
        //           fontSize: 18,
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 25,
        //     ),
        //     Align(
        //       alignment: Alignment.topLeft,
        //       child: Text(
        //         'Coupon code',
        //         style: TextStyle(fontFamily: 'Medium'),
        //       ),
        //     ),
        //     TextField(
        //       enabled: NoCouponApplied ? true : false,
        //       controller: couponCodeController,
        //       style: TextStyle(
        //         fontSize: 16,
        //         letterSpacing: 1.2,
        //         fontFamily: 'Medium',
        //       ),
        //       decoration: InputDecoration(
        //         suffixIcon: TextButton(
        //           child: Text(
        //             'Apply',
        //             style: TextStyle(
        //               color: Color(0xFFaefb2a),
        //               fontFamily: 'Medium',
        //               fontSize: 18,
        //             ),
        //           ),
        //           onPressed: () {
        //             setState(() {
        //               NoCouponApplied = whetherCouponApplied(
        //                 couponCodeText: couponCodeController.text,
        //               );
        //               couponAppliedResponse = whenCouponApplied(
        //                 couponCodeText: couponCodeController.text,
        //               );
        //               finalamountToDisplay = amountToDisplayAfterCCA(
        //                 amountPayable: widget.map!['Amount Payable'],
        //                 couponCodeText: couponCodeController.text,
        //               );
        //               finalAmountToPay = amountToPayAfterCCA(
        //                 couponCodeText: couponCodeController.text,
        //                 amountPayable: widget.map!['Amount Payable'],
        //               );
        //               discountedPrice = discountAfterCCA(
        //                   couponCodeText: couponCodeController.text,
        //                   amountPayable: widget.map!['Amount Payable']);
        //             });
        //             print('Button working');
        //           },
        //         ),
        //         fillColor: Colors.grey.shade100,
        //         filled: true,
        //         suffixIconConstraints:
        //             BoxConstraints(maxHeight: 50, minWidth: 100),
        //         // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
        //         enabledBorder: InputBorder.none,
        //         focusedBorder: InputBorder.none,
        //         disabledBorder: InputBorder.none,
        //       ),
        //     ),
        //     Align(
        //       alignment: Alignment.bottomLeft,
        //       child: Text(
        //         couponAppliedResponse,
        //         style: TextStyle(
        //           color: Colors.deepOrange,
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 15,
        //     ),
        //     Padding(
        //       padding:
        //           const EdgeInsets.only(top: 20.0, bottom: 10, right: 18),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             "Course Price",
        //             style: TextStyle(
        //               fontFamily: 'Medium',
        //               fontSize: 18,
        //             ),
        //           ),
        //           Text(
        //             widget.map!["Course Price"],
        //             style: TextStyle(
        //               fontFamily: 'Medium',
        //               fontSize: 15,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Padding(
        //       padding:
        //           const EdgeInsets.only(top: 5.0, bottom: 10, right: 18),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             "Discount",
        //             style: TextStyle(
        //               fontFamily: 'Medium',
        //               fontSize: 18,
        //             ),
        //           ),
        //           Text(
        //             NoCouponApplied
        //                 ? '₹${widget.map!["Discount"]} /-'
        //                 : discountedPrice,
        //             style: TextStyle(
        //               fontFamily: 'Medium',
        //               fontSize: 15,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Divider(
        //       height: 20,
        //       thickness: 1,
        //       indent: 0,
        //       endIndent: 0,
        //       color: Colors.black.withOpacity(0.5),
        //     ),
        //     Padding(
        //       padding:
        //           const EdgeInsets.only(top: 5.0, bottom: 10, right: 18),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           const Text(
        //             "Amount Payable",
        //             style: TextStyle(
        //               fontFamily: 'Medium',
        //               fontSize: 15,
        //             ),
        //           ),
        //           Container(
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(30),
        //                 color: Colors.grey.shade300),
        //             child: Center(
        //               child: Padding(
        //                 padding: const EdgeInsets.all(14.0),
        //                 child: Text(
        //                   NoCouponApplied
        //                       ? '₹${widget.map!["Amount Payable"]} /-'
        //                       : finalamountToDisplay,
        //                   style: TextStyle(
        //                     fontFamily: 'Medium',
        //                     fontSize: 10,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     SizedBox(
        //       height: 60,
        //     ),
        //     // map['demo'] == true
        //     //     ? InkWell(
        //     //         onTap: () {
        //     //           Navigator.push(
        //     //             context,
        //     //             PageTransition(
        //     //                 duration: Duration(
        //     //                     milliseconds: 400),
        //     //                 curve: Curves.bounceInOut,
        //     //                 type: PageTransitionType
        //     //                     .rightToLeft,
        //     //                 child: DemoCourse()),
        //     //           );
        //     //         },
        //     //         child: Container(
        //     //           //try demo button
        //     //           height: height * .06,
        //     //           width: width * .85,
        //     //           color: Colors.transparent,
        //     //           child: Container(
        //     //               decoration: BoxDecoration(
        //     //                   gradient: gradient,
        //     //                   borderRadius:
        //     //                       BorderRadius.all(
        //     //                           Radius.circular(
        //     //                               50.0))),
        //     //               child: const Center(
        //     //                 child: Text(
        //     //                   "Try Demo",
        //     //                   style: TextStyle(
        //     //                       fontFamily: 'Bold',
        //     //                       fontSize: 15,
        //     //                       fontWeight:
        //     //                           FontWeight.bold),
        //     //                   textAlign:
        //     //                       TextAlign.center,
        //     //                 ),
        //     //               )),
        //     //         ),
        //     //       )
        //     //     : Container(),
        //     SizedBox(
        //       height: 20,
        //     ),
        //     PaymentButton(
        //       amountString: (double.parse(NoCouponApplied
        //                   ? widget.map!['Amount_Payablepay']
        //                   : finalAmountToPay) *
        //               100)
        //           .toString(),
        //       buttonText: "Buy Now for ${widget.map!['Course Price']}",
        //       buttonTextForCode: "Buy Now for $finalamountToDisplay",
        //       changeState: () {
        //         setState(() {
        //           isPayButtonPressed = !isPayButtonPressed;
        //         });
        //       },
        //       courseDescription: widget.map!['description'],
        //       courseName: widget.map!['name'],
        //       isPayButtonPressed: isPayButtonPressed,
        //       NoCouponApplied: NoCouponApplied,
        //       scrollController: _scrollController,
        //       updateCourseIdToCouponDetails: () {
        //         void addCourseId() {
        //           setState(() {
        //             id = widget.map!['id'];
        //           });
        //         }

        //         addCourseId();
        //         print(NoCouponApplied);
        //       },
        //       outStandingAmountString: (double.parse(NoCouponApplied
        //                   ? widget.map!['Amount_Payablepay']
        //                   : finalAmountToPay) -
        //               1000)
        //           .toStringAsFixed(2),
        //       courseId: widget.map!['id'],
        //       couponCodeText: couponCodeController.text,
        //       isItComboCourse: widget.isItComboCourse,
        //       whichCouponCode: couponCodeController.text,
        //     ),
        //     SizedBox(
        //       height: 20,
        //     ),
        //     Container(
        //       width: 200,
        //       child: Text(
        //         "* Amount payable is inclusive of taxes. TERMS & CONDITIONS APPLY",
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontFamily: 'Regular',
        //           fontSize: 12,
        //         ),
        //       ),
        //     ),
        //   ]),
        // ),
        );
  }
}

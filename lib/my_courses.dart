import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

class MyCourses extends StatefulWidget {
  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator MyCourses - FRAME

    return Container(
        width: 414,
        height: 896,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(39, 36, 36, 0.46000000834465027),
                offset: Offset(4, 4),
                blurRadius: 100)
          ],
          color: Color.fromRGBO(249, 249, 249, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
            top: -147.00001525878906,
            left: 2.384185791015625e-7,
            child: Container(
              width: 413.9999694824219,
              height: 413.9999694824219,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Color.fromRGBO(122, 98, 222, 1),
              ),
            ),
          ),
          Positioned(
            top: 137.00001525878906,
            left: 318.0000305175781,
            child: Container(
              width: 161.99998474121094,
              height: 161.99998474121094,
              decoration: BoxDecoration(
                color: Color.fromRGBO(126, 106, 228, 1),
                borderRadius: BorderRadius.all(
                    Radius.elliptical(161.99998474121094, 161.99998474121094)),
              ),
            ),
          ),
          Positioned(
            top: -105.00000762939453,
            left: -94.00000762939453,
            child: Container(
              width: 161.99998474121094,
              height: 161.99998474121094,
              decoration: BoxDecoration(
                color: Color.fromRGBO(126, 106, 228, 1),
                borderRadius: BorderRadius.all(
                    Radius.elliptical(161.99998474121094, 161.99998474121094)),
              ),
            ),
          ),
          Positioned(
            top: 49.000003814697266,
            left: 163.00001525878906,
            child: SvgPicture.asset('assets/images/ellipse6.svg',
                semanticsLabel: 'ellipse6'),
          ),
          Positioned(
            top: 94.13379669189453,
            left: 82.99073028564453,
            child: Transform.rotate(
              angle: 179.18606171065107 * (math.pi / 180),
              child: SvgPicture.asset('assets/images/vector2.svg',
                  semanticsLabel: 'vector2'),
            ),
          ),
          Positioned(
            top: 142.00001525878906,
            left: 102.00000762939453,
            child: Text(
              'My Courses',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ),
          Positioned(
              top: 498.00006103515625,
              left: 36.000003814697266,
              child: Text(
                'Popular Courses',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 227.00001525878906,
              left: 30.000001907348633,
              child: Container(
                  width: 221.00001525878906,
                  height: 227.00001525878906,
                  child: Stack(children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 220.99998474121094,
                        height: 226.99998474121094,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(
                                    29, 28, 30, 0.30000001192092896),
                                offset: Offset(2, 2),
                                blurRadius: 50)
                          ],
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 202.00001525878906,
                        left: 191.00001525878906,
                        child: Text(
                          '82%',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'Poppins',
                              fontSize: 6,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 185.00001525878906,
                        left: 17.000003814697266,
                        child: Text(
                          'English  ||  20 Videos',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'Poppins',
                              fontSize: 8,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 157.00001525878906,
                        left: 17.000003814697266,
                        child: Text(
                          'Learn Python from Scratch and get complete Hands-on Practical Learning Experience just in 2 Weeks.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(58, 57, 57, 1),
                              fontFamily: 'Poppins',
                              fontSize: 6,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 133.00001525878906,
                        left: 17.000003814697266,
                        child: Container(
                            width: 182.00001525878906,
                            height: 23.000001907348633,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    'Python for Data Science',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 209.00001525878906,
                        left: 17.000003814697266,
                        child: Divider(
                            color: Color.fromRGBO(227, 227, 227, 1),
                            thickness: 4)),
                    Positioned(
                        top: 209.00001525878906,
                        left: 17.000003814697266,
                        child: Divider(
                            color: Color.fromRGBO(117, 95, 211, 1),
                            thickness: 4)),
                    Positioned(
                        top: 17,
                        left: 17.000003814697266,
                        child: Container(
                            width: 186.99998474121094,
                            height: 108.99999237060547,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/Rectangle34.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                  ]))),
          Positioned(
            top: 227.00001525878906,
            left: 281.0000305175781,
            child: Container(
              width: 221.00001525878906,
              height: 227.00001525878906,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 220.99998474121094,
                      height: 226.99998474121094,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(
                                  29, 28, 30, 0.30000001192092896),
                              offset: Offset(2, 2),
                              blurRadius: 50)
                        ],
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 202.00001525878906,
                      left: 191.00001525878906,
                      child: Text(
                        '82%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color.fromRGBO(88, 88, 88, 1),
                            fontFamily: 'Poppins',
                            fontSize: 6,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 185.00001525878906,
                      left: 17.000003814697266,
                      child: Text(
                        'English  ||  20 Videos',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(88, 88, 88, 1),
                            fontFamily: 'Poppins',
                            fontSize: 8,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 157.00001525878906,
                      left: 17.000003814697266,
                      child: Text(
                        'Learn Python from Scratch and get complete Hands-on Practical Learning Experience just in 2 Weeks.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(58, 57, 57, 1),
                            fontFamily: 'Poppins',
                            fontSize: 6,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 133.00001525878906,
                      left: 17.000003814697266,
                      child: Container(
                          width: 182.00001525878906,
                          height: 23.000001907348633,
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Text(
                                  'Python for Data Science',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                          ]))),
                  Positioned(
                      top: 209.00001525878906,
                      left: 17.000003814697266,
                      child: Divider(
                          color: Color.fromRGBO(227, 227, 227, 1),
                          thickness: 4)),
                  Positioned(
                      top: 209.00001525878906,
                      left: 17.000003814697266,
                      child: Divider(
                          color: Color.fromRGBO(117, 95, 211, 1),
                          thickness: 4)),
                  Positioned(
                      top: 17,
                      left: 17.000003814697266,
                      child: Container(
                          width: 186.99998474121094,
                          height: 108.99999237060547,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/Rectangle34.png'),
                                fit: BoxFit.fitWidth),
                          ))),
                ],
              ),
            ),
          ),
          Positioned(
              top: 544.0000610351562,
              left: 30.000001907348633,
              child: Container(
                  width: 354,
                  height: 102.00000762939453,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 353.9999694824219,
                            height: 101.99999237060547,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        29, 28, 31, 0.30000001192092896),
                                    offset: Offset(2, 2),
                                    blurRadius: 47)
                              ],
                              color: Color.fromRGBO(233, 225, 252, 1),
                            ))),
                    Positioned(
                        top: 54,
                        left: 144.00001525878906,
                        child: Text(
                          'English  ||  20 Videos',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 37,
                        left: 193.00001525878906,
                        child: Text(
                          '5.0',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'Poppins',
                              fontSize: 6,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 125.99999237060547,
                            height: 101.99999237060547,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(0),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/Rectangle31.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                    Positioned(
                        top: 11,
                        left: 144.00001525878906,
                        child: Container(
                            width: 182.00001525878906,
                            height: 23.000001907348633,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    'Python for Data Science',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 72,
                        left: 273.0000305175781,
                        child: Container(
                            width: 70,
                            height: 19,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 69.99999237060547,
                                      height: 18.999998092651367,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                          bottomRight: Radius.circular(50),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(48, 209,
                                                  151, 0.44999998807907104),
                                              offset: Offset(0, 10),
                                              blurRadius: 25)
                                        ],
                                        color: Color.fromRGBO(48, 209, 151, 1),
                                      ))),
                              Positioned(
                                  top: 2,
                                  left: 9,
                                  child: Container(
                                      width: 52.00000762939453,
                                      height: 15.000001907348633,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Text(
                                              'Enroll now',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            )),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 75,
                        left: 143.00001525878906,
                        child: Container(
                            width: 34.000003814697266,
                            height: 14.000000953674316,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    '3599/-',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(155, 117, 237, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 9,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 71,
                        left: 183.00001525878906,
                        child: Container(
                            width: 41.000003814697266,
                            height: 25.000001907348633,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    '999/-',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(155, 117, 237, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ])))
                  ]))),
          Positioned(
              top: 669.0000610351562,
              left: 30.000001907348633,
              child: Container(
                  width: 354,
                  height: 102.00000762939453,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 353.9999694824219,
                            height: 101.99999237060547,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        29, 28, 31, 0.30000001192092896),
                                    offset: Offset(2, 2),
                                    blurRadius: 47)
                              ],
                              color: Color.fromRGBO(233, 225, 252, 1),
                            ))),
                    Positioned(
                        top: 54,
                        left: 144.00001525878906,
                        child: Text(
                          'English  ||  20 Videos',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 37,
                        left: 193.00001525878906,
                        child: Text(
                          '5.0',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'Poppins',
                              fontSize: 6,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 125.99999237060547,
                            height: 101.99999237060547,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(0),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/Rectangle31.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                    Positioned(
                        top: 11,
                        left: 144.00001525878906,
                        child: Container(
                            width: 182.00001525878906,
                            height: 23.000001907348633,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    'Python for Data Science',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 72,
                        left: 273.0000305175781,
                        child: Container(
                            width: 70,
                            height: 19,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 69.99999237060547,
                                      height: 18.999998092651367,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                          bottomRight: Radius.circular(50),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(48, 209,
                                                  151, 0.44999998807907104),
                                              offset: Offset(0, 10),
                                              blurRadius: 25)
                                        ],
                                        color: Color.fromRGBO(48, 209, 151, 1),
                                      ))),
                              Positioned(
                                  top: 2,
                                  left: 9,
                                  child: Container(
                                      width: 52.00000762939453,
                                      height: 15.000001907348633,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Text(
                                              'Enroll now',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            )),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 75,
                        left: 143.00001525878906,
                        child: Container(
                            width: 34.000003814697266,
                            height: 14.000000953674316,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    '3599/-',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(155, 117, 237, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 9,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 71,
                        left: 183.00001525878906,
                        child: Container(
                            width: 41.000003814697266,
                            height: 25.000001907348633,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    '999/-',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(155, 117, 237, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                  ]))),
          Positioned(
              top: 794.0000610351562,
              left: 30.000001907348633,
              child: Container(
                  width: 354,
                  height: 102.00000762939453,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 353.9999694824219,
                            height: 101.99999237060547,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        29, 28, 31, 0.30000001192092896),
                                    offset: Offset(2, 2),
                                    blurRadius: 47)
                              ],
                              color: Color.fromRGBO(233, 225, 252, 1),
                            ))),
                    Positioned(
                        top: 54,
                        left: 144.00001525878906,
                        child: Text(
                          'English  ||  20 Videos',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 37,
                        left: 193.00001525878906,
                        child: Text(
                          '5.0',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'Poppins',
                              fontSize: 6,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 125.99999237060547,
                            height: 101.99999237060547,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(0),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/Rectangle31.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                    Positioned(
                        top: 11,
                        left: 144.00001525878906,
                        child: Container(
                            width: 182.00001525878906,
                            height: 23.000001907348633,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    'Python for Data Science',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 72,
                        left: 273.0000305175781,
                        child: Container(
                            width: 70,
                            height: 19,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 69.99999237060547,
                                      height: 18.999998092651367,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                          bottomRight: Radius.circular(50),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(48, 209,
                                                  151, 0.44999998807907104),
                                              offset: Offset(0, 10),
                                              blurRadius: 25)
                                        ],
                                        color: Color.fromRGBO(48, 209, 151, 1),
                                      ))),
                              Positioned(
                                  top: 2,
                                  left: 9,
                                  child: Container(
                                      width: 52.00000762939453,
                                      height: 15.000001907348633,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Text(
                                              'Enroll now',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            )),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 75,
                        left: 143.00001525878906,
                        child: Container(
                            width: 34.000003814697266,
                            height: 14.000000953674316,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    '3599/-',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(155, 117, 237, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 9,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 71,
                        left: 183.00001525878906,
                        child: Container(
                            width: 41.000003814697266,
                            height: 25.000001907348633,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    '999/-',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(155, 117, 237, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                  ]))),
        ]));
  }
}

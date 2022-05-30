import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

Row Star() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(padding: EdgeInsets.fromLTRB(14, 0, 0, 0)),
      Icon(
        Icons.star,
        color: Colors.yellow,
      ),
      Icon(
        Icons.star,
        color: Colors.yellow,
      ),
      Icon(
        Icons.star,
        color: Colors.yellow,
      ),
      Icon(
        Icons.star,
        color: Colors.yellow,
      ),
      Icon(
        Icons.star_half,
        color: Colors.yellow,
      ),
    ],
  );
}

Padding pad(IconData Icn, String T1) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icn,
          color: Color(0xFF7860DC),
        ),
        SizedBox(
          width: 13,
        ),
        Text(
          '$T1',
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Colors.black,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

Column includes() {
  return Column(
    children: [
      Text(
        'COURSE  FEATURES',
        style: TextStyle(
          decoration: TextDecoration.underline,
          overflow: TextOverflow.ellipsis,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 19,
          // fontFamily: 'bold'
        ),
      ),
      SizedBox(
        height: 15,
      ),
      pad(Icons.book, 'Guided Hands-On Assignment'),
      pad(Icons.assignment, 'Capstone End to End Project'),
      pad(Icons.badge, 'One Month Internship Opportunity'),
      pad(Icons.call, '1-1 Skype Live Course Mentorship'),
      pad(Icons.email, 'Job Referrals & Opening Mails'),
      pad(Icons.picture_as_pdf, 'Interview Q&As PDF Collection'),
      pad(Icons.picture_in_picture, 'Course Completion Certificates'),
    ],
  );
}

Row Buttoncombo(double width, String orgprice, String saleprice) {
  return Row(
    children: [
      Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
      Container(
        height: 35,
        width: width * .27,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade300),
        child: Center(
          child: Text(
            '₹$orgprice/-',
            style: TextStyle(
                fontFamily: 'Medium',
                color: Colors.black,
                fontSize: 12,
                decoration: TextDecoration.lineThrough),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Container(
        height: 35,
        width: width * .27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF57ebde), Color(0xFFaefb2a)],
          ),
        ),
        child: Center(
          child: Text(
            '₹$saleprice/-',
            style: TextStyle(
              fontFamily: 'Medium',
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      )
    ],
  );
}

Row Button1(
  double width,
  String orgprice,
) {
  return Row(
    children: [
      Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
      Container(
        height: 35,
        width: width * .27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF57ebde), Color(0xFFaefb2a)],
          ),
        ),
        child: Center(
          child: Text(
            '₹$orgprice/-',
            style: TextStyle(
              fontFamily: 'Medium',
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      )
    ],
  );
}

Image img(double width, double height, String link) {
  return Image(
      image: AssetImage(link),
      height: height * .25,
      width: width * 13,
      fit: BoxFit.fill);
}

Column colname(String text1, String text2) {
  return Column(children: [
    Container(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      alignment: Alignment.topLeft,
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Text(
        '$text1',
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'GideonRoman',
            fontWeight: FontWeight.bold,
            height: .97),
      ),
    ),
    Container(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      alignment: Alignment.topLeft,
      child: Text(
        '$text2',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    ),
  ]);
}

SafeArea safearea() {
  final image1 = imageFile('assets/image_1.jpeg');
  final image2 = imageFile('assets/image_2.jpeg');
  final image3 = imageFile('assets/image_3.jpeg');
  final image4 = imageFile('assets/image_4.jpeg');
  final image5 = imageFile('assets/image_5.jpeg');

  return
      // appBar: AppBar(),
      SafeArea(
          child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Text(
            'Recent Success Stories Of Our Learners',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          solidBorder(
            child: image1,
          ),
          const SizedBox(
            height: 15,
          ),
          solidBorder(
            child: image2,
          ),
          const SizedBox(
            height: 15,
          ),
          solidBorder(
            child: image3,
          ),
          const SizedBox(
            height: 15,
          ),
          solidBorder(
            child: image4,
          ),
          const SizedBox(
            height: 15,
          ),
          solidBorder(
            child: image5,
          ),
        ],
      ),
    ),
  ));
}

Widget solidBorder({required Widget child}) {
  return DottedBorder(
    strokeWidth: 8,
    padding: EdgeInsets.all(10),
    color: Colors.blue,
    borderType: BorderType.RRect,
    radius: const Radius.circular(10),
    dashPattern: const [1, 0],
    child: child,
  );
}

Widget imageFile(String url) {
  return Image.asset(
    url,
    width: 330,
    height: 330,
    fit: BoxFit.cover,
  );
}

SingleChildScrollView safearea1() {
  final LinearGradient _gradient = const LinearGradient(
    colors: [Colors.white, Colors.white],
  );
  print('i love you');
  return SingleChildScrollView(
    child: Column(
      children: [
        ShaderMask(
          shaderCallback: (Rect rect) {
            return _gradient.createShader(rect);
          },
          child: Container(
            alignment: Alignment.center,
            child: Text('Meet The Course Designer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                )

                // Theme.of(context).textTheme.headline4?.copyWith(
                //       fontWeight: FontWeight.bold,
                //       color: Color.fromARGB(255, 190, 230, 14),
                //       fontSize: 35,
                //     ),
                ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/image01.jpg'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        const Text(
          'Hello, I\'m Akash.'
          '\n I\'m A Data Scientist.',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: const Text.rich(TextSpan(
                text: 'I have transitioned my career from ',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  wordSpacing: 1,
                ),
                children: [
                  TextSpan(
                      text: 'Manual Tester to Data Scientist ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                    text:
                        'by upskilling myself on my own from various online resources and doing lots of ',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      wordSpacing: 5,
                    ),
                  ),
                  TextSpan(
                      text: 'Hands-on practice. ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'For internal switch I sent around ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        wordSpacing: 2,
                      )),
                  TextSpan(
                    text: '150 mails ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    ),
                  ),
                  TextSpan(
                      text: 'to different project managers, ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'interviewed in 20 ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'and got selected in ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        wordSpacing: 4,
                      )),
                  TextSpan(
                      text: '10 projects.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        wordSpacing: 5,
                      )),
                ])),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: const Text.rich(TextSpan(
                text:
                    'When it came to changing company I put papers with NO offers in hand. And in the notice period I struggled to get a job. First 2 months were very difficult but in the last month things started changing miraculously.',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  wordSpacing: 3,
                ))),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: const Text.rich(TextSpan(
              text: 'I attended ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                wordSpacing: 5,
              ),
              children: [
                TextSpan(
                    text: '40+ interviews ',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: 'in span of ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: '3 months ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: 'with the help of ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: 'Naukri and LinkedIn profile Optimizations ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: 'and got offer by ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      wordSpacing: 5,
                    )),
                TextSpan(
                    text: '8 companies. ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    )),
              ],
            )),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

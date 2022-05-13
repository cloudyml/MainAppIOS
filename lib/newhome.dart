import 'package:flutter/material.dart';

class PortraitMode extends StatelessWidget {
  const PortraitMode({Key? key}) : super(key: key);

  final LinearGradient _gradient = const LinearGradient(
    colors: [Color.fromARGB(255, 3, 133, 7), Color.fromARGB(255, 2, 47, 85)],
  );

  @override
  Widget build(BuildContext context) {
    // final _text = [
    //   'I have transitioned my career from Manual Tester to Data Scientist by upskilling myself on my own from various online resources and doing lots of Hands-on practice. For internal switch I sent around 150 mails to different project managers, interviewed in 20 and got selected in 10 projects.'
    // ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            ShaderMask(
              shaderCallback: (Rect rect) {
                return _gradient.createShader(rect);
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Meet The Course Designer',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 190, 230, 14),
                        fontSize: 35,
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Hello, I\'m Akash.'
              '\n I\'m A Data Scientist.',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 15, 50, 80)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Text.rich(TextSpan(
                  text: 'I have transitioned my career from ',
                  style: TextStyle(
                    fontSize: 17,
                    //color: Color.fromARGB(255, 15, 50, 80),
                    wordSpacing: 1,
                  ),
                  children: [
                    TextSpan(
                        text: 'Manual Tester to Data Scientist ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          wordSpacing: 5,
                        )),
                    TextSpan(
                      text:
                          'by upskilling myself on my own from various online resources and doing lots of ',
                      style: TextStyle(
                        fontSize: 17,
                        wordSpacing: 5,
                      ),
                    ),
                    TextSpan(
                        text: 'Hands-on practice. ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 5,
                        )),
                    TextSpan(
                        text: 'For internal switch I sent around ',
                        style: TextStyle(
                          fontSize: 17,
                          wordSpacing: 2,
                        )),
                    TextSpan(
                      text: '150 mails ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 5,
                      ),
                    ),
                    TextSpan(
                        text: 'to different project managers, ',
                        style: TextStyle(
                          fontSize: 17,
                          wordSpacing: 5,
                        )),
                    TextSpan(
                        text: 'interviewed in 20 ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 5,
                        )),
                    TextSpan(
                        text: 'and got selected in ',
                        style: TextStyle(
                          fontSize: 17,
                          wordSpacing: 4,
                        )),
                    TextSpan(
                        text: '10 projects.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 5,
                        )),
                  ])),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Text.rich(TextSpan(
                  text:
                      'When it came to changing company I put papers with NO offers in hand. And in the notice period I struggled to get a job. First 2 months were very difficult but in the last month things started changing miraculously.',
                  style: TextStyle(
                    fontSize: 17,
                    wordSpacing: 3,
                  ))),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Text.rich(TextSpan(
                text: 'I attended ',
                style: TextStyle(
                  fontSize: 17,
                  wordSpacing: 5,
                ),
                children: [
                  TextSpan(
                      text: '40+ interviews ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'in span of ',
                      style: TextStyle(
                        fontSize: 17,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: '3 months ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'with the help of ',
                      style: TextStyle(
                        fontSize: 17,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'Naukri and LinkedIn profile Optimizations ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: 'and got offer by ',
                      style: TextStyle(
                        fontSize: 17,
                        wordSpacing: 5,
                      )),
                  TextSpan(
                      text: '8 companies. ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 5,
                      )),
                ],
              )),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text.rich(WidgetSpan(
                        child: Image(image: AssetImage('asset/image.jpeg')))),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          shadowColor: Colors.orange,
                          side: const BorderSide(color: Colors.blue),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15)))),
                      onPressed: () {},
                      child: const Text(
                        'Know Why I Build This Course',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
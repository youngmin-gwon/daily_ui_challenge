import 'package:flutter/material.dart';

class ParallaxScrollScreen extends StatefulWidget {
  const ParallaxScrollScreen({Key? key}) : super(key: key);

  @override
  _ParallaxScrollScreenState createState() => _ParallaxScrollScreenState();
}

class _ParallaxScrollScreenState extends State<ParallaxScrollScreen> {
  double topOne = 0;
  double topTwo = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener(
        onNotification: (v) {
          if (v is ScrollUpdateNotification) {
            // only if scroll update notification is triggered
            setState(() {
              topOne = topOne - v.scrollDelta! / 3;
              topTwo = topTwo - v.scrollDelta! / 1;
            });
          }
          return true;
        },
        child: Stack(
          children: [
            Positioned(
              top: topOne,
              left: 0,
              child: Container(
                height: 100,
                width: 100,
                color: Colors.red,
              ),
            ),
            Positioned(
              top: topTwo,
              left: 150,
              child: Container(
                height: 100,
                width: 100,
                color: Colors.green,
              ),
            ),
            ListView(
              children: [
                Container(
                  height: 600,
                  color: Colors.transparent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ParallaxScrollScreen extends StatefulWidget {
  const ParallaxScrollScreen({Key? key}) : super(key: key);

  @override
  _ParallaxScrollScreenState createState() => _ParallaxScrollScreenState();
}

class _ParallaxScrollScreenState extends State<ParallaxScrollScreen> {
  double rateZero = 0;
  double rateOne = 0;
  double rateTwo = 0;
  double rateThree = 0;
  double rateFour = 0;
  double rateFive = 0;
  double rateSix = 0;
  double rateSeven = 0;
  double rateEight = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: NotificationListener(
        onNotification: (v) {
          if (v is ScrollUpdateNotification) {
            // only if scroll update notification is triggered
            setState(() {
              rateEight -= v.scrollDelta! / 1;
              rateSeven -= v.scrollDelta! / 1.5;
              rateSix -= v.scrollDelta! / 2;
              rateFive -= v.scrollDelta! / 2.5;
              rateFour -= v.scrollDelta! / 3;
              rateThree -= v.scrollDelta! / 3.5;
              rateTwo -= v.scrollDelta! / 4;
              rateOne -= v.scrollDelta! / 4.5;
              rateZero -= v.scrollDelta! / 5;
            });
          }
          return true;
        },
        child: Stack(
          children: [
            ParallaxWidget(top: rateZero, asset: "parallax0"),
            ParallaxWidget(top: rateOne, asset: "parallax1"),
            ParallaxWidget(top: rateTwo, asset: "parallax2"),
            ParallaxWidget(top: rateThree, asset: "parallax3"),
            ParallaxWidget(top: rateFour, asset: "parallax4"),
            ParallaxWidget(top: rateFive, asset: "parallax5"),
            ParallaxWidget(top: rateSix, asset: "parallax6"),
            ParallaxWidget(top: rateSeven, asset: "parallax7"),
            ParallaxWidget(top: rateEight, asset: "parallax8"),
            ListView(
              children: [
                Container(
                  height: 480,
                  color: Colors.transparent,
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(color: Color(0xFF210002)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SizedBox(height: 350),
                      Text(
                        "Parallax",
                        style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 1.8,
                            color: Color(0xFFFFAF00)),
                      ),
                      Text(
                        "Effect",
                        style: TextStyle(
                            fontSize: 51,
                            letterSpacing: 1.8,
                            color: Color(0xFFFFAF00)),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 240,
                        child: Divider(
                          height: 1,
                          color: Color(0xFFFFAF00),
                        ),
                      ),
                      SizedBox(height: 350),
                      PoweredByFlutter(),
                      SizedBox(height: 35),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ParallaxWidget extends StatelessWidget {
  const ParallaxWidget({
    Key? key,
    required this.top,
    required this.asset,
  }) : super(key: key);

  final double top;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: top,
      child: SizedBox(
        height: 550,
        child: Image.asset(
          "assets/images/$asset.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PoweredByFlutter extends StatelessWidget {
  const PoweredByFlutter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          "Powered By",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        SizedBox(width: 12),
        FlutterLogo(size: 20),
      ],
    );
  }
}

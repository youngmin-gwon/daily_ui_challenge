import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Screen20211213 extends StatefulWidget {
  const Screen20211213({Key? key}) : super(key: key);

  @override
  State<Screen20211213> createState() => _Screen20211213State();
}

class _Screen20211213State extends State<Screen20211213>
    with SingleTickerProviderStateMixin {
  bool _isOn = false;

  final _onLightSvg = "assets/svg/light_on.svg";
  final _offLightSvg = "assets/svg/light_off.svg";

  late String _lightSvg;

  @override
  void initState() {
    super.initState();
    _lightSvg = _offLightSvg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2729),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
          ),
        ),
      ),
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const SizedBox.expand(),
          Center(
            child: Transform.rotate(
              angle: math.pi,
              child: Transform.translate(
                offset: const Offset(0, 90),
                child: SvgPicture.asset(
                  _lightSvg,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2,
            bottom: MediaQuery.of(context).size.height / 4,
            child: FractionalTranslation(
              translation: const Offset(-0.5, 0.5),
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    _isOn = true;
                    _lightSvg = _onLightSvg;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    _isOn = false;
                    _lightSvg = _offLightSvg;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleWidget(
                      radius: 20,
                      width: 2,
                      color: Colors.white,
                      isOn: _isOn,
                    ),
                    CircleWidget(
                      radius: 30,
                      width: 3,
                      color: Colors.yellow,
                      isOn: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    Key? key,
    required this.radius,
    required this.width,
    required this.color,
    required this.isOn,
  }) : super(key: key);

  final double radius;
  final double width;
  final Color color;
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isOn ? color : null,
        border: Border.all(
          color: color,
          width: width,
        ),
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        height: radius * 2,
        width: radius * 2,
      ),
    );
  }
}

class Circle extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;
  final double radius;
  final Offset center;
  final bool isFilled;

  const Circle(
      {required this.strokeWidth,
      required this.strokeColor,
      required this.radius,
      this.center = const Offset(0.5, -0.5),
      required this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = strokeColor
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke;

    canvas.drawCircle(center, radius, strokePaint);
  }

  @override
  bool shouldRepaint(covariant Circle oldDelegate) {
    return oldDelegate.isFilled != isFilled;
  }
}

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
  late AnimationController _controller;

  bool _isOn = false;

  final _onLightSvg = "assets/svg/light_on.svg";
  final _offLightSvg = "assets/svg/light_off.svg";

  final double _defaultRadius = 45;
  double _radius = 45;
  final double _defaultWidth = 3;
  double _width = 3;
  final double _defaultOpacity = 1;
  double _opacity = 1;

  late String _lightSvg;

  @override
  void initState() {
    super.initState();
    _lightSvg = _offLightSvg;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _controller.addListener(() {
      setState(() {
        _radius = _defaultRadius + _controller.value * 500;
        _width = _defaultWidth + _controller.value * 3;
        _opacity = _defaultOpacity - _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2729),
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 50,
                left: 30,
              ),
              child: Icon(
                Icons.menu,
                size: 30,
                color: Colors.white,
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
                    _controller.repeat();
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    _isOn = false;
                    _lightSvg = _offLightSvg;
                    _controller.reset();
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleWidget(
                      radius: 30,
                      width: 2,
                      color: Colors.white,
                      isOn: _isOn,
                    ),
                    CircleWidget(
                      radius: _defaultRadius,
                      width: 4,
                      color: Colors.yellow,
                    ),
                    AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 0),
                      child: CircleWidget(
                        radius: _radius,
                        width: _width,
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: BulbLine(
              anchorPoint: Offset(MediaQuery.of(context).size.width / 2, 0.0),
              bulbPoint: Offset(MediaQuery.of(context).size.width / 2, 170.0),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0, 150),
              child: Column(
                children: [
                  Transform.rotate(
                    angle: math.pi,
                    child: SvgPicture.asset(
                      _lightSvg,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Bedroom - Light",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ],
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
    this.isOn = false,
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

class BulbLine extends CustomPainter {
  final Offset anchorPoint;
  final Offset bulbPoint;

  final linePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  BulbLine({
    required this.anchorPoint,
    required this.bulbPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(anchorPoint, bulbPoint, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

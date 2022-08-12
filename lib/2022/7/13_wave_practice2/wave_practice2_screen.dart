import 'dart:math' as math;
import 'package:flutter/material.dart';

class WavePractice2Screen extends StatefulWidget {
  const WavePractice2Screen({Key? key}) : super(key: key);

  @override
  State<WavePractice2Screen> createState() => _WavePractice2ScreenState();
}

class _WavePractice2ScreenState extends State<WavePractice2Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double radius = 200;

  Offset pickPoint = const Offset(0, 100);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    setState(() {
      pickPoint = details.localFocalPoint;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.localFocalPoint.dx >= 0 &&
        details.localFocalPoint.dx <= radius * 2) {
      setState(() {
        pickPoint = details.localFocalPoint;
      });
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF27A5C0),
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
              child: ClipPath(
            clipper: HoleClipper(),
            child: Container(
              width: radius * 2,
              height: radius * 2,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: _onScaleEnd,
                child: SizedBox(
                  width: radius,
                  height: radius,
                  child: CustomPaint(
                    size: Size(radius, radius),
                    painter: Wave2Painter(
                      pickPoint: pickPoint,
                    ),
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class Wave2Painter extends CustomPainter {
  final Offset pickPoint;

  final pointPainter = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill
    ..strokeWidth = 2;

  final linePainter = Paint()
    ..color = Colors.indigo
    ..style = PaintingStyle.fill;

  Wave2Painter({
    required this.pickPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // _drawPickPoint(canvas, size);
    _drawWaveLine(canvas, size);
  }

  void _drawPickPoint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromCenter(center: pickPoint, width: 4, height: 20),
      pointPainter,
    );
  }

  void _drawWaveLine(Canvas canvas, Size size) {
    double bendWidth = 80;
    double bezierWidth = 80;
    double waveHeight = 80;

    double centerPoint = pickPoint.dx;

    double startOfBend = pickPoint.dx - bendWidth / 2;
    double startOfBezier = startOfBend - bezierWidth;
    double endOfBend = pickPoint.dx + bendWidth / 2;
    double endOfBezier = endOfBend + bezierWidth;

    double leftControl1 = startOfBend;
    double leftControl2 = startOfBend;
    double rightControl1 = endOfBend;
    double rightControl2 = endOfBend;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height / 2);
    path.lineTo(startOfBezier, size.height / 2);
    path.cubicTo(
      leftControl1,
      size.height / 2,
      leftControl2,
      size.height / 2 - waveHeight,
      centerPoint,
      size.height / 2 - waveHeight,
    );
    path.cubicTo(
      rightControl1,
      size.height / 2 - waveHeight,
      rightControl2,
      size.height / 2,
      endOfBezier,
      size.height / 2,
    );
    path.lineTo(size.width, size.height / 2);

    path.lineTo(size.width, size.height);

    canvas.drawPath(path, linePainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class HoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.addArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      0,
      2 * math.pi,
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

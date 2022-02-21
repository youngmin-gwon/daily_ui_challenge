import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class GlowingScreen extends StatelessWidget {
  const GlowingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.grey),
          elevation: 0,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.circle_outlined,
                        color: Colors.amber,
                      ),
                      title: Text("iOS SDK"),
                      trailing: Icon(Icons.compare_arrows),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.circle_outlined,
                        color: Colors.amber,
                      ),
                      title: Text("Android SDK"),
                      trailing: Icon(Icons.compare_arrows),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: const [
                            Icon(
                              Icons.add,
                              size: 30,
                            ),
                            Text(
                              "Education",
                            )
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(
                              Icons.mail,
                              size: 30,
                            ),
                            Text("Traning")
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: GlowingWidget(),
              ),
            )
          ],
        ));
  }
}

class GlowingWidget extends StatefulWidget {
  const GlowingWidget({Key? key}) : super(key: key);

  @override
  State<GlowingWidget> createState() => _GlowingWidgetState();
}

class _GlowingWidgetState extends State<GlowingWidget>
    with SingleTickerProviderStateMixin {
  final _logoBaseColor = const Color(0xFFF0F0F0);

  final _logoHighlightColor = const Color(0xFFFFFFFF);

  final _logoShadowColor = const Color(0xFFE0E0E0);

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    return Transform.translate(
      offset: const Offset(5, 0),
      child: SizedBox(
        height: 75,
        child: Stack(children: [
          Transform.translate(
            offset: const Offset(-1, -1),
            child: Image.asset(
              "assets/images/Coffee.png",
              color: _logoShadowColor,
            ),
          ),
          Transform.translate(
            offset: const Offset(2, 2),
            child: Image.asset(
              "assets/images/Coffee.png",
              color: _logoHighlightColor,
            ),
          ),
          Image.asset(
            "assets/images/Coffee.png",
            color: _logoBaseColor,
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: ProtectPatternPainter(),
          ),
          Center(
            child: _buildLogo(),
          )
        ],
      ),
    );
  }
}

class ProtectPatternPainter extends CustomPainter {
  static const double centerRingToDotsGap = 20;
  static const int dotsPerRing = 64;
  static const double startDotRadius = 2.5;
  static const double endDotRadius = 5;
  static const double startDotOpacity = 0.08;
  static const double endDotOpacity = 0.005;
  static const double ringGap = 7;
  static final Paint dotPaint = Paint()..color = Colors.black;
  static final Paint shadowPaint = Paint()
    ..color = Colors.black.withOpacity(0.4)
    ..imageFilter = ImageFilter.blur(
      sigmaX: 4,
      sigmaY: 4,
      tileMode: TileMode.decal,
    );
  // glow effect
  static const primaryGlowThickness = 6;
  static const secondaryGlowThickness = 7;
  late Paint primaryGlowPaint;
  late Paint secondaryGlowPaint;

  ProtectPatternPainter() {
    primaryGlowPaint = Paint()
      ..color = const Color(0xFF83DB0F)
      ..imageFilter =
          ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.decal);
    secondaryGlowPaint = Paint()
      ..color = const Color(0xFFACFF26)
      ..imageFilter =
          ImageFilter.blur(sigmaY: 15, sigmaX: 15, tileMode: TileMode.decal);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset ringCenter = size.center(Offset.zero);
    final double centerCircleRadius = size.width / 6;
    final double firstRingRadius = centerCircleRadius + centerRingToDotsGap;
    final double finalRingRadius = size.width / 2;
    final int ringCount =
        ((finalRingRadius - firstRingRadius) / ringGap).floor();

    _drawShadowAndGlow(
      canvas: canvas,
      drawableArea: size,
      center: ringCenter,
      centerCircleRadius: centerCircleRadius,
    );

    const halfDotRotation = ((2 * pi) / dotsPerRing) / 2;
    for (int i = 0; i < ringCount; i++) {
      final ringRadius =
          centerCircleRadius + centerRingToDotsGap + (ringGap * i);
      final double ringPercent = i / ringCount;
      _drawDotRing(
        canvas: canvas,
        ringCenter: ringCenter,
        dotCount: dotsPerRing,
        ringRadius: ringRadius,
        dotRadius: lerpDouble(
          startDotRadius,
          endDotRadius,
          ringPercent,
        )!,
        opacity: lerpDouble(
          startDotOpacity,
          endDotOpacity,
          ringPercent,
        )!,
        ringRotation: i % 2 == 0 ? halfDotRotation : 0,
      );
    }
  }

  Offset _rotateVector(Offset vector, double angleInRadians) {
    return Offset(
      (cos(angleInRadians) * vector.dx) - (sin(angleInRadians) * vector.dy),
      (sin(angleInRadians) * vector.dx) - (cos(angleInRadians) * vector.dy),
    );
  }

  void _drawShadowAndGlow({
    required Canvas canvas,
    required Size drawableArea,
    required Offset center,
    required double centerCircleRadius,
  }) {
    Path maskPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, drawableArea.width, drawableArea.height))
      ..addOval(Rect.fromCircle(center: center, radius: centerCircleRadius))
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(maskPath);
    canvas.drawCircle(
      center,
      centerCircleRadius + secondaryGlowThickness,
      secondaryGlowPaint,
    );
    canvas.drawCircle(
      center,
      centerCircleRadius + primaryGlowThickness,
      primaryGlowPaint,
    );
    canvas.drawCircle(
      center,
      centerCircleRadius,
      shadowPaint,
    );
  }

  void _drawDotRing({
    required Canvas canvas,
    required Offset ringCenter,
    required int dotCount,
    required double ringRadius,
    required double dotRadius,
    required double opacity,
    required double ringRotation,
  }) {
    Path dotCirclePath = Path();

    const double deltaAngle = 2 * pi / dotsPerRing;
    for (int i = 0; i < dotsPerRing; i++) {
      dotCirclePath.addOval(
        Rect.fromCircle(
          center: ringCenter +
              _rotateVector(
                  Offset(0, -ringRadius), deltaAngle * i + ringRotation),
          radius: dotRadius,
        ),
      );
    }

    dotPaint.color = dotPaint.color.withOpacity(opacity);
    canvas.drawPath(dotCirclePath, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class GlowingTestWidget extends StatelessWidget {
  const GlowingTestWidget({Key? key}) : super(key: key);
  final _logoBaseColor = const Color(0xFFF0F0F0);

  final _logoHighlightColor = const Color(0xFFFFFFFF);

  final _logoShadowColor = const Color(0xFFE0E0E0);

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: GlowingTestPainter(),
                    ),
                  ),
                  Center(child: _buildLogo())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GlowingTestPainter extends CustomPainter {
  final double centerRingToDotsGap = 20;
  final int dotsPerRing = 64;
  final double startDotRadius = 2.5;
  final double endDotRadius = 5;
  final double ringGap = 7;
  final double startDotOpacity = 0.08;
  final double endDotOpacity = 0.005;
  static final dotPaint = Paint();
  static final shadowPaint = Paint()
    ..color = Colors.grey.withOpacity(0.4)
    ..imageFilter = ImageFilter.blur(
      sigmaX: 4,
      sigmaY: 4,
      tileMode: TileMode.decal,
    );
  late Paint primaryGlowPaint;
  late Paint secondaryGlowPaint;
  final double primaryGlowThickness = 6;
  final double secondaryGlowThickness = 7;

  GlowingTestPainter() {
    primaryGlowPaint = Paint()
      ..color = Color(0xFF83DB0F)
      ..imageFilter =
          ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.decal);
    secondaryGlowPaint = Paint()
      ..color = Color(0xFFACFF26)
      ..imageFilter =
          ImageFilter.blur(sigmaY: 15, sigmaX: 15, tileMode: TileMode.decal);
  }
  @override
  void paint(Canvas canvas, Size size) {
    final Offset ringCenter = size.center(Offset.zero);
    final double centerCircleRadius = size.width / 6;
    final double deltaAngle = math.pi * 2 / dotsPerRing;

    final double firstRingRadius = centerCircleRadius + centerRingToDotsGap;
    final double finalRingRadius = size.width / 2;
    final int ringCount =
        ((finalRingRadius - firstRingRadius) / ringGap).floor();

    for (var i = 0; i < ringCount; i++) {
      final double ringRadius =
          centerCircleRadius + centerRingToDotsGap + (i * ringGap);
      final double halfDotRotation = (2 * math.pi / dotsPerRing) / 2;
      final double ringPercent = i / ringCount;
      _drawShadowAndGlow(
          canvas: canvas,
          drawableArea: size,
          center: ringCenter,
          centerCircleRadius: centerCircleRadius);

      _drawDotRing(
          canvas: canvas,
          ringCenter: ringCenter,
          dotCount: dotsPerRing,
          ringRadius: ringRadius,
          dotRadius: lerpDouble(startDotRadius, endDotRadius, ringPercent)!,
          angle: deltaAngle,
          opacity: lerpDouble(startDotOpacity, endDotOpacity, ringPercent)!,
          ringRotation: i % 2 == 0 ? halfDotRotation : 0);
    }
  }

  void _drawShadowAndGlow({
    required Canvas canvas,
    required Size drawableArea,
    required Offset center,
    required double centerCircleRadius,
  }) {
    Path maskPath = Path()
      ..addRect(Rect.fromLTWH(
        0,
        0,
        drawableArea.width,
        drawableArea.height,
      ))
      ..addOval(Rect.fromCircle(
        center: center,
        radius: centerCircleRadius,
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.clipPath(maskPath);

    canvas.drawCircle(center, centerCircleRadius + secondaryGlowThickness,
        secondaryGlowPaint);
    canvas.drawCircle(
			center, centerCircleRadius + primaryGlodf:-="-=:sfset
	clipboard+=unnamedplusfdf-="(ksdfjwlertkldsjafgp;sdufjwekjfjkkkjdf:-="-=:sfset
clipboard+=unnamedplusfdsdfa::-=f:-="sa="sd:-="=-:"sdfkjwerihjkk")Thickness, primaryGlowPaint);
    canvas.drawCircle(center, centerCircleRadius, shadowPaint);
  }

  void _drawDotRing({
    required Canvas canvas,
    required Offset ringCenter,
    required int dotCount,
    required double ringRadius,
    required double dotRadius,
    required double angle,
    required double opacity,
    required double ringRotation,
  }) {
    Path dotCirclePath = Path();

    for (var i = 0; i < dotCount; i++) {
      dotCirclePath.addOval(
        Rect.fromCircle(
          center: ringCenter +
              Offset(ringRadius * math.cos(ringRotation + (i * angle)),
                  -ringRadius * math.sin(ringRotation + (i * angle))),
          radius: dotRadius,
        ),
      );
    }
    dotPaint.color = dotPaint.color.withOpacity(opacity);
    canvas.drawPath(dotCirclePath, dotPaint);
  }

  @override
  bool shouldRepaint(GlowingTestPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(GlowingTestPainter oldDelegate) => false;
}

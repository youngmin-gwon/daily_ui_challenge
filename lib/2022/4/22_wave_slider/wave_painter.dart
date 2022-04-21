import 'dart:ui';

import 'package:daily_ui/2022/4/22_wave_slider/wave_slider.dart';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double sliderPosition;
  final double dragPercent;

  final double animationProgress;
  final SliderState sliderState;

  final Color color;

  double _previousSlidePosition = 0;

  late Paint fillPainter;
  late Paint wavePainter;

  WavePainter({
    required this.sliderPosition,
    required this.dragPercent,
    required this.color,
    required this.animationProgress,
    required this.sliderState,
  }) {
    fillPainter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    wavePainter = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintAnchors(canvas, size);
    switch (sliderState) {
      case SliderState.starting:
        _paintStartingWave(canvas, size);
        break;
      case SliderState.resting:
        _paintRestingWave(canvas, size);
        break;
      case SliderState.sliding:
        _paintSlidingWave(canvas, size);
        break;
      case SliderState.stopping:
        _paintStoppingWave(canvas, size);
        break;
    }
  }

  _paintStartingWave(Canvas canvas, Size size) {
    WaveCurveDefinition line = _calculateWaveLineDefinition(size);

    double waveHeight = lerpDouble(
      size.height,
      line.controlHeight,
      Curves.elasticOut.transform(animationProgress),
    )!;

    line.controlHeight = waveHeight;

    _paintWaveLine(canvas, size, line);
  }

  _paintRestingWave(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, wavePainter);
  }

  _paintSlidingWave(Canvas canvas, Size size) {
    final WaveCurveDefinition waveCurve = _calculateWaveLineDefinition(size);
    _paintWaveLine(canvas, size, waveCurve);
  }

  _paintStoppingWave(Canvas canvas, Size size) {
    WaveCurveDefinition line = _calculateWaveLineDefinition(size);

    double waveHeight = lerpDouble(
      line.controlHeight,
      size.height,
      Curves.elasticOut.transform(animationProgress),
    )!;

    line.controlHeight = waveHeight;

    _paintWaveLine(canvas, size, line);
  }

  void _paintAnchors(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, size.height), 5.0, fillPainter);
    canvas.drawCircle(Offset(size.width, size.height), 5.0, fillPainter);
  }

  WaveCurveDefinition _calculateWaveLineDefinition(Size size) {
    double minWaveHeight = size.height * 0.2;
    double maxWaveHeight = size.height * 0.8;

    double controlHeight =
        (size.height - minWaveHeight) - (maxWaveHeight * dragPercent);

    double bendWidth = 20 + 20 * dragPercent;
    double bezierWidth = 20 + 20 * dragPercent;

    double centerPoint = sliderPosition;
    centerPoint = (centerPoint > size.width) ? size.width : centerPoint;

    double startOfBend = centerPoint - bendWidth / 2;
    double startOfBezier = startOfBend - bezierWidth;
    double endOfBend = sliderPosition + bendWidth / 2;
    double endOfBezier = endOfBend + bezierWidth;

    startOfBend = (startOfBend <= 0.0) ? 0.0 : startOfBend;
    startOfBezier = (startOfBezier <= 0.0) ? 0.0 : startOfBezier;
    endOfBend = (endOfBend > size.width) ? size.width : endOfBend;
    endOfBezier = (endOfBezier > size.width) ? size.width : endOfBezier;

    double leftControlPoint1 = startOfBend;
    double leftControlPoint2 = startOfBend;
    double rightControlPoint1 = endOfBend;
    double rightControlPoint2 = endOfBend;

    // how bendable it would be
    double bendability = 25.0;
    double maxSlideDifference = 20.0;

    double slideDifference = (sliderPosition - _previousSlidePosition).abs();

    slideDifference = (slideDifference > maxSlideDifference)
        ? maxSlideDifference
        : slideDifference;

    double bend =
        lerpDouble(0.0, bendability, slideDifference / maxSlideDifference)!;

    bool moveLeft = sliderPosition < _previousSlidePosition;

    bend = moveLeft ? -bend : bend;

    leftControlPoint1 = leftControlPoint1 + bend;
    leftControlPoint2 = leftControlPoint2 - bend;
    rightControlPoint1 = rightControlPoint1 - bend;
    rightControlPoint2 = rightControlPoint2 + bend;

    centerPoint = centerPoint - bend;

    final waveCurve = WaveCurveDefinition(
      startOfBezier: startOfBezier,
      endOfBezier: endOfBezier,
      leftControlPoint1: leftControlPoint1,
      leftControlPoint2: leftControlPoint2,
      rightControlPoint1: rightControlPoint1,
      rightControlPoint2: rightControlPoint2,
      controlHeight: controlHeight,
      centerPoint: centerPoint,
    );

    return waveCurve;
  }

  void _paintWaveLine(Canvas canvas, Size size, WaveCurveDefinition waveCurve) {
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(waveCurve.startOfBezier, size.height);
    path.cubicTo(
      waveCurve.leftControlPoint1,
      size.height,
      waveCurve.leftControlPoint2,
      waveCurve.controlHeight,
      waveCurve.centerPoint,
      waveCurve.controlHeight,
    );

    path.cubicTo(
      waveCurve.rightControlPoint1,
      waveCurve.controlHeight,
      waveCurve.rightControlPoint2,
      size.height,
      waveCurve.endOfBezier,
      size.height,
    );

    path.lineTo(size.width, size.height);
    canvas.drawPath(path, wavePainter);
  }

  void _paintLine(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, wavePainter);
  }

  void _paintBlock(Canvas canvas, Size size) {
    Rect sliderRect =
        Offset(sliderPosition, size.height - 5.0) & const Size(3.0, 10.0);
    canvas.drawRect(sliderRect, fillPainter);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    _previousSlidePosition = oldDelegate.sliderPosition;
    return true;
  }
}

class WaveCurveDefinition {
  final double startOfBezier;
  final double endOfBezier;
  final double leftControlPoint1;
  final double leftControlPoint2;
  final double rightControlPoint1;
  final double rightControlPoint2;
  double controlHeight;
  final double centerPoint;

  WaveCurveDefinition({
    required this.startOfBezier,
    required this.endOfBezier,
    required this.leftControlPoint1,
    required this.leftControlPoint2,
    required this.rightControlPoint1,
    required this.rightControlPoint2,
    required this.controlHeight,
    required this.centerPoint,
  });
}

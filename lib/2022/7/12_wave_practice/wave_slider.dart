import 'dart:ui';

import 'package:flutter/material.dart';

class WaveSlider extends StatefulWidget {
  const WaveSlider({
    super.key,
    this.width = 350,
    this.height = 50,
    this.color = Colors.black,
  });

  final double width;
  final double height;
  final Color color;

  @override
  State<WaveSlider> createState() => _WaveSliderState();
}

class _WaveSliderState extends State<WaveSlider> {
  double _dragPosition = 0;
  double _dragPercentage = 0;

  void _onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.globalPosition);
    _updateDragPosition(offset);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.globalPosition);
    _updateDragPosition(offset);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {});
  }

  void _updateDragPosition(Offset offset) {
    double newPosition = 0;

    if (offset.dx <= 0) {
      newPosition = 0;
    } else if (offset.dx >= widget.width) {
      newPosition = widget.width;
    } else {
      newPosition = offset.dx;
    }

    setState(() {
      _dragPosition = newPosition;
      _dragPercentage = _dragPosition / widget.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: WavePainter(
            sliderPosition: _dragPosition,
            dragPercentage: _dragPercentage,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double sliderPosition;
  final double dragPercentage;
  final Color color;

  double _previousSliderPosition = 0;

  late final Paint fillPaint;
  late final Paint linePaint;

  WavePainter({
    required this.sliderPosition,
    required this.dragPercentage,
    required this.color,
  })  : fillPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        linePaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    _paintAnchor(canvas, size);
    // _paintLine(canvas, size);
    // _paintBlock(canvas, size);
    _paintWaveLine(canvas, size);
  }

  void _paintAnchor(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, size.height), 5, Paint()..color = color);
    canvas.drawCircle(Offset(size.width, size.height), 5, fillPaint);
  }

  void _paintLine(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, linePaint);
  }

  void _paintBlock(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(sliderPosition, size.height), width: 5, height: 10),
        fillPaint);
  }

  void _paintWaveLine(Canvas canvas, Size size) {
    WaveCurveDefinitions waveCurve = _calculateWaveLineDefinition();

    final path = Path();
    path.moveTo(0, size.height);
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

    canvas.drawPath(path, linePaint);
  }

  WaveCurveDefinitions _calculateWaveLineDefinition() {
    double bendWidth = 40;
    double bezierWidth = 40;

    double startOfBend = sliderPosition - bendWidth / 2;
    double startOfBezier = startOfBend - bezierWidth;
    double endOfBend = sliderPosition + bendWidth / 2;
    double endOfBezier = endOfBend + bezierWidth;

    double controlHeight = 0.0;
    double centerPoint = sliderPosition;

    double leftControlPoint1 = startOfBend;
    double leftControlPoint2 = startOfBend;
    double rightControlPoint1 = endOfBend;
    double rightControlPoint2 = endOfBend;

    // how bendable the curve would be
    double bendability = 25.0;
    double maxSlideDifference = 20.0;

    double slideDifference = (sliderPosition - _previousSliderPosition).abs();
    slideDifference = (sliderPosition > maxSlideDifference)
        ? maxSlideDifference
        : slideDifference;

    double bend =
        lerpDouble(0.0, bendability, slideDifference / maxSlideDifference)!;

    bool moveLeft = sliderPosition < _previousSliderPosition;

    if (moveLeft) {
      leftControlPoint1 = leftControlPoint1 - bend;
      leftControlPoint2 = leftControlPoint2 + bend;
      rightControlPoint1 = rightControlPoint1 + bend;
      rightControlPoint2 = rightControlPoint2 - bend;
      centerPoint = centerPoint + bend;
    } else {
      leftControlPoint1 = leftControlPoint1 + bend;
      leftControlPoint2 = leftControlPoint2 - bend;
      rightControlPoint1 = rightControlPoint1 - bend;
      rightControlPoint2 = rightControlPoint2 + bend;
      centerPoint = centerPoint - bend;
    }

    WaveCurveDefinitions waveCurve = WaveCurveDefinitions(
      startOfBezier: startOfBezier,
      endOfBezier: endOfBezier,
      startOfBend: startOfBend,
      endOfBend: endOfBend,
      leftControlPoint1: leftControlPoint1,
      leftControlPoint2: leftControlPoint2,
      rightControlPoint1: rightControlPoint1,
      rightControlPoint2: rightControlPoint2,
      controlHeight: controlHeight,
      centerPoint: centerPoint,
    );

    return waveCurve;
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    _previousSliderPosition = oldDelegate.sliderPosition;
    return true;
  }
}

class WaveCurveDefinitions {
  final double startOfBend;
  final double endOfBend;
  final double startOfBezier;
  final double endOfBezier;
  final double leftControlPoint1;
  final double leftControlPoint2;
  final double rightControlPoint1;
  final double rightControlPoint2;
  final double controlHeight;
  final double centerPoint;

  WaveCurveDefinitions({
    required this.startOfBend,
    required this.endOfBend,
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

import 'dart:ui' as ui;

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

class _WaveSliderState extends State<WaveSlider>
    with SingleTickerProviderStateMixin {
  late WaveSliderController _sliderController;

  double _dragPosition = 0;
  double _dragPercentage = 0;

  @override
  void initState() {
    super.initState();
    _sliderController = WaveSliderController(vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.globalPosition);
    _sliderController.setStateToStart();
    _updateDragPosition(offset);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.globalPosition);
    _sliderController.setStateToSliding();
    _updateDragPosition(offset);
  }

  void _onPanEnd(DragEndDetails details) {
    _sliderController.setStateToStopping();
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
            animationProgress: _sliderController.progress,
            sliderState: _sliderController.state,
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
  final double animationProgress;
  final SliderState sliderState;

  double _previousSliderPosition = 0;

  late final Paint fillPaint;
  late final Paint linePaint;

  WavePainter({
    required this.sliderPosition,
    required this.dragPercentage,
    required this.color,
    required this.animationProgress,
    required this.sliderState,
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
    // _paintWaveLine(canvas, size);

    switch (sliderState) {
      case SliderState.starting:
        _paintStartupWave(canvas, size);
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
      default:
        _paintRestingWave(canvas, size);
        break;
    }
  }

  void _paintStartupWave(Canvas canvas, Size size) {
    WaveCurveDefinitions line = _calculateWaveLineDefinitions(size);

    double waveHeight = ui.lerpDouble(size.height, line.controlHeight,
        Curves.elasticOut.transform(animationProgress))!;

    line.controlHeight = waveHeight;

    _paintWaveLine(canvas, size, line);
  }

  void _paintStoppingWave(Canvas canvas, Size size) {
    WaveCurveDefinitions line = _calculateWaveLineDefinitions(size);

    double waveHeight = ui.lerpDouble(line.controlHeight, size.height,
        Curves.elasticOut.transform(animationProgress))!;

    line.controlHeight = waveHeight;

    _paintWaveLine(canvas, size, line);
  }

  void _paintRestingWave(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, linePaint);
  }

  void _paintSlidingWave(Canvas canvas, Size size) {
    final curveDefinitions = _calculateWaveLineDefinitions(size);
    _paintWaveLine(canvas, size, curveDefinitions);
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

  void _paintWaveLine(
      Canvas canvas, Size size, WaveCurveDefinitions waveCurve) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(waveCurve.startOfBezier, size.height);
    path.cubicTo(
        waveCurve.leftControlPoint1,
        size.height,
        waveCurve.leftControlPoint2,
        waveCurve.controlHeight,
        waveCurve.centerPoint,
        waveCurve.controlHeight);
    path.cubicTo(
        waveCurve.rightControlPoint1,
        waveCurve.controlHeight,
        waveCurve.rightControlPoint2,
        size.height,
        waveCurve.endOfBezier,
        size.height);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    _previousSliderPosition = oldDelegate.sliderPosition;
    return true;
  }

  WaveCurveDefinitions _calculateWaveLineDefinitions(Size size) {
    double minRatio = 0.2;

    double minWaveHeight = size.height * minRatio;
    double maxWaveHeight = size.height * (1 - minRatio);

    double controlHeight =
        (size.height - minWaveHeight) - maxWaveHeight * dragPercentage;

    double bendWidth = 20 + 20 * dragPercentage;
    double bezierWidth = 20 + 20 * dragPercentage;

    double centerPoint = sliderPosition;

    double startOfBend = centerPoint - bendWidth / 2;
    double startOfBezier = startOfBend - bezierWidth;
    double endOfBend = centerPoint + bendWidth / 2;
    double endOfBezier = endOfBend + bezierWidth;

    startOfBend = startOfBend <= 0.0 ? 0.0 : startOfBend;
    startOfBezier = startOfBezier <= 0.0 ? 0.0 : startOfBezier;
    endOfBend = endOfBend >= size.width ? size.width : endOfBend;
    endOfBezier = endOfBezier >= size.width ? size.width : endOfBezier;

    double leftControlPoint1 = startOfBend;
    double leftControlPoint2 = startOfBend;
    double rightControlPoint1 = endOfBend;
    double rightControlPoint2 = endOfBend;

    double bendability = 25.0;
    double maxDifference = 20.0;

    double slideDifference = (sliderPosition - _previousSliderPosition).abs();

    if (slideDifference > maxDifference) {
      slideDifference = maxDifference;
    }

    int moveLeft = sliderPosition < _previousSliderPosition ? 1 : -1;

    double bend =
        ui.lerpDouble(0, bendability, slideDifference / maxDifference)! *
            moveLeft;

    leftControlPoint1 = leftControlPoint1 - bend;
    leftControlPoint2 = leftControlPoint2 + bend;
    rightControlPoint1 = rightControlPoint1 + bend;
    rightControlPoint2 = rightControlPoint2 - bend;
    centerPoint = centerPoint + bend;

    return WaveCurveDefinitions(
      centerPoint: centerPoint,
      startOfBezier: startOfBezier,
      endOfBezier: endOfBezier,
      leftControlPoint1: leftControlPoint1,
      leftControlPoint2: leftControlPoint2,
      rightControlPoint1: rightControlPoint1,
      rightControlPoint2: rightControlPoint2,
      controlHeight: controlHeight,
    );
  }
}

class WaveCurveDefinitions {
  final double centerPoint;
  final double startOfBezier;
  final double endOfBezier;
  final double leftControlPoint1;
  final double leftControlPoint2;
  final double rightControlPoint1;
  final double rightControlPoint2;
  double controlHeight;

  WaveCurveDefinitions({
    required this.centerPoint,
    required this.startOfBezier,
    required this.endOfBezier,
    required this.leftControlPoint1,
    required this.leftControlPoint2,
    required this.rightControlPoint1,
    required this.rightControlPoint2,
    required this.controlHeight,
  });
}

class WaveSliderController with ChangeNotifier {
  late AnimationController controller;
  SliderState _state = SliderState.resting;

  WaveSliderController({required TickerProvider vsync})
      : controller = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 500),
        ) {
    controller
      ..addListener(_onProgressUpdate)
      ..addStatusListener(_onStatusUpdate);
  }

  double get progress => controller.value;

  SliderState get state => _state;

  void _onProgressUpdate() {
    notifyListeners();
  }

  void _onStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onTransitionCompleted();
    }
  }

  void _onTransitionCompleted() {
    switch (_state) {
      case SliderState.starting:
        // TODO: Handle this case.
        break;
      case SliderState.resting:
        // TODO: Handle this case.
        break;
      case SliderState.sliding:
        // TODO: Handle this case.
        break;
      case SliderState.stopping:
        setStateToResting();
        break;
    }
  }

  void _startAnimation() {
    controller.forward(from: 0.0);
    notifyListeners();
  }

  void setStateToResting() {
    _state = SliderState.resting;
  }

  void setStateToStart() {
    _startAnimation();
    _state = SliderState.starting;
  }

  void setStateToSliding() {
    _state = SliderState.sliding;
  }

  void setStateToStopping() {
    _startAnimation();
    _state = SliderState.stopping;
  }
}

enum SliderState {
  starting,
  resting,
  sliding,
  stopping,
}

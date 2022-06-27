import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';

class SprayScreen extends StatefulWidget {
  const SprayScreen({Key? key}) : super(key: key);

  @override
  State<SprayScreen> createState() => _SprayScreenState();
}

class _SprayScreenState extends State<SprayScreen> {
  late StreamController<List<_SprayLine>> linesStremController;
  late StreamController<_SprayLine?> currentLineStreamController;

  List<_SprayLine> lines = [];
  _SprayLine? line;

  Color _selectedColor = Colors.black;
  double _selectedWidth = 10;

  @override
  void initState() {
    super.initState();
    linesStremController = StreamController<List<_SprayLine>>.broadcast();
    currentLineStreamController = StreamController<_SprayLine?>.broadcast();
  }

  @override
  void dispose() {
    linesStremController.close();
    currentLineStreamController.close();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    line = _SprayLine(
      path: [details.localFocalPoint],
      color: _selectedColor,
      width: _selectedWidth,
    );

    currentLineStreamController.add(line);
  }

  void _clear() {
    line = null;
    lines.clear();

    currentLineStreamController.add(line);
    linesStremController.add(lines);
  }

  void _deleteLatest() {
    line = null;
    if (lines.isNotEmpty) {
      lines.removeLast();
    }

    currentLineStreamController.add(line);
    linesStremController.add(lines);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final points = List<Offset>.from(line!.path)..add(details.localFocalPoint);

    line =
        _SprayLine(path: points, color: _selectedColor, width: _selectedWidth);

    currentLineStreamController.add(line);
  }

  void _onScaleEnd(ScaleEndDetails details) {
    lines.add(line!);
    linesStremController.add(lines);

    line = null;
    currentLineStreamController.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildAllPaths(),
          _buildCurrentPath(),
          _buildGestureDetector(),
          _buildButtonToolBox(),
        ],
      ),
    );
  }

  Widget _buildAllPaths() {
    return StreamBuilder<List<_SprayLine>>(
        stream: linesStremController.stream,
        builder: (context, snapshot) {
          return CustomPaint(
            painter: SprayPainter(lines: lines),
            size: Size.infinite,
          );
        });
  }

  Widget _buildCurrentPath() {
    return StreamBuilder<_SprayLine?>(
        stream: currentLineStreamController.stream,
        builder: (context, snapshot) {
          return CustomPaint(
            painter: SprayPainter(lines: line == null ? [] : [line!]),
            size: Size.infinite,
          );
        });
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
    );
  }

  Widget _buildButtonToolBox() {
    return Positioned(
      top: 50,
      right: 20,
      child: Column(
        children: [
          _buildClearButton(),
          const SizedBox(height: 12),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: _clear,
      child: const CircleAvatar(
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _deleteLatest,
      child: const CircleAvatar(
        child: Icon(Icons.restore_page),
      ),
    );
  }
}

class SprayPainter extends CustomPainter {
  final List<_SprayLine> lines;

  const SprayPainter({
    required this.lines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // _edgeSmoothing(canvas, size);
    // _pointsWithShadow(canvas, size);
    // _bezier(canvas, size);
    _sprayWithRound(canvas, size);
  }

  double distanceBetween(Offset point1, Offset point2) {
    return math.sqrt(
      math.pow(point2.dx - point1.dx, 2) + math.pow(point2.dy - point1.dy, 2),
    );
  }

  double angleBetween(Offset point1, Offset point2) {
    return math.atan2(point2.dx - point1.dx, point2.dy - point1.dy);
  }

  ui.Offset midPointBetween(Offset p1, Offset p2) {
    return ui.Offset(
      p1.dx + (p2.dx - p1.dx) / 2,
      p1.dy + (p2.dy - p1.dy) / 2,
    );
  }

  void _sprayWithRound(Canvas canvas, Size size) {
    for (final line in lines) {
      for (var i = 0; i < line.path.length; i++) {
        canvas.drawCircle(
          line.path[i],
          30,
          Paint()
            ..color = Colors.black
            ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 20),
        );
      }
    }
  }

  void _pointsWithShadow(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 5.0;

    /// how to show shadow
    Paint shadowPaint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..strokeWidth = 10.0;

    for (final line in lines) {
      final path = Path();
      path.moveTo(line.path[0].dx, line.path[0].dy);

      for (var i = 0; i < line.path.length; i++) {
        path.lineTo(line.path[i].dx, line.path[i].dy);
      }

      paint
        ..color = line.color
        ..strokeWidth = line.width;

      shadowPaint
        ..color = line.color
        ..strokeWidth = line.width;

      canvas.drawPath(path, shadowPaint);
      canvas.drawPath(path, paint);
    }

    /// how to draw shadow
  }

  /// for 문을 다시 한번 돌기 때문에 performance가 좋지 않음
  void _edgeSmoothing(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 5.0;

    ui.Gradient shader;

    for (final line in lines) {
      var lastPoint = line.path[0];

      for (var i = 0; i < line.path.length; i++) {
        var currentPoint = line.path[i];
        var dist = distanceBetween(lastPoint, currentPoint);
        var angle = angleBetween(lastPoint, currentPoint);

        for (var i = 0; i < dist; i += 5) {
          var x = lastPoint.dx + (math.sin(angle) * i);
          var y = lastPoint.dy + (math.cos(angle) * i);

          shader = ui.Gradient.radial(
            Offset(x, y),
            20.0,
            [
              Colors.black,
              Colors.black.withOpacity(.5),
              Colors.transparent,
            ],
            [
              0,
              0.5,
              1,
            ],
          );

          paint
            ..color = line.color
            ..strokeWidth = line.width
            ..style = ui.PaintingStyle.fill
            ..shader = shader;

          canvas.drawCircle(Offset(x, y), 20, paint);
        }

        lastPoint = currentPoint;
      }
    }
  }

  void _bezier(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = ui.PaintingStyle.stroke
      ..color = Colors.red
      ..strokeCap = ui.StrokeCap.round
      ..strokeJoin = ui.StrokeJoin.round
      ..strokeWidth = 10.0;

    Paint shadowPaint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = ui.StrokeCap.round
      ..style = ui.PaintingStyle.stroke
      ..strokeJoin = ui.StrokeJoin.round
      ..maskFilter = const ui.MaskFilter.blur(BlurStyle.normal, 5)
      ..strokeWidth = 10.0;

    for (final line in lines) {
      if (line.path.length <= 1) {
        return;
      }
      var p1 = line.path[0];
      var p2 = line.path[1];

      final path = Path();
      path.moveTo(line.path[0].dx, line.path[0].dy);

      for (var i = 0; i < line.path.length - 1; i++) {
        // pick the point between pi+1 & pi+2 as the
        // end point and p1 as our control point

        var midPoint = midPointBetween(p1, p2);

        path.quadraticBezierTo(p1.dx, p1.dy, midPoint.dx, midPoint.dy);

        p1 = line.path[i];
        p2 = line.path[i + 1];
      }

      // draw the last line as a straight line while
      // we wait for the next point to be able to calculate
      // the bezier control point
      path.lineTo(p1.dx, p1.dy);

      paint
        ..color = line.color
        ..strokeWidth = line.width;

      shadowPaint
        ..color = line.color
        ..strokeWidth = line.width;

      canvas.drawPath(path, shadowPaint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SprayPainter oldDelegate) {
    return lines != oldDelegate.lines;
  }
}

class _SprayLine {
  final List<Offset> path;
  final Color color;
  final double width;

  const _SprayLine({
    required this.path,
    required this.color,
    required this.width,
  });
}

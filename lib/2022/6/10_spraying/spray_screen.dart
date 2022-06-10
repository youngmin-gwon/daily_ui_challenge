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
      // extendBodyBehindAppBar: true,
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
}

class SprayPainter extends CustomPainter {
  final List<_SprayLine> lines;

  const SprayPainter({
    required this.lines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    for (final line in lines) {
      final path = Path();
      path.moveTo(line.path[0].dx, line.path[0].dy);

      for (var i = 0; i < line.path.length - 1; i++) {
        path.lineTo(line.path[i].dx, line.path[i].dy);
      }

      paint
        ..color = line.color
        ..strokeWidth = line.width;

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

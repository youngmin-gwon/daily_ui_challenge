import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChangingShapeScreen extends StatefulWidget {
  const ChangingShapeScreen({Key? key}) : super(key: key);

  @override
  State<ChangingShapeScreen> createState() => _ChangingShapeScreenState();
}

class _ChangingShapeScreenState extends State<ChangingShapeScreen>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<double> time;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    time = ValueNotifier<double>(0);
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    time.dispose();
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    time.value = elapsed.inMicroseconds / 1e6;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: CustomPaint(
          painter: ChangingShapePainter(time: time),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class ChangingShapePainter extends CustomPainter {
  final ValueListenable<double> time;

  ChangingShapePainter({
    required this.time,
  }) : super(repaint: time);

  static const _pointsN = 420, _pN = 50;
  static const double _pointDiameter = 15, _frameDimension = 750;

  late final List<Path> _paths = <Path>[_cp, _sp, _cp, _hxp, _hrp, _tp];
  late final _points = [for (final path in _paths) _pointsFromPath(path)];

  @override
  void paint(Canvas canvas, Size size) {
    double t = time.value;

    canvas.drawColor(const Color(0xFF000000), BlendMode.srcOver);

    canvas.translate((size.width - size.shortestSide) / 2,
        (size.height - size.shortestSide) / 2);

    final scaling = size.shortestSide / _frameDimension;
    canvas.scale(scaling);
    const scaledSize = Size.square(_frameDimension);

    canvas.clipRect(Offset.zero & scaledSize);

    final h = scaledSize.width / 2;
    canvas.translate(h, h);
    t *= 1.5;

    final p1 = _points[(t ~/ 3 - 1) % _paths.length];
    final p2 = _points[(t ~/ 3) % _paths.length];

    final progress = (t % 3) / 3;
    for (var i = 0; i < _pN; i++) {
      _drawPoints(
          canvas, p1, p2, _ms.transform(math.min(1, progress + i / 250)), i);
    }
  }

  void _drawPoints(
      Canvas canvas, List<Offset> p1, List<Offset> p2, double progress, int i) {
    final points = [
      for (var i = 0; i < _pointsN; i++) Offset.lerp(p1[i], p2[i], progress)!
    ];

    canvas.drawPoints(
      PointMode.points,
      points,
      Paint()
        ..color = HSVColor.fromAHSV(math.min(1, 1.5 / _pN), 360 / _pN * i, 1, 1)
            .toColor()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = _pointDiameter
        ..blendMode = BlendMode.plus,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  List<Offset> _pointsFromPath(Path path) {
    final metric = path.computeMetrics().first;
    final interval = metric.length / _pointsN;
    return <Offset>[
      for (var i = 0; i < _pointsN; i++)
        metric.getTangentForOffset(interval * i)!.position,
    ];
  }

  final _cp = Path()
    ..addOval(
      Rect.fromCircle(center: Offset.zero, radius: _frameDimension / 2.5),
    );

  final _sp = Path()
    ..addRegularPolygon(
      center: Offset.zero,
      radius: _frameDimension / 4,
      vertices: 4,
    );

  final _tp = Path()
    ..addRegularPolygon(
      center: Offset.zero,
      radius: _frameDimension / 3,
      vertices: 3,
    );

  final _hxp = Path()
    ..addRegularPolygon(
      center: Offset.zero,
      radius: _frameDimension / 3.5,
      vertices: 6,
    );

  final _hrp = Path()
    ..moveTo(0, -_frameDimension / 5)
    ..cubicTo(
      _frameDimension / 8,
      -_frameDimension / 2,
      _frameDimension / 1.5,
      -_frameDimension / 8,
      0,
      _frameDimension / 3,
    )
    ..cubicTo(
      -_frameDimension / 1.5,
      -_frameDimension / 8,
      -_frameDimension / 8,
      -_frameDimension / 2,
      0,
      -_frameDimension / 5,
    );

  final _ms = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: 1),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: Curves.fastOutSlowIn)),
      weight: 9,
    ),
  ]);
}

extension PathX on Path {
  void addRegularPolygon({
    required Offset center,
    required double radius,
    required int vertices,
  }) {
    final points = <Offset>[];
    for (var i = 0; i < vertices; i++) {
      final angle = 2 * math.pi / vertices * (i - 1 / 2) + math.pi / 2;
      points.add(Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      ));
    }

    addPolygon(points, true);
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BouncingBallScreen extends StatefulWidget {
  const BouncingBallScreen({Key? key}) : super(key: key);

  @override
  State<BouncingBallScreen> createState() => _BouncingBallScreenState();
}

class _BouncingBallScreenState extends State<BouncingBallScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  // ball 을 build에 할당하기 때문에 임의값이라도 넣어줘야함
  // late Ball _ball;
  Ball _ball = Ball(x: 0, y: 0, dx: 0, dy: 0, radius: 0);

  Block _block = Block(
    minHeight: 0,
    maxHeight: 0,
    minWidth: 0,
    maxWidth: 0,
  );

  late Size size;

  final _random = math.Random();

  final double _maxRadius = 50;
  final int _maxVelocity = 10;

  final double _minHeight = 20;
  final double _maxHeight = 50;
  final double _minWidth = 200;
  final double _maxWidth = 300;

  final double minValue = 10;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      size = MediaQuery.of(context).size;
      final radius = (_maxRadius - minValue) * _random.nextDouble() + minValue;
      // final xPos = _random.nextDouble() * (size.width - 2 * radius) + radius;
      final xPos = size.width / 2;
      // final yPos = _random.nextDouble() * (size.height - 2 * radius) + radius;
      final yPos = size.height / 2;
      final double vX =
          (_random.nextDouble() * (_maxVelocity - minValue) + minValue) *
              (_random.nextBool() ? 1 : -1);
      final double vY =
          (_random.nextDouble() * (_maxVelocity - minValue) + minValue) *
              (_random.nextBool() ? 1 : -1);

      _ball = Ball(
        x: xPos,
        y: yPos,
        dx: vX,
        dy: vY,
        radius: radius,
      );

      _block = Block(
        minWidth: _minWidth,
        maxWidth: _maxWidth,
        minHeight: _minHeight,
        maxHeight: _maxHeight,
      );
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsedTime) {
    setState(() {
      _ball.calculatePosition(size.width, size.height);
      _ball.calculatePositionWithBlock(_block);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: CustomPaint(
          size: Size.infinite,
          painter: _SketchPainter(
            ball: _ball,
            block: _block,
          ),
        ),
      ),
    );
  }
}

class _SketchPainter extends CustomPainter {
  final Ball ball;
  final Block? block;

  const _SketchPainter({
    required this.ball,
    this.block,
  });

  static final _ballPaint = Paint()
    ..color = Colors.amber
    ..style = PaintingStyle.fill;

  static final _blockPaint = Paint()
    ..color = const Color(0xFFFF384E)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(ball.x, ball.y),
      ball.radius,
      _ballPaint,
    );

    if (block != null) {
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(block!.x, block!.y),
            width: block!.width,
            height: block!.height),
        _blockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SketchPainter oldDelegate) {
    return ball != oldDelegate.ball;
  }
}

class Ball {
  double x;
  double y;
  double dx;
  double dy;
  final double radius;

  Ball({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
  });

  void calculatePosition(double maxWidth, double maxHeight) {
    final minX = radius;
    final maxX = maxWidth - radius;
    final minY = radius;
    final maxY = maxHeight - radius;

    if (x <= minX || x >= maxX) {
      dx *= -1;
    }

    if (y <= minY || y >= maxY) {
      dy *= -1;
    }

    x += dx;
    y += dy;
  }

  void calculatePositionWithBlock(Block block) {
    final minX = block.x - block.width / 2 - radius;
    final maxX = block.x + block.width / 2 + radius;
    final minY = block.y - block.height / 2 - radius;
    final maxY = block.y + block.height / 2 + radius;

    if (x > minX && x < maxX && y > minY && y < maxY) {
      final x1 = (minX - x).abs();
      final x2 = (x - maxX).abs();
      final y1 = (minY - y).abs();
      final y2 = (y - maxY).abs();
      final min1 = math.min(x1, x2);
      final min2 = math.min(y1, y2);
      final min = math.min(min1, min2);

      if (min == min1) {
        dx *= -1;
        x += dx;
      } else if (min == min2) {
        dy *= -1;
        y += dy;
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ball &&
        other.x == x &&
        other.y == y &&
        other.dx == dx &&
        other.dy == dy &&
        other.radius == radius;
  }

  @override
  int get hashCode {
    return x.hashCode ^
        y.hashCode ^
        dx.hashCode ^
        dy.hashCode ^
        radius.hashCode;
  }
}

class Block {
  final double maxWidth;
  final double maxHeight;
  final double minWidth;
  final double minHeight;

  late double _height;
  late double _width;
  late double _x;
  late double _y;

  double get x => _x;
  double get y => _y;
  double get height => _height;
  double get width => _width;

  static final _random = math.Random();

  Block({
    required this.maxWidth,
    required this.maxHeight,
    required this.minWidth,
    required this.minHeight,
  }) {
    _height = minHeight + (maxHeight - minHeight) * _random.nextDouble();
    _width = minWidth + (maxWidth - minWidth) * _random.nextDouble();
    _x = 400;
    _y = 100;
  }
}

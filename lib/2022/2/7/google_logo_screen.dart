import 'dart:math' as math;
import 'package:flutter/material.dart';

class GoogleLogoScreen extends StatefulWidget {
  const GoogleLogoScreen({
    Key? key,
    this.size = 250,
  }) : super(key: key);

  final double size;

  @override
  _GoogleLogoScreenState createState() => _GoogleLogoScreenState();
}

class _GoogleLogoScreenState extends State<GoogleLogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lineAnimation;
  late Animation<double> _blueAnimation;
  late Animation<double> _greenAnimation;
  late Animation<double> _yellowAnimation;
  late Animation<double> _redAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    _lineAnimation = Tween<double>(begin: 0, end: widget.size / 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.ease),
      ),
    );
    _blueAnimation = CurveTween(curve: Curves.linear).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.33)));

    _greenAnimation = CurveTween(curve: Curves.linear).animate(CurvedAnimation(
        parent: _controller, curve: const Interval(0.33, 0.36)));

    _yellowAnimation = CurveTween(curve: Curves.linear).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.36, 0.4)));

    _redAnimation = CurveTween(curve: Curves.decelerate).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.square(widget.size),
                  painter: GooglePainter(
                    line: _lineAnimation.value,
                    blue: _blueAnimation.value,
                    green: _greenAnimation.value,
                    yellow: _yellowAnimation.value,
                    red: _redAnimation.value,
                  ),
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  _controller.forward(from: 0);
                },
                child: const Text("Animate"))
          ],
        ),
      ),
    );
  }
}

class GooglePainter extends CustomPainter {
  final double line;
  final double blue;
  final double green;
  final double yellow;
  final double red;

  const GooglePainter({
    required this.line,
    required this.blue,
    required this.green,
    required this.yellow,
    required this.red,
  });

  static final _paint = Paint()..style = PaintingStyle.stroke;

  static const _start = 0.0;
  static const _blueStop = math.pi / 5;
  static const _greenStop = 4 * math.pi / 5;
  static const _yellowStop = 7 * math.pi / 6;
  static const _redStop = 7 * math.pi / 4;

  @override
  void paint(Canvas canvas, Size size) {
    final length = size.width;
    final arcThickness = size.width / 4.5;
    final verticalOffset = (size.height / 2) - (length / 2) - arcThickness / 2;
    final horizontalOffset =
        (length / 2) - (size.height / 2) + arcThickness / 2;
    final bounds = Offset(horizontalOffset, verticalOffset) &
        Size.square(length - arcThickness);
    final center = bounds.center;
    _paint
      ..strokeWidth = arcThickness
      ..color = Colors.blue.shade600;

    final path = Path();

    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx + math.max(0, line - arcThickness / 2), center.dy);
    path.arcTo(bounds, _start, math.max(_start, blue * _blueStop),
        blue > 0 ? false : true);

    canvas.drawPath(path, _paint);

    canvas.drawArc(bounds, _blueStop, (_greenStop - _blueStop) * green, false,
        _paint..color = Colors.green.shade600);

    canvas.drawArc(bounds, _greenStop, (_yellowStop - _greenStop) * yellow,
        false, _paint..color = Colors.amber);

    canvas.drawArc(bounds, _yellowStop, (_redStop - _yellowStop) * red, false,
        _paint..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant GooglePainter oldDelegate) {
    return line != oldDelegate.line ||
        blue != oldDelegate.blue ||
        green != oldDelegate.green ||
        yellow != oldDelegate.yellow ||
        red != oldDelegate.red;
  }
}

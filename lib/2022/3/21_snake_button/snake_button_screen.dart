import 'dart:math' as math;

import 'package:flutter/material.dart';

class SnakeButtonScreen extends StatelessWidget {
  const SnakeButtonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SnakeButton(
                child: const Text('Hello, world!'),
                onTap: () => print('tap'),
              ),
              const SizedBox(height: 12),
              SnakeButton(
                snakeColor: Colors.red,
                borderWidth: 3,
                duration: const Duration(seconds: 3),
                child: const Text('Hello, guys'),
                onTap: () => print('tap'),
              ),
              const SizedBox(height: 12),
              SnakeButton(
                snakeColor: Colors.black,
                borderColor: Colors.green,
                borderWidth: 8,
                duration: const Duration(seconds: 1),
                child: const Text("Don't touch me"),
                onTap: () => print('tap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SnakeButton extends StatefulWidget {
  const SnakeButton({
    Key? key,
    required this.child,
    this.duration,
    this.snakeColor,
    this.borderColor,
    this.borderWidth,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final Duration? duration;
  final Color? snakeColor;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;

  @override
  State<SnakeButton> createState() => _SnakeButtonState();
}

class _SnakeButtonState extends State<SnakeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1500),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: CustomPaint(
        painter: _SnakePainter(
            animation: _controller,
            borderColor: widget.borderColor ?? Colors.white,
            snakeColor: widget.snakeColor ?? Colors.purple,
            borderWidth: widget.borderWidth ?? 4),
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: widget.child),
      ),
    );
  }
}

class _SnakePainter extends CustomPainter {
  final Animation<double> animation;
  final Color snakeColor;
  final Color borderColor;
  final double borderWidth;

  const _SnakePainter({
    required this.animation,
    required this.snakeColor,
    required this.borderColor,
    required this.borderWidth,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          snakeColor,
          Colors.transparent,
        ],
        stops: const [
          0.7,
          1.0,
        ],
        startAngle: 0.0,
        endAngle: math.pi / 2,
        transform: GradientRotation(math.pi * 2 * animation.value),
      ).createShader(rect);
    final path = Path.combine(
      PathOperation.xor,
      Path()..addRect(rect),
      Path()
        ..addRect(
          rect.deflate(borderWidth),
        ),
    );

    canvas.drawRect(
      rect.deflate(borderWidth / 2),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

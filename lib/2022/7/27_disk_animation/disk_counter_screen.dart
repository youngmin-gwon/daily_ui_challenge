import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:daily_ui/2022/6/27_particle/particle_counter_screen.dart';

class DiskCounterScreen extends StatefulWidget {
  const DiskCounterScreen({Key? key}) : super(key: key);

  @override
  State<DiskCounterScreen> createState() => _DiskCounterScreenState();
}

class _DiskCounterScreenState extends State<DiskCounterScreen> {
  int _count = 0;

  final random = math.Random();

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          for (int i = 0; i < _count; i++)
            Positioned.fill(
              child: Disk(random: random),
            ),
          CounterText(count: _count),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Disk extends StatefulWidget {
  const Disk({
    Key? key,
    required this.random,
  }) : super(key: key);

  final math.Random random;

  @override
  State<Disk> createState() => _DiskState();
}

class _DiskState extends State<Disk> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double radius;
  late CenterTween centerTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    radius = widget.random.nextDouble() * 50 + 25;

    final candidates = [
      Offset(widget.random.nextDouble(), -0.1),
      Offset(widget.random.nextDouble(), 1.1),
      Offset(-0.1, widget.random.nextDouble()),
      Offset(1.1, widget.random.nextDouble()),
    ];

    final start = candidates.removeAt(widget.random.nextInt(candidates.length));
    final end = candidates.removeAt(widget.random.nextInt(candidates.length));

    centerTween =
        CenterTween(begin: start, end: end, shift: widget.random.nextDouble());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0,
        end: radius,
      ),
      curve: Curves.elasticOut,
      duration: const Duration(seconds: 1),
      builder: (_, effectiveRadius, __) {
        return CustomPaint(
          size: Size.infinite,
          painter: DiskPainter(
            controller: _controller,
            centerTween: centerTween,
            radius: effectiveRadius,
          ),
        );
      },
    );
  }
}

class CenterTween extends Animatable<Offset> {
  final Offset begin;
  final Offset end;
  final double shift;
  final Offset translation;

  const CenterTween({
    required this.begin,
    required this.end,
    required this.shift,
  }) : translation = begin - end;

  @override
  Offset transform(double t) {
    return begin + (end - begin) * ((t + shift) % 1);
  }
}

class DiskPainter extends CustomPainter {
  final Animation<double> controller;
  final double radius;
  final CenterTween centerTween;

  const DiskPainter({
    required this.controller,
    required this.radius,
    required this.centerTween,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ratioCenter = centerTween.evaluate(controller);
    final center = Offset(
      ratioCenter.dx * size.width,
      ratioCenter.dy * size.height,
    );
    final translation = Offset(
      centerTween.translation.dx * size.width,
      centerTween.translation.dy * size.height,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..blendMode = BlendMode.difference,
    );

    canvas.drawCircle(
      center + translation,
      radius,
      Paint()
        ..color = Colors.white
        ..blendMode = BlendMode.difference,
    );
  }

  @override
  bool shouldRepaint(covariant DiskPainter oldDelegate) {
    return oldDelegate.radius != radius;
  }
}

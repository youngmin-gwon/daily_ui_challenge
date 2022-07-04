import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:daily_ui/2022/6/27_particle/particle_counter_screen.dart';

class WaveCounterScreen extends StatefulWidget {
  const WaveCounterScreen({Key? key}) : super(key: key);

  @override
  State<WaveCounterScreen> createState() => _WaveCounterScreenState();
}

class _WaveCounterScreenState extends State<WaveCounterScreen> {
  int _count = 0;

  void _increment() {
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
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _count.toDouble()),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.bounceOut,
              builder: (_, double ratio, __) {
                return FractionallySizedBox(
                  heightFactor: (ratio / 100).clamp(0, 100).toDouble(),
                  alignment: Alignment.bottomCenter,
                  child: const Wave(
                    child: DifferenceMask(),
                  ),
                );
              },
            ),
          ),
          CounterText(count: _count),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Wave extends StatefulWidget {
  const Wave({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<List<Offset>> _waves;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: false);
    _waves = _controller.drive(const WaveTween(count: 100, height: 20));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(waves: _waves),
      child: widget.child,
    );
  }
}

class WaveTween extends Animatable<List<Offset>> {
  final int count;
  final double height;
  static const twoPi = math.pi * 2;
  static const waveCount = 5;

  const WaveTween({
    required this.count,
    required this.height,
  });

  @override
  List<Offset> transform(double t) {
    return List<Offset>.generate(
      count,
      (index) {
        final ratio = index / (count - 1);
        final amplitude = 1 - (0.5 - ratio).abs() * 2;
        return Offset(
          ratio,
          amplitude * height * math.sin(waveCount * (ratio + t) * twoPi) +
              height * amplitude,
        );
      },
      growable: false,
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  WaveClipper({
    required this.waves,
  }) : super(reclip: waves);

  Animation<List<Offset>> waves;

  @override
  Path getClip(Size size) {
    final width = size.width;
    final points = waves.value.map((o) => Offset(o.dx * width, o.dy)).toList();
    return Path()
      ..addPolygon(points, false)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DifferenceMask extends StatelessWidget {
  const DifferenceMask({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: DifferencePainter(),
    );
  }
}

class DifferencePainter extends CustomPainter {
  const DifferencePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

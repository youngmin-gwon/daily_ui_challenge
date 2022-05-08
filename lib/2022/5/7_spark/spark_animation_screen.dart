import 'dart:math' as math;

import 'package:flutter/material.dart';

class SparkAnimationScreen extends StatefulWidget {
  const SparkAnimationScreen({Key? key}) : super(key: key);

  @override
  State<SparkAnimationScreen> createState() => _SparkAnimationScreenState();
}

class _SparkAnimationScreenState extends State<SparkAnimationScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Sparkler(),
      ),
    );
  }
}

class Sparkler extends StatefulWidget {
  const Sparkler({Key? key}) : super(key: key);

  @override
  State<Sparkler> createState() => _SparklerState();
}

class _SparklerState extends State<Sparkler>
    with SingleTickerProviderStateMixin {
  final double width = 300;
  final double progress = .5;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: 100,
        child: Stack(
          children: getParticles(),
        ),
      ),
    );
  }

  List<Widget> getParticles() {
    final particles = <Widget>[];
    double width = 300;
    particles.add(CustomPaint(
        painter: StickPainter(progress: progress), child: Container()));

    int maxParticles = 160;
    for (var i = 1; i <= maxParticles; i++) {
      if (progress >= 1) {
        continue;
      }
      particles.add(
        Padding(
          padding: EdgeInsets.only(left: progress * width, top: 20),
          child: Transform.rotate(
            angle: maxParticles / i * math.pi,
            child: const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Particle(),
            ),
          ),
        ),
      );
    }

    return particles;
  }
}

class Particle extends StatefulWidget {
  const Particle({Key? key}) : super(key: key);

  @override
  State<Particle> createState() => _ParticleState();
}

class _ParticleState extends State<Particle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double randomSpawnDelay;
  late double randomSize;
  bool visible = true;

  late double arcImpact;

  late bool isStar;
  late double starPosition;

  static final _random = math.Random();

  @override
  void initState() {
    super.initState();
    randomSpawnDelay = _random.nextDouble();
    randomSize = _random.nextDouble();

    arcImpact = _random.nextDouble() * 2 - 1;

    isStar = _random.nextDouble() > 0.9;
    starPosition = _random.nextDouble() + 0.5;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _startNextAnimation(
        Duration(milliseconds: (_random.nextDouble() * 1000).toInt()));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        visible = false;
        _startNextAnimation();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startNextAnimation([Duration? after]) {
    if (after == null) {
      int millis = (randomSpawnDelay * 300).toInt();
      after = Duration(milliseconds: millis);
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          randomSpawnDelay = _random.nextDouble();
          randomSize = _random.nextDouble();
          visible = true;

          arcImpact = _random.nextDouble() * 2 - 1;

          isStar = _random.nextDouble() > 0.3;
          starPosition = _random.nextDouble() + 0.5;
        });

        _controller.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: randomSize * 1.5,
      height: 30,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: CustomPaint(
                painter: _ParticlePainter(
                  currentLifetime: _controller.value,
                  randomSize: randomSize,
                  arcImpact: arcImpact,
                  isStar: isStar,
                  starPosition: starPosition,
                ),
              ),
            );
          }),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double currentLifetime;
  final double randomSize;
  final double arcImpact;
  final bool isStar;
  final double starPosition;

  const _ParticlePainter({
    required this.currentLifetime,
    required this.randomSize,
    required this.arcImpact,
    required this.isStar,
    required this.starPosition,
  });

  static final _sparklePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height * randomSize * currentLifetime * 2.5;

    if (isStar) {
      _drawStar(_sparklePaint, width, height, size, canvas);
    }

    _drawParticle(_sparklePaint, width, height, size, canvas);
  }

  void _drawParticle(
      Paint paint, double width, double height, Size size, Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);

    LinearGradient gradient = LinearGradient(
      colors: const [
        Colors.transparent,
        Color.fromRGBO(255, 255, 160, 1.0),
        Color.fromRGBO(255, 255, 160, 0.7),
        Color.fromRGBO(255, 180, 120, 0.7)
      ],
      stops: [0, size.height * currentLifetime / 30, 0.6, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    paint
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final path = Path()..addRect(rect);

    path.cubicTo(0, 0, width * 4 * arcImpact, height * 0.5, width, height);

    canvas.drawPath(path, _sparklePaint);
  }

  void _drawStar(
      Paint paint, double width, double height, Size size, Canvas canvas) {
    Path path = Path();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = width * .25;
    paint.color = const Color.fromRGBO(255, 255, 160, 1.0);

    double starSize = size.width * 2.5;
    double starBottom = height * starPosition;

    path.moveTo(0, starBottom - starSize);
    path.lineTo(starSize, starBottom);
    path.moveTo(starSize, starBottom - starSize);
    path.lineTo(0, starBottom);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class StickPainter extends CustomPainter {
  StickPainter({required this.progress, this.height = 4});

  final double progress;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    double burntStickHeight = height * 0.75;
    double burntStickWidth = progress * size.width;

    _drawBurntStick(burntStickHeight, burntStickWidth, size, canvas);
    _drawIntactStick(burntStickWidth, size, canvas);
  }

  void _drawIntactStick(double burntStickWidth, Size size, Canvas canvas) {
    Paint paint = Paint()..color = const Color.fromARGB(255, 100, 100, 100);

    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(burntStickWidth, size.height / 2 - height / 2,
              size.width - burntStickWidth, height),
          const Radius.circular(3)));

    canvas.drawPath(path, paint);
  }

  void _drawBurntStick(double burntStickHeight, double burntStickWidth,
      Size size, Canvas canvas) {
    double startHeat = progress - 0.1 <= 0 ? 0 : progress - 0.1;
    double endHeat = progress + 0.05 >= 1 ? 1 : progress + 0.05;

    LinearGradient gradient = LinearGradient(colors: const [
      Color.fromARGB(255, 80, 80, 80),
      Color.fromARGB(255, 100, 80, 80),
      Colors.red,
      Color.fromARGB(255, 130, 100, 100),
      Color.fromARGB(255, 130, 100, 100)
    ], stops: [
      0,
      startHeat,
      progress,
      endHeat,
      1.0
    ]);

    Paint paint = Paint();
    Rect rect = Rect.fromLTWH(0, size.height / 2 - burntStickHeight / 2,
        size.width, burntStickHeight);
    paint.shader = gradient.createShader(rect);

    Path path = Path()..addRect(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

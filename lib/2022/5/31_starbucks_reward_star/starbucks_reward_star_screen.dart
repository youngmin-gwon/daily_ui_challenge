import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StarbucksRewardStarScreen extends StatelessWidget {
  const StarbucksRewardStarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const Center(
        child: FloatingStars(),
      ),
    );
  }
}

class FloatingStars extends StatefulWidget {
  const FloatingStars({Key? key}) : super(key: key);

  @override
  State<FloatingStars> createState() => _FloatingStarsState();
}

class _FloatingStarsState extends State<FloatingStars>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late StarSystem _starSystem;

  Duration previousFrameTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _starSystem = StarSystem();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - previousFrameTime;
    _starSystem.update(dt);
    previousFrameTime = elapsed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFd7a254),
      child: CustomPaint(
        painter: StarSystemPainter(
          starSystem: _starSystem,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class StarSystemPainter extends CustomPainter {
  const StarSystemPainter({
    required this.starSystem,
  }) : super(repaint: starSystem);

  final StarSystem starSystem;

  @override
  void paint(Canvas canvas, Size size) {
    starSystem.init(size);

    for (final star in starSystem.stars) {
      canvas.save();
      final paint = Paint()..color = star.color;

      final starPathTemplate = StarPathTemplate(
        outerRadius: star.radius,
        innerRadius: star.radius * 0.5,
      );

      canvas
        ..translate(star.position.dx, star.position.dy)
        ..rotate(star.rotation)
        ..drawPath(starPathTemplate.toPath(), paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant StarSystemPainter oldDelegate) {
    return false;
  }
}

class StarSystem with ChangeNotifier {
  StarSystem({
    this.maxStarCount = 50,
  }) : stars = [];

  final int maxStarCount;
  final List<StarParticle> stars;
  bool _isInitialized = false;

  Size? _worldSize;

  void init(Size worldSize) {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    _worldSize = worldSize;

    _generateNewStars();
  }

  void update(Duration dt) {
    _cullOffscreenStars();
    _generateNewStars();

    for (final star in stars) {
      star.update(dt);
    }
    notifyListeners();
  }

  void _cullOffscreenStars() {
    if (_worldSize == null) {
      return;
    }

    for (var i = stars.length - 1; i >= 0; i--) {
      if (stars[i].position.dx > _worldSize!.width) {
        stars.removeAt(i);
      }
    }
  }

  void _generateNewStars() {
    if (_worldSize == null) {
      return;
    }

    final random = math.Random();
    final newStarCount = maxStarCount - stars.length;
    for (var i = 0; i < newStarCount; i++) {
      stars.add(
        StarParticle(
          position: Offset(
            _worldSize!.width * random.nextDouble() - _worldSize!.width,
            _worldSize!.height * random.nextDouble(),
          ),
          radius: lerpDouble(10, 30, random.nextDouble())!,
          color: Color.lerp(
            const Color(0xFFFFF574),
            const Color(0xFFFFC55E),
            random.nextDouble(),
          )!,
          rotation: lerpDouble(0, 2 * math.pi, random.nextDouble())!,
          velocity: Offset(lerpDouble(10, 200, random.nextDouble())!, 0),
          radialVelocity: math.pi / 8 * random.nextDouble(),
        ),
      );
    }
  }
}

class StarParticle {
  StarParticle({
    required this.position,
    this.velocity = Offset.zero,
    required this.radius,
    this.rotation = 0,
    this.radialVelocity = 0,
    required this.color,
  });

  Offset position;
  final Offset velocity;
  final double radius;
  double rotation;
  final double radialVelocity;
  final Color color;

  void update(Duration dt) {
    position += velocity * (dt.inMilliseconds / 1e3);
    rotation += radialVelocity * (dt.inMilliseconds / 1e3);
  }
}

class StarPathTemplate {
  final double outerRadius;
  final double innerRadius;
  final int pointCount;

  const StarPathTemplate({
    this.outerRadius = 80,
    this.innerRadius = 50,
    this.pointCount = 5,
  }) : assert(pointCount >= 3);

  Path toPath() {
    const startAngle = -math.pi / 2;
    final angleIncrement = 2 * math.pi / (pointCount * 2);

    final starPath = Path();

    starPath.moveTo(
      outerRadius * math.cos(startAngle),
      outerRadius * math.sin(startAngle),
    );

    for (var i = 1; i < pointCount * 2; i += 2) {
      starPath
        ..lineTo(
          innerRadius * math.cos(startAngle + i * angleIncrement),
          innerRadius * math.sin(startAngle + i * angleIncrement),
        )
        ..lineTo(
          outerRadius * math.cos(startAngle + (i + 1) * angleIncrement),
          outerRadius * math.sin(startAngle + (i + 1) * angleIncrement),
        );
    }

    starPath.close();

    return starPath;
  }
}

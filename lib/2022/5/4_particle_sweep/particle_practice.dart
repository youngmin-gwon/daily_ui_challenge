import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ParticlePracticePage extends StatefulWidget {
  const ParticlePracticePage({Key? key}) : super(key: key);

  @override
  State<ParticlePracticePage> createState() => _ParticlePracticePageState();
}

class _ParticlePracticePageState extends State<ParticlePracticePage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late ValueNotifier<double> _time;

  int _particleCount = 700;
  double _particleRadius = 12, _blackHoldRadius = 100, _sprayRadius = 30;

  @override
  void initState() {
    super.initState();
    _time = ValueNotifier<double>(0);
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _time.dispose();
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    _time.value = elapsed.inMicroseconds / 1e6;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: CustomPaint(
          painter: _ParticlePainter(
            time: _time,
            particleCount: _particleCount,
            particleRadius: _particleRadius,
            blackHoleRadius: _blackHoldRadius,
            sprayRadius: _sprayRadius,
          ),
          size: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  /// Time that controls how the animation is drawn
  ///
  /// The value of this animation should be `t` in seconds.
  final ValueListenable<double> time;

  /// The number of particles that fly around and will be created after the
  /// previous particles reach the destination each time.

  final int particleCount;

  /// How close the particles need to be to the destination in order to reach it
  final double blackHoleRadius;

  /// How many pixels the particles should be sprayed out around the creation
  /// point initially
  final double sprayRadius;

  /// Size for each particle
  ///
  /// The width and height of each particle drawn is equal to this size value
  final double particleRadius;

  /// Padding controlling the minimum distance any destination for the particles
  /// can be away from any edge of the available space.
  static const _destinationPadding = 124;

  // Position of the particles
  double _x = 0, _y = 0;

  /// All information about all particles
  List<List<double>> _particles = [];

  _ParticlePainter({
    required this.time,
    required this.particleCount,
    required this.particleRadius,
    required this.blackHoleRadius,
    required this.sprayRadius,
  }) : super(repaint: time);

  void _createParticles(Size size) {
    /// Random that will be used to create the particles
    final random = math.Random();

    // Start without any particles
    _particles = [];

    // Create the particles
    for (var i = 0; i < particleCount; i++) {
      // The angle of this particle.
      // Each particle is distributed in a circle around the creation point.
      // In total, the particles fill up all angles in _particleCount steps.
      final angle = math.pi * 2 / particleCount * i;

      // add a particle at the current position and random initial values
      _particles.add([
        _x,
        _y,
        math.cos(angle) * sprayRadius * random.nextDouble(),
        math.sin(angle) * sprayRadius * random.nextDouble(),
        0,
      ]);
    }

    // Select a random destination for the particles in the available space.
    _x = _destinationPadding +
        random.nextDouble() * (size.width - _destinationPadding * 2);
    _y = _destinationPadding +
        random.nextDouble() * (size.height - _destinationPadding * 2);
  }

  double hypotenuse(num v1, num v2) {
    return math.sqrt(math.pow(v1, 2) + math.pow(v2, 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Time in seconds
    final t = time.value;

    // Initialize x and y based on the size
    // if (_x == null) {
    //   _x = size.width / 2;
    //   _y = size.height / 2;
    // }

    // Create particles initially and when all particles have reached
    // destination
    if (_particles.isEmpty) {
      _createParticles(size);
    }

    // Draw background
    canvas.drawRect(Offset.zero & size,
        Paint()..color = const Color.fromARGB(255, 18, 32, 47));

    // draw all particles and advance them.
    for (var particle in _particles) {
      // Set the distance of this particle to the destination.
      particle[4] = hypotenuse(_x - particle[0], _y - particle[1]);

      // Advance this particle and paint it.

      // Update spread.
      final c = math.pow(particle[4], 2) / 250;
      particle[2] += (_x - particle[0]) / c;
      particle[3] += (_y - particle[1]) / c;

      // Derive the color from HSL.
      final color = HSLColor.fromAHSL(
        1,
        (t * 4e2 - hypotenuse(particle[2], particle[3]) * 29) % 360,
        .8,
        .85,
      ).toColor();

      // Advance in the x direction.
      particle[2] *= .98;
      particle[0] += particle[2];

      // Advance in the y direction.
      particle[3] *= .98;
      particle[1] += particle[3];

      // Draw the particle.
      canvas.drawOval(
        Rect.fromLTWH(
          particle[0],
          particle[1],
          particleRadius,
          particleRadius,
        ),
        Paint()..color = color,
      );
    }

    // Remote particles that have reached the destination
    _particles.removeWhere((particle) {
      return particle[4] < blackHoleRadius;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    /// Repaints should only be triggered by the time.
    /// Whether this is true or false does not matter at all.
    return false;
  }
}

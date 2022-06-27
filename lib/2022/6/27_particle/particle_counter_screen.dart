import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

const loadPercentage = 0.045;
const countMultiplier = 1;
const closeEnoughTarget = 50.0;
const particleSize = 8.0;
const speed = 1;
const touchSize = 100;

class ParticleCounterScreen extends StatefulWidget {
  const ParticleCounterScreen({Key? key}) : super(key: key);

  @override
  State<ParticleCounterScreen> createState() => _ParticleCounterScreenState();
}

class _ParticleCounterScreenState extends State<ParticleCounterScreen> {
  int _count = 0;

  void _incrementCount() {
    setState(() {
      _count++;
    });
  }

  String getAssetName(int i) {
    final n = i < 10 ? '0$i' : '$i';
    return "assets/images/people/people$n.jpg";
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
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ParticleImageSwitcher(
                  imagePaths: [for (int i = 1; i < 47; i++) getAssetName(i)],
                  imageIndex: _count % 46,
                  size: constraints.biggest,
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 100,
            child: CounterText(count: _count),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCount,
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ParticleImageSwitcher extends StatefulWidget {
  const ParticleImageSwitcher({
    Key? key,
    required this.imagePaths,
    required this.imageIndex,
    required this.size,
  }) : super(key: key);

  final List<String> imagePaths;
  final int imageIndex;
  final Size size;

  @override
  State<ParticleImageSwitcher> createState() => _ParticleImageSwitcherState();
}

class _ParticleImageSwitcherState extends State<ParticleImageSwitcher>
    with SingleTickerProviderStateMixin {
  final List<Particle> particles = <Particle>[];
  final List<Future<Pixels>> allPixels = <Future<Pixels>>[];
  final List<VoidCallback> onDispose = <VoidCallback>[];
  final TouchPointer touchPointer = TouchPointer();

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    for (var i = 0; i < widget.imagePaths.length; i++) {
      allPixels.add(loadPixels(widget.imagePaths[i]));
    }
    showParticles(0);
  }

  @override
  void didUpdateWidget(covariant ParticleImageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageIndex != widget.imageIndex) {
      showParticles(widget.imageIndex);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    for (var x in onDispose) {
      x();
    }
    super.dispose();
  }

  Future<Pixels> loadPixels(String imagePath) async {
    final provider = ExactAssetImage(imagePath);
    final imageStream = provider.resolve(ImageConfiguration.empty);
    final completer = Completer<ui.Image>();
    late ImageStreamListener imageStreamListener;
    imageStreamListener = ImageStreamListener((frame, _) {
      completer.complete(frame.image);
      imageStream.removeListener(imageStreamListener);
    });
    imageStream.addListener(imageStreamListener);
    final image = await completer.future;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    onDispose.add(() => image.dispose());
    return Pixels(
      byteData: byteData!,
      width: image.width,
      height: image.height,
    );
  }

  Future<void> showParticles(int index) async {
    final pixels = await allPixels[index];
    final particleIndices = List<int>.generate(particles.length, (i) => i);
    final width = widget.size.width;
    final height = widget.size.height;
    final halfWidth = width / 2;
    final halfHeight = height / 2;
    final halfImageWidth = pixels.width / 2;
    final halfImageHeight = pixels.height / 2;
    final tx = halfWidth - halfImageWidth;
    final ty = halfHeight - halfImageHeight;

    for (var y = 0; y < pixels.height; y++) {
      for (var x = 0; x < pixels.width; x++) {
        // Give it small odds that we'll assign a particle to this pixel.
        if (randNextD(1) > loadPercentage * countMultiplier) {
          continue;
        }

        final pixelColor = pixels.getColorAt(x, y);
        Particle newParticle;
        if (particleIndices.isNotEmpty) {
          // Re-use existing particles.
          final index = particleIndices.length == 1
              ? particleIndices.removeAt(0)
              : particleIndices.removeAt(randI(0, particleIndices.length - 1));
          newParticle = particles[index];
        } else {
          // Create a new particle.
          newParticle = Particle(halfWidth, halfHeight);
          particles.add(newParticle);
        }

        newParticle.target.x = x + tx;
        newParticle.target.y = y + ty;
        newParticle.endColor = pixelColor;
      }
    }

    // Kill off any left over particles that aren't assigned to anything.
    if (particleIndices.isNotEmpty) {
      for (var i = 0; i < particleIndices.length; i++) {
        particles[particleIndices[i]].kill(width, height);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TouchDetector(
      touchPointer: touchPointer,
      child: CustomPaint(
        painter: ParticulesPainter(
          animation: controller,
          particles: particles,
          pointer: touchPointer,
        ),
      ),
    );
  }
}

class ParticulesPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Particle> particles;
  final TouchPointer pointer;

  const ParticulesPainter({
    required this.animation,
    required this.particles,
    required this.pointer,
  }) : super(repaint: animation);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final width = size.width;
    final height = size.height;

    for (var i = particles.length - 1; i >= 0; i--) {
      final particle = particles[i];
      particle.move(pointer.offset);

      final color = particle.currentColor;
      particle.currentColor = Color.lerp(
          particle.currentColor, particle.endColor, particle.colorBlendRate)!;
      double targetSize = 2;
      if (!particle.isKilled) {
        targetSize = map(
          min(particle.distToTarget, closeEnoughTarget),
          closeEnoughTarget,
          0,
          0,
          particleSize,
        );
      }

      particle.currentSize =
          ui.lerpDouble(particle.currentSize, targetSize, 0.1)!;

      final center = Offset(particle.pos.x, particle.pos.y);
      canvas.drawCircle(center, particle.currentSize, Paint()..color = color);

      if (particle.isKilled) {
        if (particle.pos.x < 0 ||
            particle.pos.x > width ||
            particle.pos.y < 0 ||
            particle.pos.y > height) {
          particles.removeAt(i);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TouchPointer {
  TouchPointer({
    this.offset,
  });

  Offset? offset;
}

class TouchDetector extends StatelessWidget {
  const TouchDetector({
    Key? key,
    required this.touchPointer,
    required this.child,
  }) : super(key: key);

  final TouchPointer touchPointer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) => touchPointer.offset = details.localFocalPoint,
      onScaleUpdate: (details) => touchPointer.offset = details.localFocalPoint,
      onScaleEnd: (details) => touchPointer.offset = null,
      child: child,
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You have pushed the button this many times:",
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  foreground: Paint()
                    ..blendMode = ui.BlendMode.difference
                    ..color = Colors.white,
                ),
          ),
          Text(
            "$count",
            style: Theme.of(context).textTheme.headline2?.copyWith(
                  foreground: Paint()
                    ..blendMode = ui.BlendMode.difference
                    ..color = Colors.white,
                ),
          )
        ],
      ),
    );
  }
}

double map(double x, double minIn, double maxIn, double minOut, double maxOut) {
  return (x - minIn) * (maxOut - minOut) / (maxIn - minIn) + minOut;
}

final Random _random = Random();

double randNextD(double max) => _random.nextDouble() * max;
int randNextI(int max) => _random.nextInt(max);
double randD(double min, double max) => _random.d(min, max);
int randI(int min, int max) => _random.i(min, max);

extension RandomX on Random {
  double d(double min, double max) {
    return nextDouble() * (max - min) + min;
  }

  int i(int min, int max) {
    return nextInt(max - min) + min;
  }
}

class Particle {
  Particle(this.x, this.y)
      : pos = Vector2(x, y),
        maxSpeed = randD(0.25, 2),
        maxForce = randD(8, 15),
        colorBlendRate = randD(0.01, 0.05);

  final double x;
  final double y;
  final Vector2 pos;
  final double maxSpeed; // How fast it can move per frame.
  final double maxForce; // Its speed limit.
  final double colorBlendRate;

  Vector2 vel = Vector2.zero();
  Vector2 acc = Vector2.zero();
  Vector2 target = Vector2.zero();
  bool isKilled = false;
  Color currentColor = const Color(0x00000000);
  Color endColor = const Color(0x00000000);
  double currentSize = 0;
  double distToTarget = 0;

  void move([Offset? touchPosition]) {
    distToTarget = pos.distanceTo(target);

    double proximityMult;

    // If it's close enough to its target, the slower it'll get
    // so that it can settle
    if (distToTarget < closeEnoughTarget) {
      proximityMult = distToTarget / closeEnoughTarget;
      vel *= 0.9;
    } else {
      proximityMult = 1;
      vel *= 0.95;
    }

    // Steer towards its target.
    if (distToTarget > 1) {
      final steer = target.clone()
        ..sub(pos)
        ..normalize()
        ..scale(maxSpeed * proximityMult * speed);

      acc.add(steer);
    }

    if (touchPosition != null) {
      final touch = Vector2(touchPosition.dx, touchPosition.dy);
      final distToTouch = pos.distanceTo(touch);
      if (distToTouch < touchSize) {
        final push = pos.clone()..sub(touch);
        push.normalize();
        push.scale((touchSize - distToTouch) * 0.05);
        acc.add(push);
      }
    }

    vel.add(acc);
    vel.limit(maxForce * speed);
    pos.add(vel);
    acc.scale(0);
  }

  void kill(double width, double height) {
    if (!isKilled) {
      target = generateRandomPos(
          width / 2, height / 2, max(width, height), width, height);
      endColor = const Color(0x00000000);
      isKilled = true;
    }
  }
}

Vector2 generateRandomPos(
    double x, double y, double mag, double width, double height) {
  final pos = Vector2(x, y);
  final vel = Vector2(randD(0, width), randD(0, height));
  vel.sub(pos);
  vel.normalize();
  vel.scale(mag);
  pos.add(vel);

  return pos;
}

extension VectorX on Vector2 {
  void limit(double max) {
    if (length2 > max * max) {
      normalize();
      scale(max);
    }
  }
}

class Pixels {
  const Pixels({
    required this.byteData,
    required this.width,
    required this.height,
  });

  final ByteData byteData;
  final int width;
  final int height;

  Color getColorAt(int x, int y) {
    final offset = 4 * (x + y * width);
    final rgba = byteData.getUint32(offset);
    final a = rgba & 0xFF;
    final rgb = rgba >> 8;
    final argb = (a << 24) + rgb;
    return ui.Color(argb);
  }
}

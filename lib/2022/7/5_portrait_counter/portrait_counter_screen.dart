import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:daily_ui/2022/6/27_particle/particle_counter_screen.dart';

class PortraitCounterScreen extends StatefulWidget {
  const PortraitCounterScreen({super.key});

  @override
  State<PortraitCounterScreen> createState() => _PortraitCounterScreenState();
}

class _PortraitCounterScreenState extends State<PortraitCounterScreen> {
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: [
          Portrait(
            assetName: "assets/images/people/people01.jpg",
            count: _count,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: CounterText(count: _count),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Portrait extends StatefulWidget {
  const Portrait({
    super.key,
    required this.assetName,
    required this.count,
  });

  final String assetName;
  final int count;

  @override
  State<Portrait> createState() => _PortraitState();
}

class _PortraitState extends State<Portrait> {
  final math.Random random = math.Random();
  ui.Image? image;
  ByteData? byteData;

  @override
  void initState() {
    super.initState();
    loadPixels();
  }

  @override
  void dispose() {
    image?.dispose();
    super.dispose();
  }

  Future<void> loadPixels() async {
    image?.dispose();
    // final provider = ExactAssetImage(widget.assetName);
    const provider = NetworkImage(
        "https://stakeholderdoce.files.wordpress.com/2014/11/obey2.png");
    final imageStream = provider.resolve(ImageConfiguration.empty);
    final completer = Completer<ui.Image>();
    late ImageStreamListener imageStreamListener;
    imageStreamListener = ImageStreamListener((frame, _) {
      completer.complete(frame.image);
      imageStream.removeListener(imageStreamListener);
    });
    imageStream.addListener(imageStreamListener);
    image = await completer.future;
    byteData = await image?.toByteData(format: ui.ImageByteFormat.rawRgba);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final child = image == null
        ? const SizedBox.expand()
        : Stack(
            fit: StackFit.expand,
            children: [
              for (var i = 0; i < widget.count; i++)
                PortraitPaint(
                  imageWidth: image!.width,
                  imageHeight: image!.height,
                  byteData: byteData!,
                  random: random,
                  count: i,
                )
            ],
          );
    return Positioned.fill(child: child);
  }
}

class PortraitPaint extends StatelessWidget {
  const PortraitPaint({
    super.key,
    required this.imageWidth,
    required this.imageHeight,
    required this.byteData,
    required this.random,
    required this.count,
  });

  final int imageWidth;
  final int imageHeight;
  final ByteData byteData;
  final math.Random random;
  final int count;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: PortraitPainter(
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          byteData: byteData,
          random: random,
          count: count,
        ),
      ),
    );
  }
}

class PortraitPainter extends CustomPainter {
  final int imageWidth;
  final int imageHeight;
  final ByteData byteData;
  final math.Random random;
  final int count;
  final Pixels pixels;

  PortraitPainter({
    required this.imageWidth,
    required this.imageHeight,
    required this.byteData,
    required this.random,
    required this.count,
  }) : pixels = Pixels(
          byteData: byteData,
          width: imageWidth,
          height: imageHeight,
        );

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final width = size.width;
    final height = size.height;
    final tdx = (width - imageWidth) / 2;
    final tdy = (height - imageHeight) / 2;

    void curve(
      double x1,
      double y1,
      double x2,
      double y2,
      double x3,
      double y3,
      double x4,
      double y4,
      double thickness,
      Color color,
    ) {
      final vertices = [
        ui.Offset(x1, y1),
        ui.Offset(x2, y2),
        ui.Offset(x3, y3),
        ui.Offset(x4, y4),
      ];
      final path = Path();
      path.moveTo(x2, y2);
      for (var i = 1; i + 2 < vertices.length; i++) {
        final v = vertices[i];
        final b = List<Offset>.filled(4, Offset.zero);
        b[0] = v;
        b[1] = v + (vertices[i + 1] - vertices[i - 1]) / 3;
        b[2] = vertices[i + 1] + (v - vertices[i + 2]) / 6;
        b[3] = vertices[i + 1];
        path.cubicTo(b[1].dx, b[1].dy, b[2].dx, b[2].dy, b[3].dx, b[3].dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = thickness
          ..color = color,
      );
    }

    void paintStroke(double length, Color color, int thickness) {
      final stepLength = length / 4;

      // Determines if the stroke is curved. A straight line is 0.
      double tangent1 = 0;
      double tangent2 = 0;

      final odds = random.nextDouble();

      if (odds < 0.7) {
        tangent1 = random.d(-length, length);
        tangent2 = random.d(-length, length);
      }

      curve(
        tangent1,
        -stepLength * 2,
        0,
        -stepLength,
        0,
        stepLength,
        tangent2,
        stepLength * 2,
        thickness.toDouble(),
        color,
      );
    }

    for (var y = 0; y < imageHeight; y++) {
      for (var x = 0; x < imageWidth; x++) {
        final odds = random.d(0, 2000).toInt();

        if (odds < 1) {
          final color = pixels.getColorAt(x, y).withAlpha(100);
          final tx = x + tdx;
          final ty = y + tdy;
          canvas.translate(tx, ty);

          if (count < 20) {
            paintStroke(random.d(150, 250), color, random.d(20, 40).toInt());
          } else if (count < 50) {
            paintStroke(random.d(75, 125), color, random.d(8, 12).toInt());
          } else if (count < 300) {
            paintStroke(random.d(30, 60), color, random.d(1, 4).toInt());
          } else if (count < 500) {
            paintStroke(random.d(5, 20), color, random.d(5, 15).toInt());
          } else {
            paintStroke(random.d(1, 10), color, random.d(1, 7).toInt());
          }

          canvas.translate(-tx, -ty);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Pixels {
  final ByteData byteData;
  final int width;
  final int height;

  const Pixels({
    required this.byteData,
    required this.width,
    required this.height,
  });

  ui.Color getColorAt(int x, int y) {
    final offset = 4 * (x + width * y);
    final rgba = byteData.getUint32(offset);
    final a = rgba & 0xFF;
    final rgb = rgba >> 8;
    final argb = (a << 24) + rgb;
    return ui.Color(argb);
  }
}

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BackgroundShaderScreen extends StatefulWidget {
  const BackgroundShaderScreen({Key? key}) : super(key: key);

  @override
  State<BackgroundShaderScreen> createState() => _BackgroundShaderScreenState();
}

class _BackgroundShaderScreenState extends State<BackgroundShaderScreen> {
  ui.Image? _image;

  final _offsets = <Offset>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _loadImage();
      });
    });
  }

  Future<void> _loadImage() async {
    final size = MediaQuery.of(context).size;
    _image = await ToImageConverter(canvasSize: size.width).convert();
    print(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconTheme.of(context),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: BackgroundShaderPainter(
              image: _image,
              offsets: _offsets,
            ),
          ),
          GestureDetector(
            onScaleStart: (details) {
              setState(() {
                _offsets.clear();
                _offsets.add(details.localFocalPoint);
              });
            },
            onScaleUpdate: (details) {
              setState(() {
                _offsets.add(details.localFocalPoint);
              });
            },
            onScaleEnd: (details) {
              setState(() {
                _offsets.clear();
              });
            },
          ),
        ],
      ),
    );
  }
}

class BackgroundShaderPainter extends CustomPainter {
  static final double devicePixelRatio = ui.window.devicePixelRatio;

  final ui.Image? image;
  final List<Offset> offsets;

  BackgroundShaderPainter({
    required this.image,
    required this.offsets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Float64List deviceTransform = Float64List(16)
      ..[0] = devicePixelRatio
      ..[5] = devicePixelRatio
      ..[10] = 1.0
      ..[15] = 2.0;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = image == null
          ? null
          : ImageShader(image!, TileMode.clamp, TileMode.clamp, deviceTransform)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 40.2;

    final path = Path();

    if (offsets.isEmpty) {
      return;
    }

    path.moveTo(offsets[0].dx, offsets[0].dy);

    for (final offset in offsets) {
      path.lineTo(offset.dx, offset.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ToImageConverter {
  const ToImageConverter({
    required this.canvasSize,
  });

  final double canvasSize;

  Future<ui.Image> convert() async {
    final picture = GradientToPictureConverter.convert(
      canvasSize: canvasSize,
    );

    final image = await picture.toImage(
      canvasSize.toInt(),
      canvasSize.toInt(),
    );

    return image;
  }
}

class GradientToPictureConverter {
  static ui.Picture convert({
    required double canvasSize,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0.0, 0.0), Offset(canvasSize, canvasSize)),
    );

    final Paint paint = Paint()
      // ..shader = ui.Gradient.linear(
      //   const ui.Offset(0, 0),
      //   ui.Offset(0, canvasSize),
      //   [
      //     Colors.yellow,
      //     Colors.amber,
      //     Colors.orange,
      //     Colors.red,
      //   ],
      // );
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.yellow,
          Colors.amber,
          Colors.orange,
          Colors.red,
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, canvasSize, canvasSize),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize, canvasSize), paint);

    return recorder.endRecording();
  }
}

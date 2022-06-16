import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:daily_ui/2022/6/16_led_effect/to_pixels_converter.dart';

const _canvasSize = 100.0;

class DisplaySimulator extends StatefulWidget {
  const DisplaySimulator({
    Key? key,
    required this.text,
    this.debug = false,
    this.border = false,
  }) : super(key: key);

  final String text;
  final bool debug;
  final bool border;

  @override
  State<DisplaySimulator> createState() => _DisplaySimulatorState();
}

class _DisplaySimulatorState extends State<DisplaySimulator> {
  ByteData? imageBytes;
  List<List<Color>> pixels = [];

  Future<void> _obtainPixelsFromText(String text) async {
    ToPixelsConversionResult result = await ToPixelsConverter.fromString(
      string: text,
      canvasSize: _canvasSize,
      border: widget.border,
    ).convert();

    setState(() {
      print("setstate");
      imageBytes = result.imageBytes;
      pixels = result.pixels;
    });
  }

  @override
  void initState() {
    super.initState();
    _obtainPixelsFromText(widget.text);
  }

  @override
  void didUpdateWidget(covariant DisplaySimulator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      print("different");
      _obtainPixelsFromText(widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Column(
      children: [
        const SizedBox(height: 96),
        _getDebugPreview(),
        const SizedBox(height: 48),
        _getDisplay(),
      ],
    );
  }

  Widget _getDebugPreview() {
    if (imageBytes == null || widget.debug == false) {
      return Container();
    }

    return Image.memory(
      Uint8List.view(imageBytes!.buffer),
      gaplessPlayback: true,
      filterQuality: FilterQuality.none,
      width: _canvasSize,
      height: _canvasSize,
    );
  }

  Widget _getDisplay() {
    if (pixels.isEmpty) {
      return Container();
    }

    return CustomPaint(
      size: Size.square(MediaQuery.of(context).size.width),
      painter: DisplayPainter(
        pixels: pixels,
        canvasSize: _canvasSize,
      ),
    );
  }
}

class DisplayPainter extends CustomPainter {
  const DisplayPainter({
    required this.pixels,
    required this.canvasSize,
  });

  final List<List<Color>> pixels;
  final double canvasSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (pixels.isEmpty) {
      return;
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );

    double widthFactor = canvasSize / size.width;

    Paint rectPaint = Paint()..color = Colors.black;
    Paint circlePaint = Paint()..color = Colors.yellow;

    for (var i = 0; i < pixels.length; i++) {
      for (var j = 0; j < pixels[i].length; j++) {
        var rectSize = 1.0 / widthFactor;
        var circleSize = 0.3 / widthFactor;

        canvas.drawRect(
          Rect.fromCenter(
              center: Offset(i.toDouble() * rectSize + rectSize / 2,
                  j.toDouble() * rectSize + rectSize / 2),
              width: rectSize,
              height: rectSize),
          rectPaint,
        );

        if (pixels[i][j].opacity < 0.3) {
          continue;
        }

        canvas.drawCircle(
          Offset(
            i.toDouble() * rectSize + rectSize / 2 - circleSize / 2,
            j.toDouble() * rectSize + rectSize / 2 - circleSize / 2,
          ),
          circleSize,
          circlePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

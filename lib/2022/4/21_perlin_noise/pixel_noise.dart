import 'dart:math';

import 'package:flutter/material.dart';

class PixelNoise extends StatefulWidget {
  const PixelNoise({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  State<PixelNoise> createState() => _PixelNoiseState();
}

class _PixelNoiseState extends State<PixelNoise> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
      ),
      child: CustomPaint(
        painter: NoisePainter(),
        child: const SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class NoisePainter extends CustomPainter {
  final Color color;
  final double pixelSize; // area to color in
  late double blockSize; // block for each pixel to create surrounding border

  NoisePainter({
    this.color = Colors.white,
    this.pixelSize = 18,
  }) {
    blockSize = pixelSize * 1.4;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Random random = Random();
    final painting = Paint()..style = PaintingStyle.fill;
    for (var x = 0.0; x < size.width / blockSize; x++) {
      for (var y = 0.0; y < size.height / blockSize; y++) {
        var rgb = random.nextInt(255);
        canvas.drawRect(
          Rect.fromLTWH(x * blockSize, y * blockSize, pixelSize, pixelSize),
          painting
            ..color = color.withAlpha(
              rgb.floor(),
            ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

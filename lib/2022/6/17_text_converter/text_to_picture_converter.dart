import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TextToPictureConverter {
  static ui.Picture convert({
    required String text,
    required double canvasSize,
    required bool border,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      ui.Rect.fromLTWH(0, 0, canvasSize, canvasSize),
    );

    const ui.Color color = Color.fromRGBO(255, 255, 255, 1);

    if (border) {
      final paint = ui.Paint()
        ..color = color
        ..style = ui.PaintingStyle.stroke;

      canvas.drawRect(ui.Rect.fromLTWH(0, 0, canvasSize, canvasSize), paint);
    }

    final span = TextSpan(
      text: text,
      style: const TextStyle(
        fontFamily: "Monospace",
        color: color,
        fontSize: 24,
      ),
    );

    final tp = TextPainter(
      text: span,
      textAlign: ui.TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );

    final offset = Offset(
      (canvasSize - tp.width) * 0.5,
      (canvasSize - tp.height) * 0.5,
    );

    tp.paint(canvas, offset);

    return recorder.endRecording();
  }
}

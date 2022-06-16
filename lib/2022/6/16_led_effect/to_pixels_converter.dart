// result of conversion
import 'dart:ui' as ui;

import 'package:daily_ui/2022/6/16_led_effect/text_to_picture_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

/// conversion result
class ToPixelsConversionResult {
  const ToPixelsConversionResult({
    required this.imageBytes,
    required this.pixels,
  });

  final ByteData imageBytes;
  final List<List<ui.Color>> pixels;
}

/// converter from string to pixels
class ToPixelsConverter {
  final String string;
  final double canvasSize;
  bool border;

  ui.Canvas? canvas;

  ToPixelsConverter.fromString({
    required this.string,
    required this.canvasSize,
    this.border = false,
  });

  Future<ToPixelsConversionResult> convert() async {
    final ui.Picture picture = TextToPictureConverter.convert(
      text: string,
      canvasSize: canvasSize,
      border: border,
    );

    final ByteData imageBytes = await _pictureToBytes(picture);
    final List<List<ui.Color>> pixels = _bytesToPixelArray(imageBytes);

    return ToPixelsConversionResult(
      imageBytes: imageBytes,
      pixels: pixels,
    );
  }

  Future<ByteData> _pictureToBytes(ui.Picture picture) async {
    final ui.Image img =
        await picture.toImage(canvasSize.toInt(), canvasSize.toInt());
    return (await img.toByteData(format: ui.ImageByteFormat.png))!;
  }

  List<List<ui.Color>> _bytesToPixelArray(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    image.Image decodedImage = image.decodeImage(values)!;
    List<List<ui.Color>> pixelArray = List.generate(
      canvasSize.toInt(),
      (_) => List.generate(canvasSize.toInt(), (_) => Colors.black),
    );

    for (int i = 0; i < canvasSize.toInt(); i++) {
      for (int j = 0; j < canvasSize.toInt(); j++) {
        int pixel = decodedImage.getPixelSafe(i, j);
        int hex = _convertColorSpace(pixel);
        pixelArray[i][j] = Color(hex);
      }
    }

    return pixelArray;
  }

  int _convertColorSpace(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}

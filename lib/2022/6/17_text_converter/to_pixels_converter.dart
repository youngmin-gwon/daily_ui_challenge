import 'dart:ui' as ui;
import 'package:image/image.dart' as image;

import 'package:daily_ui/2022/6/17_text_converter/text_to_picture_converter.dart';
import 'package:flutter/services.dart';

class ToPixelsConversionResult {
  final ByteData bytes;
  final List<List<ui.Color>> pixels;

  const ToPixelsConversionResult({
    required this.bytes,
    required this.pixels,
  });
}

class ToPixelsConverter {
  const ToPixelsConverter({
    required this.string,
    required this.canvasSize,
    required this.border,
  });

  final String string;
  final double canvasSize;
  final bool border;

  Future<ToPixelsConversionResult> convert() async {
    final picture = TextToPictureConverter.convert(
      text: string,
      canvasSize: canvasSize,
      border: border,
    );

    final bytes = await _pictureToBytes(picture);
    final pixels = _bytesToPixelArray(bytes);

    return ToPixelsConversionResult(
      bytes: bytes,
      pixels: pixels,
    );
  }

  Future<ByteData> _pictureToBytes(ui.Picture picture) async {
    final image = await picture.toImage(
      canvasSize.toInt(),
      canvasSize.toInt(),
    );

    return (await image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!;
  }

  List<List<ui.Color>> _bytesToPixelArray(ByteData bytes) {
    List<int> values = bytes.buffer.asUint8List();
    image.Image decodedImage = image.decodeImage(values)!;
    List<List<ui.Color>> pixelArray = List.generate(
      canvasSize.toInt(),
      (_) =>
          List.generate(canvasSize.toInt(), (_) => const ui.Color(0xFFFFFFFF)),
    );

    for (int i = 0; i < canvasSize.toInt(); i++) {
      for (int j = 0; j < canvasSize.toInt(); j++) {
        int pixel = decodedImage.getPixelSafe(i, j);
        int hex = _convertColorSpace(pixel);
        pixelArray[i][j] = ui.Color(hex);
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

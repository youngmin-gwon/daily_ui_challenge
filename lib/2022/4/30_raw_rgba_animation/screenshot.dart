import 'dart:ui' as ui;
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_point_notifier.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_point_scope.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_settings.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_setttings_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ScreenShot extends StatefulWidget {
  const ScreenShot({Key? key}) : super(key: key);

  @override
  State<ScreenShot> createState() => _ScreenShotState();
}

class _ScreenShotState extends State<ScreenShot> {
  final GlobalKey _globalKey = GlobalKey();
  final points = <Point>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _setArray();
    });
  }

  Future<void> _setArray() async {
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        try {
          RenderRepaintBoundary boundary = _globalKey.currentContext!
              .findRenderObject() as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 1);
          final width = image.width;
          final height = image.height;

          final byteData = await image.toByteData() as ByteData;
          final pngBytes = byteData.buffer.asUint16List();

          // [step] is how manay pixel we stop forward, cannot be 0;
          final resolution = RgbaSettingsScope.of(context).resolution;
          final speed = RgbaSettingsScope.of(context).speed;
          var step = kMax.round() - resolution + 1;
          for (var y = 3; y < height; y += step) {
            for (var x = 0; x < width; x += step) {
              var index = 4 * (y * width + x) + 3;

              if (index > pngBytes.length) {
                break;
              }

              if (pngBytes[index] != 0) {
                points.add(
                  Point(
                    offset: Offset(
                      x.toDouble(),
                      y.toDouble(),
                    ),
                    alfa: pngBytes[index],
                    speed: speed,
                  ),
                );
              }
            }
          }
          RgbaPointScope.of(context).setIsReady(true);
          RgbaPointScope.of(context).setPoints(points);
        } catch (e) {
          print(e);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 150),
            const SizedBox(height: 30),
            Text(
              RgbaSettingsScope.of(context).text,
              style: const TextStyle(fontSize: 55),
            ),
          ],
        ),
      ),
    );
  }
}

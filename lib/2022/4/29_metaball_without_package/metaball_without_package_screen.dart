import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MetaballWithoutPackageScreen extends StatefulWidget {
  const MetaballWithoutPackageScreen({Key? key}) : super(key: key);

  @override
  State<MetaballWithoutPackageScreen> createState() =>
      _MetaballWithoutPackageScreenState();
}

class _MetaballWithoutPackageScreenState
    extends State<MetaballWithoutPackageScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Size size = Size.zero;

  final blobCount = 6;
  final double blobVelocity = 10;

  final random = math.Random();

  final List<Blob> _blobs = [];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      size = MediaQuery.of(context).size;
      for (var i = 0; i < blobCount; i++) {
        _blobs.add(
          Blob(
            offset: Offset(
              size.width * random.nextDouble(),
              size.height * random.nextDouble(),
            ),
            velocity: Offset.fromDirection(
              2 * math.pi * random.nextDouble(),
              blobVelocity,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsedTime) {
    setState(() {
      for (var blob in _blobs) {
        blob.move(size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: CustomPaint(
          painter: MetaballPainter(
            blobs: _blobs,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class MetaballPainter extends CustomPainter {
  MetaballPainter({
    required this.blobs,
  });

  final List<Blob> blobs;
  final List<Color> _colors = [];
  final List<double> _stops = [];
  static const _shaderResolution = 0x1ffe;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.longestSide / 2;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = const Color(0xFF000000)
        ..blendMode = ui.BlendMode.srcOver,
    );

    if (_colors.isEmpty) {
      assert(_stops.isEmpty);
      _colors.addAll(
        [
          for (var i = _shaderResolution; i >= 0; i--)
            Color.fromRGBO(
              0xff,
              0xff,
              0xff,
              const Cubic(1, 1, 0, 1)
                  .transform(math.pow(i / _shaderResolution, 2).toDouble()),
            ),
        ],
      );

      _stops.addAll(
        [
          for (var i = 0; i < _shaderResolution + 1; i++)
            math.pow(i / _shaderResolution, 2).toDouble(),
        ],
      );
    }

    if (blobs.isNotEmpty) {
      for (var blob in blobs) {
        final shader = ui.Gradient.radial(
          blob.offset,
          radius,
          _colors,
          _stops,
        );
        canvas.drawCircle(
          blob.offset,
          radius,
          Paint()
            ..shader = shader
            // BlendMode.plus: 색을 서로 합침
            ..blendMode = ui.BlendMode.plus,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Blob {
  Offset _offset;
  Offset _velocity;

  Blob({
    required Offset offset,
    required Offset velocity,
  })  : _offset = offset,
        _velocity = velocity;

  Offset get offset => _offset;
  Offset get velocity => _velocity;

  void move(Size screenSize) {
    if (_offset.dx <= 0 || _offset.dx >= screenSize.width) {
      _velocity = Offset(-_velocity.dx, _velocity.dy);
    }

    if (_offset.dy <= 0 || _offset.dy >= screenSize.height) {
      _velocity = Offset(_velocity.dx, -_velocity.dy);
    }

    _offset += _velocity;
  }
}

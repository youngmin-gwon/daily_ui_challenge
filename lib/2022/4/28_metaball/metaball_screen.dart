import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';

class MetaballScreen extends StatelessWidget {
  const MetaballScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: SizedBox.expand(
        child: FunvasContainer(
          funvas: Metaball(),
        ),
      ),
    );
  }
}

class Metaball extends Funvas {
  static const _blobCount = 6, _blobSpeed = 5.0;

  // * 0111111111111 (dec: 8191, hex: 1fff),
  // * 1000000000000 (dec: 8192, hex: 2000),
  static const _shaderResolution = 8000;

  final _blobs = <Blob>[];
  final _colors = <Color>[];
  final _stops = <double>[];

  @override
  void u(double t) {
    final size = s2q(750);
    c.drawColor(const Color(0xFF000000), BlendMode.srcOver);

    if (_blobs.isEmpty) {
      final random = math.Random(4269);
      for (var i = 0; i < _blobCount; i++) {
        _blobs.add(
          Blob(
            offset: Offset(
              random.nextDouble() * size.width,
              random.nextDouble() * size.height,
            ),
            velocity: Offset.fromDirection(
              random.nextDouble() * 2 * math.pi,
              _blobSpeed,
            ),
          ),
        );
      }
    }

    if (_colors.isEmpty) {
      assert(_stops.isEmpty);
      _colors.addAll([
        for (var i = _shaderResolution; i >= 0; i--)
          Color.fromRGBO(
            0xFF,
            0xFF,
            0xFF,
            const Cubic(1, 1, 0, 1)
                .transform(math.pow(i / _shaderResolution, 2).toDouble()),
          ),
      ]);

      _stops.addAll(
        [
          for (var i = 0; i < _shaderResolution + 1; i++)
            math.pow(i / _shaderResolution, 2).toDouble(),
        ],
      );
    }

    for (final blob in _blobs) {
      final shader = ui.Gradient.radial(
        blob.offset,
        size.longestSide,
        _colors,
        _stops,
      );

      c.drawPaint(
        Paint()
          ..shader = shader
          ..blendMode = ui.BlendMode.plus,
      );
    }

    for (final blob in _blobs) {
      blob.move(size);
    }
  }
}

class Blob {
  Blob({
    required Offset offset,
    required Offset velocity,
  })  : _offset = offset,
        _velocity = velocity;

  Offset _offset;
  Offset _velocity;

  Offset get offset => _offset;

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

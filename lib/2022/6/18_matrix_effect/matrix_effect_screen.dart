import 'package:flutter/material.dart';

class MatrixEffectScreen extends StatefulWidget {
  const MatrixEffectScreen({Key? key}) : super(key: key);

  @override
  State<MatrixEffectScreen> createState() => _MatrixEffectScreenState();
}

class _MatrixEffectScreenState extends State<MatrixEffectScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: VerticalTextLine(),
      ),
    );
  }
}

class VerticalTextLine extends StatefulWidget {
  const VerticalTextLine({
    Key? key,
    this.speed = 12.0,
    this.maxLength = 10,
  }) : super(key: key);

  final double speed;
  final int maxLength;

  @override
  State<VerticalTextLine> createState() => _VerticalTextLineState();
}

class _VerticalTextLineState extends State<VerticalTextLine> {
  List<String> _characters = ["T", "E", "S", "T"];

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.transparent,
      Colors.green,
      Colors.green,
      Colors.white
    ];

    double greenStart;
    double whiteStart = (_characters.length - 1) / (_characters.length);

    if (((_characters.length - widget.maxLength) / _characters.length) < 0.3) {
      greenStart = 0.3;
    } else {
      greenStart = (_characters.length - widget.maxLength) / _characters.length;
    }

    List<double> stops = [0, greenStart, whiteStart, whiteStart];

    return _getShaderMask(stops, colors);
  }

  Widget _getShaderMask(List<double> stops, List<Color> colors) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: stops,
          colors: colors,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _getCharacters(),
      ),
    );
  }

  List<Widget> _getCharacters() {
    List<Widget> textWidgets = [];

    for (final character in _characters) {
      textWidgets.add(
        Text(
          character,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }

    return textWidgets;
  }
}

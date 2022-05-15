import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CylinderAnimationScreen extends StatelessWidget {
  const CylinderAnimationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: const CylinderPolygon(),
    );
  }
}

class CylinderPolygon extends StatefulWidget {
  const CylinderPolygon({
    Key? key,
    this.face = 36,
    this.radius = 100,
    this.height = 300,
  }) : super(key: key);

  final int face;
  final double radius;
  final double height;

  @override
  State<CylinderPolygon> createState() => _CylinderPolygonState();
}

class _CylinderPolygonState extends State<CylinderPolygon> {
  double _angleY = 0;
  double _faceWidth = 0;

  @override
  void initState() {
    super.initState();

    /// equation using right triangle law: x = 2*r * tan(theta/2)
    _faceWidth = 2 * widget.radius * math.tan((2 * math.pi / widget.face) / 2);

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final image = await rootBundle.load("assets/images/campbell_label.jpg");
        var decodedImage =
            await decodeImageFromList(image.buffer.asUint8List());
        print("image width: ${decodedImage.width}");
        print("image height: ${decodedImage.height}");
      },
    );
  }

  void _rotateBox(Offset offset) {
    setState(() {
      _angleY += offset.dx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(widget.face, (index) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(0.02 * _angleY + 2 * math.pi * index / widget.face)
            ..translate(widget.radius),
          alignment: Alignment.center,
          child: Transform(
            transform: Matrix4.identity()..rotateY(math.pi / 2),
            alignment: Alignment.center,
            child: SizedBox(
              width: _faceWidth,
              height: widget.height,
              child: const PolygonWidget(),
            ),
          ),
        );
      })
        ..add(
          GestureDetector(
            onPanUpdate: (details) {
              _rotateBox(details.delta);
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
    );
  }
}

class PolygonWidget extends StatelessWidget {
  const PolygonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 4,
        ),
      ),
    );
  }
}

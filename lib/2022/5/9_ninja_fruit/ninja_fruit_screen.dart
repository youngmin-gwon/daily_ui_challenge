import 'package:daily_ui/2022/5/9_ninja_fruit/models/fruit.dart';
import 'package:daily_ui/2022/5/9_ninja_fruit/models/touch_slice.dart';
import 'package:flutter/material.dart';

class NinjaFruitScreen extends StatefulWidget {
  const NinjaFruitScreen({Key? key}) : super(key: key);

  @override
  State<NinjaFruitScreen> createState() => _NinjaFruitScreenState();
}

class _NinjaFruitScreenState extends State<NinjaFruitScreen> {
  TouchSlice? touchSlice;
  final List<Fruit> fruits = [];

  @override
  void initState() {
    super.initState();
    fruits.add(
      const Fruit(
        position: Offset(100, 100),
        width: 80,
        height: 80,
      ),
    );
  }

  void _setNewSlice(ScaleStartDetails details) {
    touchSlice = TouchSlice(pointsList: [details.localFocalPoint]);
  }

  void _addPointToSlice(ScaleUpdateDetails details) {
    if (touchSlice!.pointsList.length > 16) {
      touchSlice!.pointsList.removeAt(0);
    }
    touchSlice!.pointsList.add(details.localFocalPoint);
  }

  void _resetSlice() {
    touchSlice = null;
  }

  void _checkCollision() {
    if (touchSlice == null) {
      return;
    }

    for (final fruit in List.from(fruits)) {
      bool firstPointOutside = false;
      bool secondPointOutside = false;

      for (final point in touchSlice!.pointsList) {
        if (!firstPointOutside && !fruit.isPointInside(point)) {
          firstPointOutside = true;
          continue;
        }

        if (firstPointOutside && fruit.isPointInside(point)) {
          secondPointOutside = true;
          continue;
        }

        if (secondPointOutside && !fruit.isPointInside(point)) {
          fruits.remove(fruit);
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: _getStack(),
        ),
      ),
    );
  }

  List<Widget> _getStack() {
    final widgetsOnStack = <Widget>[];

    widgetsOnStack.add(_getBackground());
    widgetsOnStack.add(_getSlice());

    widgetsOnStack.addAll(_getFruits());
    widgetsOnStack.add(_getGestureDetector());

    return widgetsOnStack;
  }

  Widget _getBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: RadialGradient(
        colors: [
          Color(0xFFFFB75E),
          Color(0xFFED8F03),
        ],
        stops: [0.2, 1.0],
      )),
    );
  }

  Widget _getSlice() {
    if (touchSlice == null) {
      return const SizedBox();
    }

    return CustomPaint(
      painter: SlicePainter(pointsList: touchSlice!.pointsList),
      size: Size.infinite,
    );
  }

  Widget _getGestureDetector() {
    return GestureDetector(
      onScaleStart: (details) {
        setState(() {
          _setNewSlice(details);
        });
      },
      onScaleUpdate: (details) {
        setState(() {
          _addPointToSlice(details);
          _checkCollision();
        });
      },
      onScaleEnd: (details) {
        setState(() {
          _resetSlice();
        });
      },
    );
  }

  List<Widget> _getFruits() {
    final List<Widget> list = [];

    for (var fruit in fruits) {
      list.add(
        Positioned(
          top: fruit.position.dy,
          left: fruit.position.dx,
          child: Container(
            width: fruit.width,
            height: fruit.height,
            color: Colors.white,
          ),
        ),
      );
    }

    return list;
  }
}

class SlicePainter extends CustomPainter {
  final List<Offset> pointsList;

  const SlicePainter({
    required this.pointsList,
  });

  static final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _drawPath(canvas);
  }

  void _drawPath(Canvas canvas) {
    if (pointsList.length < 2) {
      return;
    }

    _paint.color = Colors.white;
    _paint.strokeWidth = 3;
    _paint.style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(pointsList[0].dx, pointsList[0].dy);

    for (var i = 0; i < pointsList.length - 1; i++) {
      path.lineTo(pointsList[i].dx, pointsList[i].dy);
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

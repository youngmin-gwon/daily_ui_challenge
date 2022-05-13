import 'dart:math' as math;
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'models/fruit.dart';
import 'models/fruit_part.dart';
import 'models/touch_slice.dart';

class NinjaFruitScreen extends StatefulWidget {
  const NinjaFruitScreen({Key? key}) : super(key: key);

  @override
  State<NinjaFruitScreen> createState() => _NinjaFruitScreenState();
}

class _NinjaFruitScreenState extends State<NinjaFruitScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  TouchSlice? touchSlice;
  int score = 0;
  final List<Fruit> fruits = [];
  final List<FruitPart> fruitParts = [];

  @override
  void initState() {
    super.initState();
    _spawnRandomFruit();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      for (var fruit in fruits) {
        fruit.applyGravity();
      }

      for (var fruitPart in fruitParts) {
        fruitPart.applyGravity();
      }

      if (math.Random().nextDouble() > 0.97) {
        _spawnRandomFruit();
      }
    });
  }

  void _spawnRandomFruit() {
    fruits.add(
      Fruit(
        position: const Offset(0, 200),
        width: 80,
        height: 80,
        additionalForce: Offset(
          5 + math.Random().nextDouble() * 5,
          -10 * math.Random().nextDouble(),
        ),
        rotation: math.Random().nextDouble() / 3 - 0.16,
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
          _turnFruitIntoParts(fruit);
          score += 10;
          break;
        }
      }
    }
  }

  void _turnFruitIntoParts(Fruit fruit) {
    FruitPart leftFruitPart = FruitPart(
      rotation: fruit.rotation,
      position: Offset(fruit.position.dx - fruit.width / 8, fruit.position.dy),
      width: fruit.width / 2,
      height: fruit.height,
      isLeft: true,
      additionalForce:
          Offset(fruit.additionalForce.dx - 1, fruit.additionalForce.dy - 5),
    );

    FruitPart rightFruitPart = FruitPart(
      rotation: fruit.rotation,
      position: Offset(fruit.position.dx + fruit.width / 8 + fruit.width / 4,
          fruit.position.dy),
      width: fruit.width / 2,
      height: fruit.height,
      isLeft: false,
      additionalForce:
          Offset(fruit.additionalForce.dx + 1, fruit.additionalForce.dy - 5),
    );

    setState(() {
      fruitParts.add(leftFruitPart);
      fruitParts.add(rightFruitPart);
      fruits.remove(fruit);
    });
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

    widgetsOnStack.addAll(_getFruitsParts());
    widgetsOnStack.addAll(_getFruits());
    widgetsOnStack.add(_getGestureDetector());

    widgetsOnStack.add(
      Positioned(
        top: 16,
        right: 16,
        child: Text(
          "Score: $score",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );

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

  List<Widget> _getFruitsParts() {
    final List<Widget> list = <Widget>[];

    for (var fruitPart in fruitParts) {
      list.add(
        Positioned(
          top: fruitPart.position.dy,
          left: fruitPart.position.dx,
          child: _getMelonCut(fruitPart),
        ),
      );
    }

    return list;
  }

  List<Widget> _getFruits() {
    final List<Widget> list = [];

    for (var fruit in fruits) {
      list.add(
        Positioned(
          top: fruit.position.dy,
          left: fruit.position.dx,
          child: Transform.rotate(
            angle: fruit.rotation * math.pi * 2,
            child: _getMelon(fruit),
          ),
        ),
      );
    }

    return list;
  }

  Widget _getMelon(Fruit fruit) {
    return Image.asset(
      "assets/images/melon_uncut.png",
      height: 80,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _getMelonCut(FruitPart fruitPart) {
    return Transform.rotate(
      angle: fruitPart.rotation * math.pi * 2,
      child: Image.asset(
        fruitPart.isLeft
            ? "assets/images/melon_cut.png"
            : "assets/images/melon_cut_right.png",
        height: 80,
        fit: BoxFit.fitHeight,
      ),
    );
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
    // _drawPath(canvas);
    _drawBlade(canvas, size);
  }

  void _drawBlade(Canvas canvas, Size size) {
    Path pathLeft = Path();
    Path pathRight = Path();
    Paint paintLeft = Paint();
    Paint paintRight = Paint();

    if (pointsList.length < 3) {
      return;
    }

    paintLeft.color = const Color.fromRGBO(220, 220, 220, 1);
    paintRight.color = Colors.white;
    pathLeft.moveTo(pointsList[0].dx, pointsList[0].dy);
    pathRight.moveTo(pointsList[0].dx, pointsList[0].dy);

    for (int i = 0; i < pointsList.length; i++) {
      if (i <= 1 || i >= pointsList.length - 5) {
        pathLeft.lineTo(pointsList[i].dx, pointsList[i].dy);
        pathRight.lineTo(pointsList[i].dx, pointsList[i].dy);
        continue;
      }

      double x1 = pointsList[i - 1].dx;
      double x2 = pointsList[i].dx;
      double lengthX = x2 - x1;

      double y1 = pointsList[i - 1].dy;
      double y2 = pointsList[i].dy;
      double lengthY = y2 - y1;

      double length = math.sqrt((lengthX * lengthX) + (lengthY * lengthY));
      double normalizedVectorX = lengthX / length;
      double normalizedVectorY = lengthY / length;
      double distance = 15;

      double newXLeft =
          x1 - normalizedVectorY * (i / pointsList.length * distance);
      double newYLeft =
          y1 + normalizedVectorX * (i / pointsList.length * distance);

      double newXRight =
          x1 - normalizedVectorY * (i / pointsList.length * -distance);
      double newYRight =
          y1 + normalizedVectorX * (i / pointsList.length * -distance);

      pathLeft.lineTo(newXLeft, newYLeft);
      pathRight.lineTo(newXRight, newYRight);
    }

    for (int i = pointsList.length - 1; i >= 0; i--) {
      pathLeft.lineTo(pointsList[i].dx, pointsList[i].dy);
      pathRight.lineTo(pointsList[i].dx, pointsList[i].dy);
    }

    canvas.drawShadow(pathLeft, Colors.grey, 3.0, false);
    canvas.drawShadow(pathRight, Colors.grey, 3.0, false);
    canvas.drawPath(pathLeft, paintLeft);
    canvas.drawPath(pathRight, paintRight);
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

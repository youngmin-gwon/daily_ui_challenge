import 'package:flutter/material.dart';

class SprayScreen extends StatefulWidget {
  const SprayScreen({Key? key}) : super(key: key);

  @override
  State<SprayScreen> createState() => _SprayScreenState();
}

class _SprayScreenState extends State<SprayScreen>
    with SingleTickerProviderStateMixin {
  DrawLine? line;

  void _onPanStart(DragStartDetails details) {
    print('User started drawing');
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);

    setState(() {
      line = DrawLine(points: [point], color: Colors.black, width: 2);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);

    final path = List<Offset>.from(line!.points)..add(point);

    setState(() {
      line = DrawLine(points: path, color: Colors.black, width: 2);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      print("User ended drawing");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildSprayPaint(),
          _buildGestureDetector(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
    );
  }

  Widget _buildSprayPaint() {
    return CustomPaint(
      size: Size.infinite,
      painter: SprayPainter(
        lines: [line!],
      ),
    );
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
    );
  }
}

class SprayPainter extends CustomPainter {
  final List<DrawLine> lines;

  const SprayPainter({
    required this.lines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // if (points.length < 2) {
    //   return;
    // }

    // final paint = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2;

    // Path path = Path();

    // canvas.save();

    // path.moveTo(points[0].dx, points[0].dy);

    // for (final point in points) {
    //   path.lineTo(point.dx, point.dy);
    // }

    // canvas.drawPath(path, paint);

    // canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawLine {
  final List<Offset> points;
  final Color color;
  final double width;

  const DrawLine({
    required this.points,
    required this.color,
    required this.width,
  });
}

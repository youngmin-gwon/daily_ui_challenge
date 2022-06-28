import 'package:daily_ui/2022/6/28_lava/lava_painter.dart';
import 'package:flutter/material.dart';

class LavaScreen extends StatefulWidget {
  const LavaScreen({Key? key}) : super(key: key);

  @override
  State<LavaScreen> createState() => _LavaScreenState();
}

class _LavaScreenState extends State<LavaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Lava lava = Lava(6);

  List<Color> colors = [
    Color(0xfff857a6),
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.yellow,
    Colors.green,
    Colors.deepPurple,
    Colors.cyan,
    Color(0xffff5858)
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(500, 500),
              painter: LavaPainter(
                lava: lava,
                color: colors[0],
              ),
            );
          }),
    );
  }
}

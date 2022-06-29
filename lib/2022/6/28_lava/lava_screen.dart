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

  static const List<Color> colors = [
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

  final tweenColors = TweenSequence<Color?>(colors
      .asMap()
      .map(
        (index, color) => MapEntry(
          index,
          TweenSequenceItem(
            weight: 1.0,
            tween: ColorTween(
              begin: color,
              end: colors[index + 1 < colors.length ? index + 1 : 0],
            ),
          ),
        ),
      )
      .values
      .toList());

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
    print("lava");
    final lava = Lava(6, MediaQuery.of(context).size);
    lava.updateSize(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final color = colors[0];
            return CustomPaint(
              size: Size.infinite,
              painter: LavaPainter(color, lava),
            );
          }),
    );
  }
}

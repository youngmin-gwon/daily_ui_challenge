import 'package:daily_ui/2022/6/10_spraying/spray_screen.dart';
import 'package:daily_ui/2022/6/12_point_drag/point_drag_screen.dart';
import 'package:daily_ui/2022/6/16_led_effect/pixel_effect_screen.dart';
import 'package:daily_ui/2022/6/18_matrix_effect/matrix_effect_screen.dart';
import 'package:daily_ui/2022/6/20_magnifier/magnifier_screen.dart';
import 'package:daily_ui/2022/6/21_bezier/bezier_screen.dart';
import 'package:daily_ui/2022/6/3_drag/drag_animation_screen.dart';
import 'package:daily_ui/2022/6/4_drawing/drawing_screen.dart';
import 'package:flutter/material.dart';

class JuneScreen extends StatelessWidget {
  const JuneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("June"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const DragAnimationScreen()),
                  );
                },
                child: const Text("3. Drag Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const DrawingScreen()),
                  );
                },
                child: const Text("4. Drawing Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SprayScreen()),
                  );
                },
                child: const Text("10. Spray Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const PointDragScreen()),
                  );
                },
                child: const Text("12. Point Drag Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const PixelEffectScreen()),
                  );
                },
                child: const Text("16. Pixel effect"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const MatrixEffectScreen()),
                  );
                },
                child: const Text("18. Matrix Effect"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const MagnifierScreen()),
                  );
                },
                child: const Text("19. Magnifier Effect"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const BezierScreen()),
                  );
                },
                child: const Text("20. Bezier Animation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

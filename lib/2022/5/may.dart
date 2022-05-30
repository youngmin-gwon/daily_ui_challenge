import 'package:daily_ui/2022/5/18_progress_indicator/progress_indicator_screen.dart';
import 'package:daily_ui/2022/5/19_disable_button/disable_button_screen.dart';
import 'package:daily_ui/2022/5/1_neon_light/neon_light_screen.dart';
import 'package:daily_ui/2022/5/20_overlay/overlay_screen.dart';
import 'package:daily_ui/2022/5/21_glow/glow_screen.dart';
import 'package:daily_ui/2022/5/22_torus/torus_screen.dart';
import 'package:daily_ui/2022/5/23_sequantial_rotate/sequantial_rotate_screen.dart';
import 'package:daily_ui/2022/5/24_star/star_screen.dart';
import 'package:daily_ui/2022/5/25_flock/flock_screen.dart';
import 'package:daily_ui/2022/5/2_moving_gradation/moving_gradation_screen.dart';
import 'package:daily_ui/2022/5/30_changing_shape/changing_shape_screen.dart';
import 'package:daily_ui/2022/5/4_particle_sweep/particle_practice.dart';
import 'package:daily_ui/2022/5/4_particle_sweep/particle_sweep_screen.dart';
import 'package:daily_ui/2022/5/5_rotating_polygon/rotating_polygon_screen.dart';
import 'package:daily_ui/2022/5/6_glitch/glitch_screen.dart';
import 'package:daily_ui/2022/5/7_spark/spark_animation_screen.dart';
import 'package:daily_ui/2022/5/9_ninja_fruit/ninja_fruit_screen.dart';
import 'package:flutter/material.dart';

class MayScreen extends StatelessWidget {
  const MayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NeonLightScreen(),
                    ),
                  );
                },
                child: const Text("1. Neon Light Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MovingGradationScreen(),
                    ),
                  );
                },
                child: const Text("2. Moving Gradation Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ParticleSweepScreen(),
                    ),
                  );
                },
                child: const Text("4. Particle Sweep Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ParticlePracticePage(),
                    ),
                  );
                },
                child: const Text("4-1. Particle Sweep Animation Practice"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RotatingPolygonScreen(),
                    ),
                  );
                },
                child: const Text("5. Rotating Polygon Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GlitchScreen(),
                    ),
                  );
                },
                child: const Text("6. Glitch Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SparkAnimationScreen(),
                    ),
                  );
                },
                child: const Text("7. Spark Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NinjaFruitScreen(),
                    ),
                  );
                },
                child: const Text("9. Ninja Fruit Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProgressIndicatorScreen(),
                    ),
                  );
                },
                child: const Text("18. Progress Indicator Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DisableButtonScreen(),
                    ),
                  );
                },
                child: const Text("19. Disable button screen"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OverlayScreen(),
                    ),
                  );
                },
                child: const Text("20. Overlay Screen"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GlowScreen(),
                    ),
                  );
                },
                child: const Text("21. Glow Effect 2"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TorusScreen(),
                    ),
                  );
                },
                child: const Text("22. Torus"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SequantialRotateScreen(),
                    ),
                  );
                },
                child: const Text("23. Sequantial Rotate"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StarScreen(),
                    ),
                  );
                },
                child: const Text("24. Star Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FlockScreen(),
                    ),
                  );
                },
                child: const Text("25. Flock Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChangingShapeScreen(),
                    ),
                  );
                },
                child: const Text("30. Changing Shape Animation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

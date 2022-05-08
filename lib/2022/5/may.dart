import 'package:daily_ui/2022/5/1_neon_light/neon_light_screen.dart';
import 'package:daily_ui/2022/5/2_moving_gradation/moving_gradation_screen.dart';
import 'package:daily_ui/2022/5/4_particle_sweep/particle_practice.dart';
import 'package:daily_ui/2022/5/4_particle_sweep/particle_sweep_screen.dart';
import 'package:daily_ui/2022/5/5_rotating_polygon/rotating_polygon_screen.dart';
import 'package:daily_ui/2022/5/6_glitch/glitch_screen.dart';
import 'package:daily_ui/2022/5/7_spark/spark_animation_screen.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}

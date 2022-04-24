import 'package:daily_ui/2022/4/10_stacked_cards/ui/stacked_card_screen.dart';
import 'package:daily_ui/2022/4/17_rotating_character/rotating_character_screen.dart';
import 'package:daily_ui/2022/4/18_cylinder_animation/cylinder_animation_screen.dart';
import 'package:daily_ui/2022/4/1_shimmer_animation/shimmer_animation_screen.dart';
import 'package:daily_ui/2022/4/20_splash_tap/splash_tap_screen.dart';
import 'package:daily_ui/2022/4/21_perlin_noise/perlin_noise_screen.dart';
import 'package:daily_ui/2022/4/22_wave_slider/wave_slider_screen.dart';
import 'package:daily_ui/2022/4/23_bouncing_ball/bouncing_ball_screen.dart';
import 'package:daily_ui/2022/4/24_wave_animation/wave_animation_screen.dart';
import 'package:daily_ui/2022/4/2_shimmer_text_animation/shimmer_animation_text_screen.dart';
import 'package:daily_ui/2022/4/3_expandable_fab/expandable_fab_screen.dart';
import 'package:daily_ui/2022/4/4_curtain_blind_animation/curtain_blind_screen.dart';
import 'package:flutter/material.dart';

class AprilScreen extends StatelessWidget {
  const AprilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("April"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ShimmerAnimationScreen(),
                    ),
                  );
                },
                child: const Text("1. Shimmer Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ShimmerTextScreen(),
                    ),
                  );
                },
                child: const Text("2. Shimmer Text Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ExpandableFabScreen(),
                    ),
                  );
                },
                child: const Text("3. Expandable FAB Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CurtainBlindScreen(),
                    ),
                  );
                },
                child: const Text("4. Curtain Blind Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StackedCardScreen(),
                    ),
                  );
                },
                child: const Text("10. Stacked Card Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RotatingCharacterScreen(),
                    ),
                  );
                },
                child: const Text("17. Rotating Character Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CylinderAnimationScreen(),
                    ),
                  );
                },
                child: const Text("18. Cylinder Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SplashTapScreen(),
                    ),
                  );
                },
                child: const Text("20. Splash Tap Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PerlinNoiseScreen(),
                    ),
                  );
                },
                child: const Text("21. Perlin Background Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WaveSliderScreen(),
                    ),
                  );
                },
                child: const Text("22. Wave Slider Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BouncingBallScreen(),
                    ),
                  );
                },
                child: const Text("23. Bouncing Ball Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WaveAnimationScreen(),
                    ),
                  );
                },
                child: const Text("24. Wave Animation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

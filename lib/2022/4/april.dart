import 'package:daily_ui/2022/4/1_shimmer_animation/shimmer_animation_screen.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}

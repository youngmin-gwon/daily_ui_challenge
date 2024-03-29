import 'package:daily_ui/2022/7/12_wave_practice/wave_gesture_screen.dart';
import 'package:daily_ui/2022/7/13_wave_practice2/wave_practice2_screen.dart';
import 'package:daily_ui/2022/7/27_disk_animation/disk_counter_screen.dart';
import 'package:daily_ui/2022/7/4_wave_counter/wave_counter_screen.dart';
import 'package:daily_ui/2022/7/5_portrait_counter/portrait_counter_screen.dart';
import 'package:daily_ui/2022/7/6_bubble_rotating_counter/bubble_rotating_counter_screen.dart';
import 'package:daily_ui/2022/8/10_creature_counter_animation/creature_counter_screen.dart';
import 'package:daily_ui/2022/8/15_slime_practice/slime_practice_screen.dart';
import 'package:daily_ui/2022/8/16_not_boring_scroll/not_boring_scroll_screen.dart';
import 'package:daily_ui/2022/8/8_circle_wave/circle_wave_screen.dart';
import 'package:flutter/material.dart';

class AugustScreen extends StatelessWidget {
  const AugustScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("August"),
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
                      builder: (context) => const CircleWaveScreen(),
                    ),
                  );
                },
                child: const Text("8. Circle Wave Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreatureCounterScreen(),
                    ),
                  );
                },
                child: const Text("10. Creature Counter Animation"),
              ),
              // const SizedBox(height: 12),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const SlimePracticeScreen(),
              //       ),
              //     );
              //   },
              //   child: const Text("15. Metaball Experiment"),
              // ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotBoringListViewScreen(),
                    ),
                  );
                },
                child: const Text("16. Not boring ListView Animation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

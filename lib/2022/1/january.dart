import 'package:daily_ui/2022/1/13_liquid_animation/drink_rewards_list.dart';
import 'package:daily_ui/2022/1/21_form_animation/form_demo_screen.dart';
import 'package:daily_ui/2022/1/28/widgets/determine_visibility.dart';
import 'package:daily_ui/2022/1/6_onboarding/screens/onboarding/onboarding_screen.dart';
import 'package:daily_ui/2022/1/7_flipping_animation/20220107.dart';
import 'package:flutter/material.dart';

class January2022Screen extends StatelessWidget {
  const January2022Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('January'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      final screenHeight = MediaQuery.of(context).size.height;
                      return OnboardingScreen(
                        screenHeight: screenHeight,
                      );
                    },
                  ));
                },
                child: const Text("6. Onboarding Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Screen20220107(),
                  ));
                },
                child: const Text("7. Flipping Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DrinkRewardsList(),
                  ));
                },
                child: const Text("13. Liquid Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PlantFormDemoScreen(),
                  ));
                },
                child: const Text("21. Form Animation"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:daily_ui/2022/1/6/screens/onboarding/onboarding_screen.dart';
import 'package:daily_ui/2022/1/7/20220107.dart';
import 'package:flutter/material.dart';

class January2022Screen extends StatelessWidget {
  const January2022Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                child: const Text("6"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Screen20220107(),
                  ));
                },
                child: const Text("7"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

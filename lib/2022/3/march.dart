import 'package:daily_ui/2022/3/1/page_transition.dart';
import 'package:daily_ui/2022/3/14/share_button_animation.dart';
import 'package:daily_ui/2022/3/5/wheel_scroll_screen.dart';
import 'package:flutter/material.dart';

class MarchScreen extends StatelessWidget {
  const MarchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("March"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PageTransitionExample(),
                    ),
                  );
                },
                child: const Text("1"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WheelScrollScreen(),
                    ),
                  );
                },
                child: const Text("5"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ShareButtonAnimationScreen(),
                    ),
                  );
                },
                child: const Text("14"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:daily_ui/2022/3/14_button_jumping_animation/share_button_animation.dart';
import 'package:daily_ui/2022/3/15_banking_app_animation/bank_app_screen.dart';
import 'package:daily_ui/2022/3/16_custom_transition/custom_transition_screen.dart';
import 'package:daily_ui/2022/3/17_card_gradient/card_gradient_screen.dart';
import 'package:daily_ui/2022/3/19_expanding_animation/expandable_nav_bar_screen.dart';
import 'package:daily_ui/2022/3/1_page_stretching_animation/page_transition.dart';
import 'package:daily_ui/2022/3/21_snake_button/snake_button_screen.dart';
import 'package:daily_ui/2022/3/27_circle_face_pile/cirlcle_face_pile_screen.dart';
import 'package:daily_ui/2022/3/5_wheel_scroll_animation/wheel_scroll_screen.dart';
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
                child: const Text("1. Page Stretching Animation"),
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
                child: const Text("5. Wheel Scroll Animation"),
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
                child: const Text("14. Button Jumping Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BankAppScreen(),
                    ),
                  );
                },
                child: const Text("15. Banking App Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CustomTransitionScreen(),
                    ),
                  );
                },
                child: const Text("16. Custom Transition"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CardGradientScreen(),
                    ),
                  );
                },
                child: const Text("17. Card Gradient"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ExpandableNavBarScreen(),
                    ),
                  );
                },
                child: const Text("19. Expandable Nav Bar Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SnakeButtonScreen(),
                    ),
                  );
                },
                child: const Text("21. Snake Button Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CircleFacePileScreen(),
                    ),
                  );
                },
                child: const Text("27. Face Pile Animation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

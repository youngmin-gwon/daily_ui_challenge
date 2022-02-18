import 'package:daily_ui/2022/2/10/hover_screen.dart';
import 'package:daily_ui/2022/2/11/filling_button_screen.dart';
import 'package:daily_ui/2022/2/17_fading_text/fading_shadermask_screen.dart';
import 'package:daily_ui/2022/2/18/glowing_screen.dart';
import 'package:daily_ui/2022/2/4/instagram_animation.dart';
import 'package:daily_ui/2022/2/5/path_selection_screen.dart';
import 'package:daily_ui/2022/2/7/google_logo_screen.dart';
import 'package:flutter/material.dart';

import '8/parallax_effect_screen.dart';
import '9/parallax_scroll_screen.dart';

class February2022Screen extends StatelessWidget {
  const February2022Screen({Key? key}) : super(key: key);

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const InstagramPage();
                      },
                    ),
                  );
                },
                child: const Text("4"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const PathSelectionScreen();
                      },
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
                      builder: (context) {
                        return const GoogleLogoScreen();
                      },
                    ),
                  );
                },
                child: const Text("7"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const ParallaxEffectScreen();
                      },
                    ),
                  );
                },
                child: const Text("8"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const ParallaxScrollScreen();
                      },
                    ),
                  );
                },
                child: const Text("9"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const HoverEffectScreen();
                      },
                    ),
                  );
                },
                child: const Text("10"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const FillingButtonScreen();
                    },
                  ));
                },
                child: const Text("11"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const FadingShaderMaskScreen();
                    },
                  ));
                },
                child: const Text("17"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const GlowingScreen();
                    },
                  ));
                },
                child: const Text("18"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:daily_ui/2022/2/10_hover_and_blending_animation/hover_screen.dart';
import 'package:daily_ui/2022/2/11_twitter_button_animation/filling_button_screen.dart';
import 'package:daily_ui/2022/2/17_fading_text/fading_shadermask_screen.dart';
import 'package:daily_ui/2022/2/18_glowing_ui/glowing_screen.dart';
import 'package:daily_ui/2022/2/22_message_flash_animation/message_flash.dart';
import 'package:daily_ui/2022/2/4_instagram_animation/instagram_animation.dart';
import 'package:daily_ui/2022/2/5_path_animation/path_selection_screen.dart';
import 'package:daily_ui/2022/2/7_google_logo_animation/google_logo_screen.dart';
import 'package:daily_ui/2022/2/8_parallax_hover_animation/parallax_effect_screen.dart';
import 'package:daily_ui/2022/2/9_parallax_scroll_animation/parallax_scroll_screen.dart';
import 'package:flutter/material.dart';

class February2022Screen extends StatelessWidget {
  const February2022Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('February'),
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
                      builder: (context) {
                        return const InstagramPage();
                      },
                    ),
                  );
                },
                child: const Text("4. Instagram Animation"),
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
                child: const Text("5. Path Animation"),
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
                child: const Text("7. Google Animation"),
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
                child: const Text("8. Parallax Hover Animation(not done)"),
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
                child: const Text("9. Parallax Scroll Animation"),
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
                child: const Text("10. Hover and Blending Animation"),
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
                child: const Text("11. Twitter Button Animation"),
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
                child: const Text("17. Fading Test Carousel Animation"),
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
                child: const Text("18. Glowing UI"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const MessageFlashPage();
                    },
                  ));
                },
                child: const Text("22. Message Flash Animation(bug)"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

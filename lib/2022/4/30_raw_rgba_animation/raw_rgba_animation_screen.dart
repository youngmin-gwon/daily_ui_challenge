import 'package:daily_ui/2022/4/30_raw_rgba_animation/screenshot.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_point_notifier.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_point_scope.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_settings.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_setttings_scope.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/animated_points.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/settings_form.dart';
import 'package:flutter/material.dart';

class RawRgbaAnimationScreen extends StatelessWidget {
  const RawRgbaAnimationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: RgbaSettingsScope(
        settings: RgbaSettings(),
        child: RgbaPointScope(
          pointNotifier: RgbaPointNotifier(),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  MainScreen(),
                  SettingsForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: RgbaPointScope.of(context),
        builder: (context, child) {
          return RgbaPointScope.of(context).isReady
              ? const AnimatedPoints()
              : const ScreenShot();
        });
  }
}

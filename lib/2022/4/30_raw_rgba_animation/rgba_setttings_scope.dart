import 'package:flutter/material.dart';

import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_settings.dart';

class RgbaSettingsScope extends InheritedWidget {
  const RgbaSettingsScope({
    Key? key,
    required Widget child,
    required this.settings,
  }) : super(key: key, child: child);

  final RgbaSettings settings;

  static RgbaSettings of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RgbaSettingsScope>()!
        .settings;
  }

  @override
  bool updateShouldNotify(RgbaSettingsScope oldWidget) {
    return settings != oldWidget.settings;
  }
}

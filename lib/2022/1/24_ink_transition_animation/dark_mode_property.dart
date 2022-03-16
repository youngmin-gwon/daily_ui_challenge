import 'package:flutter/material.dart';

class DarkModeProvider extends InheritedWidget {
  final bool isDarkMode;

  const DarkModeProvider(
      {Key? key, required this.isDarkMode, required Widget child})
      : super(key: key, child: child);

  static DarkModeProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<DarkModeProvider>();
    assert(result != null, "No DarkModeInheritedWidget found in context");
    return result!;
  }

  @override
  bool updateShouldNotify(DarkModeProvider oldWidget) {
    return isDarkMode != oldWidget.isDarkMode;
  }
}

import 'package:flutter/material.dart';

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({Key? key, required Widget child, required bool darkMode})
      : _isDarkMode = darkMode,
        super(key: key, child: child);

  final bool _isDarkMode;

  bool get darkMode => _isDarkMode;

  static ThemeProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(result != null, "ThemeProvider not found in the context");
    return result!;
  }

  @override
  bool updateShouldNotify(covariant ThemeProvider oldWidget) {
    return _isDarkMode != oldWidget._isDarkMode;
  }
}

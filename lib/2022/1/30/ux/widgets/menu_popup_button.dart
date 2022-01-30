import 'package:daily_ui/2022/1/30/states/theme_provider.dart';
import 'package:flutter/material.dart';

enum MenuCommands {
  darkModeSwitch,
  settings,
}

class MenuPopupButton extends StatelessWidget {
  const MenuPopupButton({
    Key? key,
    required this.onThemeChanged,
  }) : super(key: key);

  final void Function(bool) onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final themeModel = ThemeProvider.of(context);

    return PopupMenuButton<MenuCommands>(
      onSelected: (result) {
        switch (result) {
          case MenuCommands.darkModeSwitch:
            onThemeChanged.call(!themeModel.darkMode);
            break;
          default:
            break;
        }
      },
      offset: const Offset(0, 48),
      itemBuilder: (context) => [
        CheckedPopupMenuItem<MenuCommands>(
          checked: themeModel.darkMode,
          value: MenuCommands.darkModeSwitch,
          child: const Text("Dark Mode"),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<MenuCommands>(
          value: MenuCommands.settings,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ),
      ],
    );
  }
}

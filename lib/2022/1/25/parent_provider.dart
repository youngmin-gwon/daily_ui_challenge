import 'package:flutter/material.dart';

class ParentProvider extends InheritedWidget {
  final String childTitle1;
  final String childTitle2;
  final TabController tabController;

  const ParentProvider({
    Key? key,
    required this.childTitle1,
    required this.childTitle2,
    required this.tabController,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ParentProvider oldWidget) {
    return childTitle1 != oldWidget.childTitle1 ||
        childTitle2 != oldWidget.childTitle2 ||
        tabController != oldWidget.tabController;
  }

  static ParentProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ParentProvider>();
    assert(result != null, "No Parent InheritedWidget found in context");
    return result!;
  }
}

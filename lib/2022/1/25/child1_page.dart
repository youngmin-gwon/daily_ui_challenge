import 'package:flutter/material.dart';

import 'package:daily_ui/2022/1/25/parent_provider.dart';

class Child1Page extends StatefulWidget {
  const Child1Page({
    Key? key,
    required this.parentAction,
    required this.child2Action,
  }) : super(key: key);

  final ValueChanged<String> parentAction;
  final ValueChanged<String> child2Action;

  @override
  _Child1PageState createState() => _Child1PageState();
}

class _Child1PageState extends State<Child1Page> {
  @override
  Widget build(BuildContext context) {
    final currentTitle = ParentProvider.of(context).childTitle1;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            currentTitle,
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
              widget.parentAction("Update by child 1");
            },
            child: const Text("Action 2"),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
              widget.child2Action("Updated by child 1");
            },
            child: const Text("Action 3"),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
              final controller = ParentProvider.of(context).tabController;
              controller.index = 1;
            },
            child: const Text("Action 4"),
          ),
        ],
      ),
    );
  }
}

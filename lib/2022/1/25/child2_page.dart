import 'package:daily_ui/2022/1/25/parent_provider.dart';
import 'package:flutter/material.dart';

class Child2Page extends StatefulWidget {
  const Child2Page({Key? key}) : super(key: key);

  @override
  _Child2PageState createState() => _Child2PageState();
}

class _Child2PageState extends State<Child2Page> {
  @override
  Widget build(BuildContext context) {
    final currentTitle = ParentProvider.of(context).childTitle2;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            currentTitle,
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'drink_rewards_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: SafeArea(
        child: DrinkRewardsList(),
      ),
    );
  }
}

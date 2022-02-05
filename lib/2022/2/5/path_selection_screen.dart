import 'package:daily_ui/2022/2/5/circles.dart';
import 'package:daily_ui/2022/2/5/lines.dart';
import 'package:daily_ui/2022/2/5/planets.dart';
import 'package:daily_ui/2022/2/5/polygons.dart';
import 'package:daily_ui/2022/2/5/spiral.dart';
import 'package:flutter/material.dart';

class PathSelectionScreen extends StatelessWidget {
  const PathSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> screens = {
      "Lines": const LinesPage(),
      "Circles": const CirclesPage(),
      "Polygons": const PolygonsPage(),
      "Spiral": const SpiralPage(),
      "Planet": const PlanetsPage(),
    };

    List<Widget> children = [];
    screens.forEach((key, value) {
      children.add(ListTile(
        title: Text(key),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => value),
        ),
      ));
    });

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: children,
      ),
    );
  }
}

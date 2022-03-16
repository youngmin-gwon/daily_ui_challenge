import 'package:flutter/material.dart';

class DarkInkTransitionScreen extends StatefulWidget {
  const DarkInkTransitionScreen({Key? key}) : super(key: key);

  @override
  _DarkInkTransitionScreenState createState() =>
      _DarkInkTransitionScreenState();
}

class _DarkInkTransitionScreenState extends State<DarkInkTransitionScreen> {
  late ScrollController _scrollController;

  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _toggleDarkMode,
        child: Stack(
          children: [
            // TransitionContainer(),
            // DarkInkBar(),
            // DarkInkControls(),
          ],
        ),
      ),
    );
  }
}

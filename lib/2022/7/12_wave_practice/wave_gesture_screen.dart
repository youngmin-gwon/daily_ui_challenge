import 'package:daily_ui/2022/7/12_wave_practice/wave_slider.dart';
import 'package:flutter/material.dart';

class WaveGestureScreen extends StatefulWidget {
  const WaveGestureScreen({Key? key}) : super(key: key);

  @override
  State<WaveGestureScreen> createState() => _WaveGestureScreenState();
}

class _WaveGestureScreenState extends State<WaveGestureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: WaveSlider(),
        ),
      ),
    );
  }
}

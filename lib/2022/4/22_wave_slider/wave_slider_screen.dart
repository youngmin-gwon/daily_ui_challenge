import 'package:daily_ui/2022/4/22_wave_slider/wave_slider.dart';
import 'package:daily_ui/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class WaveSliderScreen extends StatefulWidget {
  const WaveSliderScreen({Key? key}) : super(key: key);

  @override
  State<WaveSliderScreen> createState() => _WaveSliderScreenState();
}

class _WaveSliderScreenState extends State<WaveSliderScreen> {
  int _age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select your age",
              style: TextStyle(
                fontSize: 45,
                fontFamily: FontFamily.silkscreen,
              ),
            ),
            const SizedBox(height: 20),
            WaveSlider(
              onChanged: (value) {
                setState(() {
                  _age = (value * 100).round();
                });
              },
              onStart: (value) {
                setState(() {
                  _age = (value * 100).round();
                });
              },
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                ),
                Text(
                  "$_age",
                  style: const TextStyle(
                    fontFamily: FontFamily.silkscreen,
                    fontSize: 45,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  "YEAR",
                  style: TextStyle(
                    fontFamily: FontFamily.silkscreen,
                    fontSize: 20,
                  ),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
          ],
        ),
      ),
    );
  }
}

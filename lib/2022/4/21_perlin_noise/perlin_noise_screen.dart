import 'package:daily_ui/2022/4/21_perlin_noise/pixel_noise.dart';
import 'package:daily_ui/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class PerlinNoiseScreen extends StatelessWidget {
  const PerlinNoiseScreen({Key? key}) : super(key: key);

  static const backgroundColor = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const PixelNoise(
            color: backgroundColor,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/pixel_flutter.png",
                  width: 200,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          "Flutter is down",
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontFamily: FontFamily.silkscreen,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          "for maintenance",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontFamily: FontFamily.silkscreen,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          "It's not you, it's me",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontFamily: FontFamily.silkscreen,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

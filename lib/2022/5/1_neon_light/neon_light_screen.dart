import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonLightScreen extends StatefulWidget {
  const NeonLightScreen({Key? key}) : super(key: key);

  @override
  State<NeonLightScreen> createState() => _NeonLightScreenState();
}

class _NeonLightScreenState extends State<NeonLightScreen> {
  static const fontColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Text(
            "Welcome to flutter",
            textAlign: ui.TextAlign.center,
            style: GoogleFonts.majorMonoDisplay(
              fontSize: 100,
              shadows: [
                const ui.Shadow(
                  blurRadius: 10,
                  color: fontColor,
                ),
                ui.Shadow(
                  blurRadius: 20,
                  color: fontColor.withOpacity(.9),
                ),
                ui.Shadow(
                  blurRadius: 30,
                  color: fontColor.withOpacity(.8),
                ),
                ui.Shadow(
                  blurRadius: 40,
                  color: fontColor.withOpacity(.7),
                ),
                ui.Shadow(
                  blurRadius: 50,
                  color: fontColor.withOpacity(.6),
                ),
              ],
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:daily_ui/2022/6/16_led_effect/display_simulator.dart';
import 'package:flutter/material.dart';

class PixelEffectScreen extends StatefulWidget {
  const PixelEffectScreen({Key? key}) : super(key: key);

  @override
  State<PixelEffectScreen> createState() => _PixelEffectScreenState();
}

class _PixelEffectScreenState extends State<PixelEffectScreen> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                DisplaySimulator(
                  text: text,
                  border: false,
                  debug: false,
                ),
                const SizedBox(height: 48),
                _getTextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTextField() {
    BorderSide borderSide = const BorderSide(color: Colors.blue, width: 4);
    InputDecoration inputDecoration = InputDecoration(
      border: UnderlineInputBorder(borderSide: borderSide),
      disabledBorder: UnderlineInputBorder(borderSide: borderSide),
      enabledBorder: UnderlineInputBorder(borderSide: borderSide),
      focusedBorder: UnderlineInputBorder(borderSide: borderSide),
    );

    return SizedBox(
        width: 200,
        child: TextField(
          maxLines: null,
          enableSuggestions: false,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.yellow, fontSize: 32, fontFamily: "Monospace"),
          decoration: inputDecoration,
          onChanged: (val) {
            setState(() {
              text = val;
            });
          },
        ));
  }
}

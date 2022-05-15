import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_point_scope.dart';
import 'package:flutter/material.dart';

import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_settings.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_setttings_scope.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final settings = RgbaSettingsScope.of(context);
        _textEditingController.text = settings.text;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: RgbaSettingsScope.of(context),
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                TextField(
                  textAlign: TextAlign.center,
                  controller: _textEditingController,
                  onChanged: (String value) {
                    RgbaPointScope.of(context).setIsReady(false);
                    RgbaSettingsScope.of(context).updateText(value);
                  },
                ),
                const SizedBox(height: 30),
                _Slider(
                  name: "Size",
                  value: RgbaSettingsScope.of(context).size.toDouble(),
                  onChanged: RgbaSettingsScope.of(context).updateSize,
                ),
                _Slider(
                  name: "Speed",
                  value: RgbaSettingsScope.of(context).speed.toDouble(),
                  onChanged: RgbaSettingsScope.of(context).updateDuration,
                ),
                _Slider(
                  name: "Resolution",
                  value: RgbaSettingsScope.of(context).resolution.toDouble(),
                  onChanged: RgbaSettingsScope.of(context).updateResolution,
                ),
              ],
            ),
          );
        });
  }
}

class _Slider extends StatefulWidget {
  const _Slider({
    Key? key,
    required this.name,
    required this.value,
    required this.onChanged,
    this.canBeZero = false,
  }) : super(key: key);

  final String name;
  final double value;
  final void Function(double) onChanged;
  final bool canBeZero;

  @override
  State<_Slider> createState() => __SliderState();
}

class __SliderState extends State<_Slider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Text(widget.name)),
        Slider(
          min: widget.canBeZero ? 0 : 1,
          max: kMax,
          value: widget.value,
          onChanged: widget.onChanged,
          onChangeEnd: (value) {
            RgbaPointScope.of(context).setIsReady(false);
          },
        ),
      ],
    );
  }
}

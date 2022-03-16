import 'package:daily_ui/2022/3/5_wheel_scroll_animation/time_tile.dart';
import 'package:flutter/material.dart';

class WheelScrollScreen extends StatefulWidget {
  const WheelScrollScreen({Key? key}) : super(key: key);

  @override
  State<WheelScrollScreen> createState() => _WheelScrollScreenState();
}

class _WheelScrollScreenState extends State<WheelScrollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Wheel Scroll"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // hours
          SizedBox(
            width: 70,
            child: ListWheelScrollView.useDelegate(
              onSelectedItemChanged: (value) {
                print(value);
              },
              physics: const FixedExtentScrollPhysics(),
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 13,
                builder: (context, index) {
                  return TimeTile(text: index.toString());
                },
              ),
            ),
          ),
          // minutes
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: ListWheelScrollView.useDelegate(
              onSelectedItemChanged: (value) {
                print(value);
              },
              physics: const FixedExtentScrollPhysics(),
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 60,
                builder: (context, index) {
                  return TimeTile(
                    text: index.toString(),
                    useFillNumber: true,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: ListWheelScrollView(
              physics: const FixedExtentScrollPhysics(),
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              children: const [
                TimeTile(text: "am"),
                TimeTile(text: "pm"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

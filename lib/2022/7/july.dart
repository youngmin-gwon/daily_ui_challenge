import 'package:daily_ui/2022/7/4_wave_counter/wave_counter_screen.dart';
import 'package:daily_ui/2022/7/5_portrait_counter/portrait_counter_screen.dart';
import 'package:flutter/material.dart';

class JulyScreen extends StatelessWidget {
  const JulyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("July"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const WaveCounterScreen()),
                  );
                },
                child: const Text("4. Wave Counter"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const PortraitCounterScreen()),
                  );
                },
                child: const Text("5. Portrait Counter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

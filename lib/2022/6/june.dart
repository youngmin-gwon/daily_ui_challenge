import 'package:daily_ui/2022/6/3/drag_animation_screen.dart';
import 'package:flutter/material.dart';

class JuneScreen extends StatelessWidget {
  const JuneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("June"),
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
                        builder: (context) => const DragAnimationScreen()),
                  );
                },
                child: const Text("3. Drag Animation"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

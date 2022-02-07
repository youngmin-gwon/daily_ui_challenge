import 'package:daily_ui/2022/2/4/instagram_animation.dart';
import 'package:daily_ui/2022/2/5/path_selection_screen.dart';
import 'package:daily_ui/2022/2/7/google_logo_screen.dart';
import 'package:flutter/material.dart';

class February2022Screen extends StatelessWidget {
  const February2022Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const InstagramPage();
                    },
                  ));
                },
                child: const Text("4"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const PathSelectionScreen();
                    },
                  ));
                },
                child: const Text("5"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const GoogleLogoScreen();
                    },
                  ));
                },
                child: const Text("7"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

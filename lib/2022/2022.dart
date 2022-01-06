import 'package:daily_ui/2022/1/2022_jan.dart';
import 'package:flutter/material.dart';

class Board2022Screen extends StatelessWidget {
  const Board2022Screen({Key? key}) : super(key: key);

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const January2022Screen(),
                    ),
                  );
                },
                child: const Text(
                  "January",
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

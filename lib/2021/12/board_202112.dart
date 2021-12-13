import 'package:daily_ui/2021/12/13/20211213.dart';
import 'package:flutter/material.dart';

class BoardScreen202112 extends StatelessWidget {
  const BoardScreen202112({Key? key}) : super(key: key);

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
                      builder: (context) => const Screen20211213(),
                    ),
                  );
                },
                child: const Text(
                  "13",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

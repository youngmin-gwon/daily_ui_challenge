import 'package:daily_ui/2022/1/january.dart';
import 'package:daily_ui/2022/3/march.dart';
import 'package:daily_ui/2022/4/april.dart';
import 'package:daily_ui/2022/5/may.dart';
import 'package:flutter/material.dart';

import '2/february.dart';

class Board2022Screen extends StatelessWidget {
  const Board2022Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2022'),
      ),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const February2022Screen(),
                    ),
                  );
                },
                child: const Text(
                  "February",
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MarchScreen(),
                    ),
                  );
                },
                child: const Text(
                  "March",
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AprilScreen(),
                    ),
                  );
                },
                child: const Text(
                  "April",
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MayScreen(),
                    ),
                  );
                },
                child: const Text(
                  "May",
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

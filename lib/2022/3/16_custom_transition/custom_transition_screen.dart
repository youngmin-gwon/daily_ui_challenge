import 'package:flutter/material.dart';

class CustomTransitionScreen extends StatelessWidget {
  const CustomTransitionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _FirstPage();
  }
}

class _FirstPage extends StatelessWidget {
  const _FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
              reverseTransitionDuration: const Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) {
                return _SecondPage(
                  transitionAnimation: animation,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SecondPage extends StatelessWidget {
  const _SecondPage({
    Key? key,
    required this.transitionAnimation,
  }) : super(key: key);

  final Animation<double> transitionAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _SlidingContainer(
              transitionAnimation: transitionAnimation,
              initialOffsetX: -1,
              intervalStart: 0,
              intervalEnd: 0.6,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: _SlidingContainer(
              transitionAnimation: transitionAnimation,
              initialOffsetX: 1,
              intervalStart: 0.4,
              intervalEnd: 1,
              color: Colors.green,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text('Navigate Back'),
      ),
    );
  }
}

class _SlidingContainer extends StatelessWidget {
  const _SlidingContainer({
    Key? key,
    required this.transitionAnimation,
    required this.initialOffsetX,
    required this.intervalStart,
    required this.intervalEnd,
    required this.color,
  }) : super(key: key);

  final Animation<double> transitionAnimation;
  final double initialOffsetX;
  final double intervalStart;
  final double intervalEnd;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
              begin: Offset(initialOffsetX, 0), end: const Offset(0, 0))
          .animate(
        CurvedAnimation(
          parent: transitionAnimation,
          curve: Interval(
            intervalStart,
            intervalEnd,
            curve: Curves.ease,
          ),
        ),
      ),
      child: Container(
        color: color,
      ),
    );
  }
}

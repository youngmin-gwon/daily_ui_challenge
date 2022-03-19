import 'dart:ui';

import 'package:flutter/material.dart';

const _cardColor = Color(0xFF5F40FB);
const _maxHeight = 350.0;
const _minHeight = 70.0;

class ExpandableNavBarScreen extends StatefulWidget {
  const ExpandableNavBarScreen({Key? key}) : super(key: key);

  @override
  State<ExpandableNavBarScreen> createState() => _ExpandableNavBarScreenState();
}

class _ExpandableNavBarScreenState extends State<ExpandableNavBarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  double _currentHeight = _minHeight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClose() {
    setState(() {
      _isExpanded = true;
      _currentHeight = _maxHeight;
      _controller.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuWidth = size.width * 0.5;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(bottom: _minHeight),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.primaries[index % Colors.primaries.length],
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              onVerticalDragUpdate: _isExpanded
                  ? (details) {
                      setState(() {
                        final newHeight = _currentHeight - details.delta.dy;
                        _controller.value = _currentHeight / _maxHeight;
                        _currentHeight =
                            newHeight.clamp(_minHeight, _maxHeight);
                      });
                    }
                  : null,
              onVerticalDragEnd: _isExpanded
                  ? (details) {
                      if (_currentHeight < _maxHeight / 2) {
                        _controller.reverse();
                        _isExpanded = false;
                      } else {
                        _isExpanded = true;
                        _controller.forward(from: _currentHeight / _maxHeight);
                        _currentHeight = _maxHeight;
                      }
                    }
                  : null,
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final value = const ElasticInOutCurve(0.7)
                        .transform(_controller.value);
                    return Stack(
                      children: [
                        Positioned(
                          height: lerpDouble(_minHeight, _maxHeight, value),
                          width: lerpDouble(menuWidth, size.width, value),
                          bottom: lerpDouble(40, 0, value),
                          left: lerpDouble(
                              size.width / 2 - menuWidth / 2, 0, value),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _cardColor,
                              borderRadius: BorderRadius.vertical(
                                top: const Radius.circular(20),
                                bottom:
                                    Radius.circular(lerpDouble(20, 0, value)!),
                              ),
                            ),
                            child: _isExpanded
                                ? FadeTransition(
                                    opacity: _controller,
                                    child: const ExpandedContent())
                                : MenuContent(
                                    onTap: _onClose,
                                  ),
                          ),
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
        bottomNavigationBar: GestureDetector(),
      ),
    );
  }
}

class ExpandedContent extends StatelessWidget {
  const ExpandedContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 15),
              const Text(
                'Last Century',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 15),
              const Text(
                'Bloody Tear',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.shuffle),
                  Icon(Icons.pause),
                  Icon(Icons.playlist_add),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuContent extends StatelessWidget {
  const MenuContent({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(Icons.calendar_today_sharp),
        GestureDetector(onTap: onTap, child: const Icon(Icons.calendar_today)),
        const Icon(Icons.calendar_today_sharp),
      ],
    );
  }
}

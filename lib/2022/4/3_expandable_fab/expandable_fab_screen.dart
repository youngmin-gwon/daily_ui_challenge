import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExpandableFabScreen extends StatelessWidget {
  const ExpandableFabScreen({Key? key}) : super(key: key);

  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("CLOSE"),
            )
          ],
        );
      },
    );
  }

  Widget _buildItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF9E9E9E),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF9E9E9E),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildItem(),
              _buildItem(),
              _buildItem(),
              _buildItem(),
              _buildItem(),
            ],
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          _ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(
              Icons.format_size,
            ),
          ),
          _ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(
              Icons.insert_photo,
            ),
          ),
          _ActionButton(
            onPressed: () {
              _showAction(context, 2);
            },
            icon: const Icon(
              Icons.videocam,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  static _ExpandableFabState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ExpandableFabState>();
  }

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initialOpen ?? false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          IgnorePointer(
            ignoring: !_isOpen,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _toggle,
              child: const SizedBox.expand(),
            ),
          ),
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return AnimatedScale(
      scale: _isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            child: InkWell(
                onTap: _toggle,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _isOpen,
      child: AnimatedContainer(
        transform: Matrix4.diagonal3Values(
            _isOpen ? 0.7 : 1.0, _isOpen ? 0.7 : 1.0, 1.0),
        transformAlignment: Alignment.center,
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedScale(
          scale: _isOpen ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);
  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.secondary,
        elevation: 4,
        child: IconButton(
          onPressed: () {
            onPressed?.call();
            ExpandableFab.of(context)?._toggle();
          },
          icon: icon,
          color: theme.scaffoldBackgroundColor,
        ));
  }
}

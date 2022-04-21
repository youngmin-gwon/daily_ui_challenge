import 'package:flutter/material.dart';

import 'package:daily_ui/2022/4/22_wave_slider/wave_painter.dart';

class WaveSlider extends StatefulWidget {
  const WaveSlider({
    Key? key,
    this.width = 350,
    this.height = 50,
    this.color = Colors.black,
    required this.onChanged,
    required this.onStart,
  })  : assert(height >= 50 && height <= 600),
        super(key: key);

  final double width;
  final double height;
  final Color color;

  final ValueChanged<double> onChanged;
  final ValueChanged<double> onStart;

  @override
  State<WaveSlider> createState() => _WaveSliderState();
}

class _WaveSliderState extends State<WaveSlider>
    with SingleTickerProviderStateMixin {
  late WaveSlideController _slideController;

  double _dragPosition = 0;
  double _dragPercent = 0;

  @override
  void initState() {
    super.initState();
    _slideController = WaveSlideController(vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _updateDragPosition(Offset offset) {
    double newDragPosition = 0;

    if (offset.dx <= 0) {
      newDragPosition = 0;
    } else if (offset.dx >= widget.width) {
      newDragPosition = widget.width;
    } else {
      newDragPosition = offset.dx;
    }

    setState(() {
      _dragPosition = newDragPosition;
      _dragPercent = _dragPosition / widget.width;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.globalPosition);
    _slideController.setStateToSliding();
    _updateDragPosition(offset);
    _handleChangeUpdate(_dragPercent);
  }

  void _onDragStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.globalPosition);
    _slideController.setStateToStart();
    _updateDragPosition(offset);
    _handleChangeStart(_dragPercent);
  }

  void _onDragEnd(DragEndDetails details) {
    _slideController.setStateToStopping();
    setState(() {});
  }

  void _handleChangeStart(double percent) {
    widget.onStart(percent);
  }

  void _handleChangeUpdate(double percent) {
    widget.onChanged(percent);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragEnd: _onDragEnd,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: WavePainter(
            animationProgress: _slideController.progress,
            sliderState: _slideController.state,
            color: widget.color,
            dragPercent: _dragPercent,
            sliderPosition: _dragPosition,
          ),
        ),
      ),
    );
  }
}

/// control slide animation and position
class WaveSlideController with ChangeNotifier {
  final AnimationController controller;

  SliderState _state = SliderState.resting;

  WaveSlideController({required TickerProvider vsync})
      : controller = AnimationController(
          vsync: vsync,
        ) {
    controller
      ..addListener(_onProgressUpdate)
      ..addStatusListener(_onStatusUpdate);
  }

  double get progress => controller.value;

  SliderState get state => _state;

  void _onProgressUpdate() {
    notifyListeners();
  }

  void _onStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onTransitionCompleted();
    }
  }

  void _onTransitionCompleted() {
    if (_state == SliderState.stopping) {
      setStateToResting();
    }
  }

  void _startAnimation() {
    controller.duration = const Duration(milliseconds: 500);
    controller.forward(from: 0.0);
    notifyListeners();
  }

  void setStateToResting() {
    _state = SliderState.resting;
  }

  void setStateToStart() {
    _startAnimation();
    _state = SliderState.starting;
  }

  void setStateToSliding() {
    _state = SliderState.sliding;
  }

  void setStateToStopping() {
    _startAnimation();
    _state = SliderState.stopping;
  }
}

enum SliderState {
  starting,
  resting,
  sliding,
  stopping,
}

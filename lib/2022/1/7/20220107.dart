import 'dart:math';

import 'package:flutter/material.dart';

class Screen20220107 extends StatefulWidget {
  const Screen20220107({Key? key}) : super(key: key);

  @override
  State<Screen20220107> createState() => _Screen20220107State();
}

class _Screen20220107State extends State<Screen20220107> {
  final assetPathList = [
    "assets/image/flutter.jpg",
    "assets/image/react.png",
    "assets/image/xamarin.png",
  ];

  int _tabIndex = 0;

  late String assetPath;

  @override
  void initState() {
    super.initState();
    assetPath = assetPathList[_tabIndex];
  }

  void _changeImage(int index) {
    setState(() {
      _tabIndex = index;
      assetPath = assetPathList[_tabIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Scaffold(
          backgroundColor: const Color(0xFF353535),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: FlippingImage(assetPath: assetPath),
            ),
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(child: Text("Flutter")),
              Tab(child: Text("React")),
              Tab(child: Text("Xamarin")),
            ],
            onTap: _changeImage,
          ),
        ),
      ),
    );
  }
}

class FlippingImage extends StatefulWidget {
  const FlippingImage({
    Key? key,
    required this.assetPath,
  }) : super(key: key);

  final String assetPath;

  @override
  _FlippingImageState createState() => _FlippingImageState();
}

class _FlippingImageState extends State<FlippingImage>
    with SingleTickerProviderStateMixin {
  late String _currentImagePath;
  late String _image1;
  late String _image2;

  late AnimationController _animationController;
  final Curve _rotationCurve = Curves.elasticOut;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();

    _image1 = widget.assetPath;
    _currentImagePath = widget.assetPath;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addListener(_updateRotation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _onRotationComplete();
        }
      });
  }

  @override
  void didUpdateWidget(covariant FlippingImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.assetPath != widget.assetPath) {
      _immediatelyFinishCurrentAnimation();
      _image2 = widget.assetPath;
      _flipCard();
    }
  }

  void _flipCard() {
    _currentImagePath = _image1;
    _animationController.forward(from: 0.0);
  }

  void _onRotationComplete() {
    setState(() {
      _animationController.value = 0;
      _image1 = _image2;
      _currentImagePath = _image2;
    });
  }

  void _immediatelyFinishCurrentAnimation() {
    if (_animationController.isAnimating) {
      _animationController.stop();
      _currentImagePath = _image2;
      _image1 = _image2;
    }
  }

  void _updateRotation() {
    setState(() {
      _rotation = pi * _rotationCurve.transform(_animationController.value);

      if (_currentImagePath == _image1 && _rotation > pi / 2) {
        // 첫번째 이미지에서 두번째 이미지로
        _currentImagePath = _image2;
      } else if (_currentImagePath == _image2 && _rotation < pi / 2) {
        // 여러개를 빠르게 전환할 때 케이스
        _currentImagePath = _image1;
      } else if (_currentImagePath == _image2) {
        // 이미지 돌렸을 때 위 아래 바꿔주기 위해서 사용
        _rotation = _rotation - pi;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        // transformation
        transform: Matrix4.identity()
          // identity: don't change anything at all
          ..setEntry(3, 2, 0.001)
          // setEntry : 수학적으로 정해져 있는 값, perspective matrix
          //            마지막 값만 수정해야 원하는 값을 얻을 가능성이 높음
          ..rotateX(_rotation)
        // rotate
        ,
        alignment: FractionalOffset.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Image.asset(_currentImagePath),
          ),
        ),
      ),
    );
  }
}

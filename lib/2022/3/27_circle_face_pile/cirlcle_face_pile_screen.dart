import 'dart:math';

import 'package:collection/collection.dart';
import 'package:daily_ui/2022/2/4_instagram_animation/instagram_animation.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CircleFacePileScreen extends StatefulWidget {
  const CircleFacePileScreen({Key? key}) : super(key: key);

  @override
  State<CircleFacePileScreen> createState() => _CircleFacePileScreenState();
}

class _CircleFacePileScreenState extends State<CircleFacePileScreen> {
  final _facePileUsers = <_User>[];

  void _addUserToPile() {
    setState(() {
      _facePileUsers.add(
        _User(
          id: "${Random().nextInt(1000)}",
          firstName: faker.person.firstName(),
          avatarUrl:
              "https://randomuser.me/api/portraits/women/${Random().nextInt(100)}.jpg",
        ),
      );
    });
  }

  void _removeUserFromPile() {
    if (_facePileUsers.isNotEmpty) {
      setState(() {
        final randomIndex = Random().nextInt(_facePileUsers.length);
        _facePileUsers.removeAt(randomIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: FacePile(
            users: _facePileUsers,
            facePercentOverlap: 0.1,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'remove',
            onPressed: _removeUserFromPile,
            mini: true,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 24),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _addUserToPile,
            mini: true,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class FacePile extends StatefulWidget {
  const FacePile({
    Key? key,
    required this.users,
    this.faceSize = 48,
    required this.facePercentOverlap,
  }) : super(key: key);

  final List<_User> users;
  final double faceSize;
  final double facePercentOverlap;

  @override
  State<FacePile> createState() => _FacePileState();
}

class _FacePileState extends State<FacePile> {
  final _visibleUsers = <_User>[];

  @override
  void initState() {
    super.initState();
    _syncUsersWithPile();
  }

  @override
  void didUpdateWidget(covariant FacePile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncUsersWithPile();
  }

  void _syncUsersWithPile() {
    final newUsers = widget.users.where(
      (user) =>
          _visibleUsers.where((visibleUser) => visibleUser == user).isEmpty,
    );

    _visibleUsers.addAll(newUsers);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final facesCount = _visibleUsers.length;
      double facePercentVisible = 1.0 - widget.facePercentOverlap;

      final intrinsicWidth = facesCount > 1
          ? (1 + (facePercentVisible * (facesCount - 1))) * widget.faceSize
          : widget.faceSize;

      late double leftOffset;
      if (intrinsicWidth > constraints.maxWidth) {
        leftOffset = 0;
        facePercentVisible =
            ((constraints.maxWidth / widget.faceSize) - 1) / (facesCount - 1);
      } else {
        leftOffset = (constraints.maxWidth - intrinsicWidth) / 2;
      }

      return SizedBox(
        height: widget.faceSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: _visibleUsers
              .mapIndexed(
                (int index, _User element) => AnimatedPositioned(
                  key: ValueKey(element.id),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  left: leftOffset +
                      (index * facePercentVisible * widget.faceSize),
                  top: 0,
                  width: widget.faceSize,
                  height: widget.faceSize,
                  child: AppearingAndDisappearingFace(
                    user: element,
                    faceSize: widget.faceSize,
                    showFace: widget.users.contains(element),
                    onDisappear: () {
                      setState(() {
                        _visibleUsers.remove(element);
                      });
                    },
                  ),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}

class AppearingAndDisappearingFace extends StatefulWidget {
  const AppearingAndDisappearingFace({
    Key? key,
    required this.user,
    this.faceSize = 48,
    required this.showFace,
    required this.onDisappear,
  }) : super(key: key);

  final _User user;
  final double faceSize;
  final bool showFace;
  final VoidCallback onDisappear;

  @override
  State<AppearingAndDisappearingFace> createState() =>
      _AppearingAndDisappearingFaceState();
}

class _AppearingAndDisappearingFaceState
    extends State<AppearingAndDisappearingFace>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  static final _scaleTween = CurveTween(curve: Curves.elasticOut);

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          widget.onDisappear.call();
        }
      });

    _syncScaleAnimationWithWidget();
  }

  @override
  void didUpdateWidget(covariant AppearingAndDisappearingFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncScaleAnimationWithWidget();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _syncScaleAnimationWithWidget() {
    if (widget.showFace &&
        !_scaleController.isCompleted &&
        _scaleController.status != AnimationStatus.forward) {
      _scaleController.forward();
    } else if (!widget.showFace &&
        !_scaleController.isDismissed &&
        _scaleController.status != AnimationStatus.reverse) {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.faceSize,
      height: widget.faceSize,
      child: Center(
        child: AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleTween.animate(_scaleController).value,
              child: child,
            );
          },
          child: _AvatarCircle(
            user: widget.user,
            size: widget.faceSize,
            nameLabelColor: const Color(0xFF222222),
            backgroundColor: const Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatefulWidget {
  const _AvatarCircle({
    Key? key,
    required this.user,
    this.size = 48,
    this.backgroundColor = const Color(0xFF888888),
    this.nameLabelColor = const Color(0xFF222222),
  }) : super(key: key);

  final _User user;
  final double size;
  final Color nameLabelColor;
  final Color backgroundColor;

  @override
  State<_AvatarCircle> createState() => _AvatarCircleState();
}

class _AvatarCircleState extends State<_AvatarCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.6),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              widget.user.firstName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.nameLabelColor,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.user.avatarUrl,
            fadeInDuration: const Duration(milliseconds: 250),
          )
        ],
      ),
    );
  }
}

class _User {
  final String id;
  final String firstName;
  final String avatarUrl;

  const _User({
    required this.id,
    required this.firstName,
    required this.avatarUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _User &&
        other.id == id &&
        other.firstName == firstName &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => id.hashCode ^ firstName.hashCode ^ avatarUrl.hashCode;
}

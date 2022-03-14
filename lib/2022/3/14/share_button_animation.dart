import 'package:flutter/material.dart';

class ShareButtonAnimationScreen extends StatefulWidget {
  const ShareButtonAnimationScreen({Key? key}) : super(key: key);

  @override
  State<ShareButtonAnimationScreen> createState() =>
      _ShareButtonAnimationScreenState();
}

class _ShareButtonAnimationScreenState
    extends State<ShareButtonAnimationScreen> {
  var _gradientColors = <Color>[
    const Color(0xFF8122BF),
    const Color(0xFFCA32F5),
    const Color(0xFFF2B634),
  ];

  void _changeDecoration(bool isExpanded) {
    setState(() {
      if (isExpanded) {
        _gradientColors = <Color>[
          const Color(0xFFF2B634),
          const Color(0xFFCA32F5),
          const Color(0xFF8122BF),
        ];
      } else {
        _gradientColors = <Color>[
          const Color(0xFF8122BF),
          const Color(0xFFCA32F5),
          const Color(0xFFF2B634),
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradientColors,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: SocialShareButton(
            height: 100,
            onTap: _changeDecoration,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.face_unlock_sharp),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.smart_display_rounded),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.face_retouching_natural),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.abc),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialShareButton extends StatefulWidget {
  const SocialShareButton({
    Key? key,
    required this.height,
    required this.children,
    this.onTap,
    this.buttonLabel = 'SHARE',
    this.buttonStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    this.buttonColor = Colors.black,
    this.childrenColor = Colors.white,
  }) : super(key: key);

  final double height;
  final List<Widget> children;
  final TextStyle buttonStyle;
  final Color buttonColor;
  final Color childrenColor;
  final String buttonLabel;
  final void Function(bool)? onTap;

  @override
  State<SocialShareButton> createState() => _SocialShareButtonState();
}

class _SocialShareButtonState extends State<SocialShareButton>
    with SingleTickerProviderStateMixin {
  final _buttonKey = GlobalKey();
  double _buttonWidth = 0.0;
  bool _isExpanded = false;

  late AnimationController _controller;

  static final _translateTween = Tween<double>(begin: 0, end: 1).chain(
    CurveTween(curve: Curves.ease),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _buttonWidth = _buttonKey.currentContext!.size!.width + 14;
      });
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movement = widget.height / 4;
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            height: widget.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0.0,
                      -movement * _translateTween.animate(_controller).value),
                  child: _ButtonTopWidget(
                    height: widget.height,
                    buttonKey: _buttonKey,
                    children: widget.children,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0.0,
                      movement * _translateTween.animate(_controller).value),
                  child: _ButtonBottomWidget(
                    height: widget.height,
                    width: _buttonWidth,
                    label: widget.buttonLabel,
                    buttonStyle: widget.buttonStyle,
                    buttonColor: widget.buttonColor,
                    onTap: () {
                      if (_isExpanded) {
                        _controller.reverse();
                      } else {
                        _controller.forward();
                      }
                      _isExpanded = !_isExpanded;
                      widget.onTap?.call(_isExpanded);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _ButtonBottomWidget extends StatelessWidget {
  const _ButtonBottomWidget({
    Key? key,
    required this.width,
    required this.onTap,
    required this.height,
    required this.buttonStyle,
    required this.buttonColor,
    required this.label,
  }) : super(key: key);

  final double width;
  final double height;
  final VoidCallback onTap;
  final TextStyle buttonStyle;
  final Color buttonColor;
  static final _buttonRadius = BorderRadius.circular(8);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: buttonColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: _buttonRadius,
      ),
      child: InkWell(
        borderRadius: _buttonRadius,
        onTap: onTap,
        child: Container(
          width: width,
          height: height / 2,
          alignment: Alignment.center,
          child: Text(
            label,
            style: buttonStyle,
          ),
        ),
      ),
    );
  }
}

class _ButtonTopWidget extends StatelessWidget {
  const _ButtonTopWidget({
    Key? key,
    required this.height,
    required this.children,
    required GlobalKey<State<StatefulWidget>> buttonKey,
  })  : _buttonKey = buttonKey,
        super(key: key);

  final double height;
  final List<Widget> children;
  final GlobalKey<State<StatefulWidget>> _buttonKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height / 2,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          )),
      child: Row(
        key: _buttonKey,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

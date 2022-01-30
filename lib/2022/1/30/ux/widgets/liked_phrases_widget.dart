import 'dart:ui';

import 'package:daily_ui/2022/1/30/models/phrase_model.dart';
import 'package:daily_ui/2022/1/30/states/phrases_provider.dart';
import 'package:daily_ui/2022/1/30/ux/styles/styles.dart';
import 'package:flutter/material.dart';

class LikedPhrasesWidget extends StatelessWidget {
  const LikedPhrasesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              salmon.withOpacity(.5),
              Colors.transparent,
            ]),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: PhrasesProvider.of(context).likedPhrases.isEmpty
              ? Center(
                  child: Text(
                  "Nothing loved yet :(",
                  style: Theme.of(context).textTheme.headline5,
                ))
              : ListView.builder(
                  itemCount: PhrasesProvider.of(context).likedPhrases.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LikedPhrasesList(
                      phrase: PhrasesProvider.of(context).likedPhrases[index],
                    );
                  }),
        ),
      ),
    );
  }
}

class LikedPhrasesList extends StatefulWidget {
  const LikedPhrasesList({
    Key? key,
    required this.phrase,
  }) : super(key: key);

  final PhraseModel phrase;

  @override
  _LikedPhrasesListState createState() => _LikedPhrasesListState();
}

class _LikedPhrasesListState extends State<LikedPhrasesList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation = Tween<Offset>().animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: ReverseAnimation(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 1.0, curve: Curves.ease))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.phrase.phrase,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
      ),
    );
  }
}

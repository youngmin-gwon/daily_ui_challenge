import 'package:daily_ui/2022/1/30/models/phrase_model.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class PhrasesProvider extends InheritedWidget {
  PhrasesProvider({
    Key? key,
    required Widget child,
  })  : _phrases = [],
        _likedPhrases = [],
        super(key: key, child: child) {
    _initiate();
  }

  final List<PhraseModel> _phrases;
  final List<PhraseModel> _likedPhrases;

  List<PhraseModel> get phrases => _phrases;
  List<PhraseModel> get likedPhrases => _likedPhrases;

  static PhrasesProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<PhrasesProvider>();
    assert(result != null, "No PhrasesProvider found in context");
    return result!;
  }

  @override
  bool updateShouldNotify(covariant PhrasesProvider oldWidget) {
    return _phrases != oldWidget._phrases ||
        _likedPhrases != oldWidget._likedPhrases;
  }

  void _initiate() {
    var random = generateWordPairs().take(5);
    for (final ran in random) {
      _phrases.add(PhraseModel(phrase: ran.join(" ")));
    }
  }

  void addRandomItemToList() {
    _phrases
        .add(PhraseModel(phrase: generateWordPairs().take(1).first.join(" ")));
  }

  void addItemToList(PhraseModel phrase, int index) {
    _phrases.insert(index, phrase);
  }

  void removeItemFromList(int index) {
    _phrases.removeAt(index);
  }

  int get length => _phrases.length;

  void likeItem(int index) {
    _phrases[index].likeOrDislike();
    if (_phrases[index].isLiked) {
      _likedPhrases.add(_phrases[index]);
    } else {
      _likedPhrases
          .removeWhere((phrase) => phrase.phrase == _phrases[index].phrase);
    }
  }
}

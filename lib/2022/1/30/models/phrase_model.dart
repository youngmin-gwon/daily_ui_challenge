class PhraseModel {
  final String _phrase;
  late bool _like;

  PhraseModel({
    required String phrase,
  })  : _phrase = phrase,
        _like = false;

  String get phrase => _phrase;
  bool get isLiked => _like;

  void likeOrDislike() {
    _like = !_like;
  }
}

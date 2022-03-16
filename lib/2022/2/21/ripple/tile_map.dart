import 'dart:typed_data';

typedef ForEachIterator = void Function(int x, int y);

class TilesMap {
  final int width, height;
  final Float64List _tiles;

  TilesMap._(this._tiles, this.width, this.height);

  factory TilesMap.generate(int width, int height, double defaultContent) {
    final _tiles = Float64List(width * height);
    for (var i = 0; i < _tiles.length; i++) {
      _tiles[i] = defaultContent;
    }
    return TilesMap._(_tiles, width, height);
  }
}

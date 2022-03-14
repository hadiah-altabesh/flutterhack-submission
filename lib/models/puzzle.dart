import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:slide_puzzle/models/position.dart';
import 'package:slide_puzzle/models/tile.dart';

class Puzzle extends Equatable {
  final List<Tile> tiles;
  
  const Puzzle({required this.tiles});

  copyWith(List<Tile>? tiles, String? image) {
    return Puzzle(tiles: tiles ?? this.tiles);
  }

  printPuzzle() {
    final p = tiles.map((e) => e.correct).toList();
    for (var i = 0; i < dimention; i++) {
      print(p.getRange(dimention * i, dimention + dimention * i).toList());
    }
  }

  Position getTilePosition(Tile tile) {
    // return Position(
    //   x: ((tile.current + 1) % dimention) ~/ (dimention + 1),
    //   // (widget.tile.current.y - 1) / (dimention - 1),
    //   y: ((tile.current + 1) ~/ dimention) ~/ (dimention + 1),
    // );
    // print("----------");
    // print(tile.correct);
    // print(tiles.indexOf(tile));

    return Position.fromIndex(tiles.indexOf(tile), d: dimention);
  }

  // List<Tile> tiles
  int manhattanDistance() {
    int v = 0;
    // print("m dist start");
    for (int i = 0; i < tiles.length; i++) {
      int dx = (getTilePosition(tiles[i]).x -
              Position.fromIndex(tiles[i].correct, d: dimention).x)
          .abs();
      int dy = (getTilePosition(tiles[i]).y -
              Position.fromIndex(tiles[i].correct, d: dimention).y)
          .abs();
      v += dx + dy;
    }

    // print("m dist end");
    return v;
  }

  @override
  List<Object?> get props => [tiles];

  int get dimention {
    return sqrt(tiles.length).toInt();
  }

  Tile getWhitespace() {
    return tiles.singleWhere((tile) => tile.isW);
  }

  static const row = [1, 0, -1, 0];
  static const col = [0, -1, 0, 1];

  List<Puzzle> getWhiteMoves() {
    List<Puzzle> m = [];
    final w = getWhitespace();
    // print(p.props)

    for (var i = 0; i < 4; i++) {
      int p = getTilePosition(w)
          .add(row[i], col[i])
          .indexFromPosition(d: dimention);
      // int p = tiles.indexOf(w) + 1;
      // int p = Position.indexFromPosition(w);
      if (isIn(p)) {
        // print(p);
        final l = tiles.toList();
        final tile = tiles.firstWhere((element) => tiles.indexOf(element) == p);
        final tileIndex = tiles.indexOf(tile);
        final whitespaceTileIndex = tiles.indexOf(w);
        l[tileIndex] = w;
        // .copyWith(
        // current: w.current,
        // );
        l[whitespaceTileIndex] = tile;
        // .copyWith(
        // current: tile.current,
        // );
        m.add(Puzzle(tiles: l));
        // m.add(
        //     moveTiles(tiles.firstWhere((element) => element.current == p), []));
      }
    }
    return m;
  }

  bool isTileCorrect(Tile t) {
    // print(t);
    // print(t.correct);
    // print(tiles.indexOf(t) + 1);
    return tiles.indexOf(t) == t.correct-1;
  }

  bool get isComplete {
    // return true;
    // print(tiles.every((e) => isTileCorrect(e)));
    return tiles.every((e) => isTileCorrect(e));
  }

  int getNumberOfCorrectTiles() {
    final whitespaceTile = getWhitespace();
    var numberOfCorrectTiles = 0;
    for (final tile in tiles) {
      if (tile != whitespaceTile && isTileCorrect(tile)) {
        numberOfCorrectTiles++;
      }
    }
    return numberOfCorrectTiles;
  }

  bool isTileMovable(Tile tile) {
    final w = getWhitespace();
    return tile.isW
        ? false
        : getTilePosition(w).x == getTilePosition(tile).x ||
            getTilePosition(w).y == getTilePosition(tile).y;
  }

  bool isIn(int p) {
    // print(dimention);
    // print(dimention*dimention);
    // print(p);
    // print(p > 0 && p <= dimention * dimention);
    // print("-----");
    // return p > 0 && p <= dimention * dimention;
    return p > 0 && p < tiles.length;
  }
  // bool isIn(Position p) {
  //   return p.x > 0 && p.x <= dimention && p.y > 0 && p.y <= dimention;
  // }
  // bool isIn(x,y) {
  //   return x >= 0 && x <= dimention && y >= 0 && y <= dimention;
  // }

  isSolvable() {
    final size = dimention;
    final height = tiles.length ~/ size;
    assert(
        size * height == tiles.length, 'tiles must be equal to size * height');
    final inversions = countInversions();

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespace = tiles.singleWhere((tile) => tile.isW);

    final whitespaceRow = getTilePosition(whitespace).y;

    if (((height - whitespaceRow) + 1).toInt().isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  int countInversions() {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.isW) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (_isInverted(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  bool _isInverted(Tile a, Tile b) {
    if (!b.isW && a.correct != b.correct) {
      return tiles.indexOf(b) < tiles.indexOf(a)
          ? tiles.indexOf(b).compareTo(tiles.indexOf(a)) > 0
          : tiles.indexOf(a).compareTo(tiles.indexOf(b)) > 0;
    }
    return false;
  }

  List<Tile> getTilesToSwap(Tile tile, List<Tile> tilesToSwap) {
    final whitespaceTile = getWhitespace();
    final deltaX = getTilePosition(whitespaceTile).x - getTilePosition(tile).x;
    final deltaY = getTilePosition(whitespaceTile).y - getTilePosition(tile).y;

    if ((deltaX.abs() + deltaY.abs()) > 1) {
      final shiftPointX = getTilePosition(tile).x + deltaX.sign;
      final shiftPointY = getTilePosition(tile).y + deltaY.sign;
      final tileToSwapWith = tiles.singleWhere(
        (tile) =>
            getTilePosition(tile).x == shiftPointX &&
            getTilePosition(tile).y == shiftPointY,
      );
      tilesToSwap.add(tile);
      return getTilesToSwap(tileToSwapWith, tilesToSwap);
    } else {
      tilesToSwap.add(tile);
      return tilesToSwap;
    }
  }

  Puzzle moveTiles(Tile tile, List<Tile> tilesToSwap) {
    return swapTiles(getTilesToSwap(tile, tilesToSwap));
  }

  /// Returns puzzle with new tile arrangement after individually swapping each
  /// tile in tilesToSwap with the whitespace.
  Puzzle swapTiles(List<Tile> tilesToSwap) {
    // final List<Tile> t = tiles.toList();
    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexOf(tileToSwap);
      final tile = tiles[tileIndex];
      final whitespaceTile = getWhitespace();
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      tiles[tileIndex] = whitespaceTile;

      tiles[whitespaceTileIndex] = tile;
    }

    return Puzzle(tiles: tiles,);
  }

  // /// Sorts puzzle tiles so they are in order of their current position.
  // Puzzle sort() {
  //   final sortedTiles = tiles.toList()
  //     ..sort((tileA, tileB) {
  //       return tileA.current.compareTo(tileB.current);
  //     });
  //   return Puzzle(tiles: sortedTiles);
  // }

  // Puzzle sortCorrect() {
  //   final sortedTiles = tiles.toList()
  //     ..sort((tileA, tileB) {
  //       return tileA.correct.compareTo(tileB.correct);
  //     });
  //   return Puzzle(tiles: sortedTiles);
  // }

  // compareWith(Puzzle goal) {
  //   // """ Calculates the different between the given puzzles """
  //   int temp = 0;
  //   for (final i in List.generate(tiles.length, (index) => index)) {
  //     if (tiles[i].current != goal.tiles[i].current && !tiles[i].isW) temp += 1;
  //     // for (final j in List.generate(dimention, (index) => index)){
  //     //     if (start.tiles[i][j] != goal[i][j] && start[i][j] != '_')
  //     //         temp += 1;}}
  //     return temp;
  //   }
  // }
}

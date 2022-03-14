import 'package:slide_puzzle/models/position.dart';
import 'package:slide_puzzle/models/puzzle.dart';
import 'package:slide_puzzle/models/tile.dart';

Puzzle generatePuzzle(int size, {bool shuffle = true}) {
  // final correctPositions = <Position>[];
  // final currentPositions = <Position>[];
  // final whitespacePosition = Position(x: size, y: size);

  final currentPositions = List.generate(size * size, (index) => index + 1);

  // Create all possible board positions.
  // for (var y = 1; y <= size; y++) {
  //   for (var x = 1; x <= size; x++) {
  //     if (x == size && y == size) {
  //       // correctPositions.add(whitespacePosition);
  //       currentPositions.add(whitespacePosition);
  //     } else {
  //       final position = Position(x: x, y: y);
  //       // correctPositions.add(position);
  //       currentPositions.add(position);
  //     }
  //   }
  // }

  var tiles = _getTileListFromPositions(
    size,
    // correctPositions,
    // currentPositions,
  );
  if (shuffle) {
    tiles.shuffle();
    // Randomize only the current tile posistions.
    // currentPositions.shuffle();
  }

  var puzzle = Puzzle(tiles: tiles);

  if (shuffle) {
    // Assign the tiles new current positions until the puzzle is solvable and
    // zero tiles are in their correct position.
    while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
      // currentPositions.shuffle();
      tiles = _getTileListFromPositions(
        size,
        // correctPositions,
        // currentPositions,
      );
      tiles.shuffle();
      puzzle = Puzzle(tiles: tiles);
    }
  }
  // print(puzzle.tiles.map((e) => e.correct));
  // print(puzzle);

  return puzzle;
}

List<Tile> _getTileListFromPositions(
  int size,
  // List<Position> correctPositions,
  // List<int> currentPositions,
) {
  // final whitespacePosition = Position(x: size, y: size);
  return [
    for (int i = 1; i <= size * size; i++)
      // if (i == size * size)
      Tile(
        correct: i,
        // correct: whitespacePosition,
        // current: currentPositions[i - 1],
        isW: i == size * size ? true : false,
      )
    // else
    //   Tile(
    //     value: i,
    //     // correct: correctPositions[i - 1],
    //     current: currentPositions[i - 1],
    //   )
  ];
}

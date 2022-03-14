part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized(
      {required this.dimension, required this.shufflePuzzle, this.image, this.networkImage});

  final bool shufflePuzzle;
  final Uint8List? image;
  final Uri? networkImage;
  final int dimension;

  @override
  List<Object> get props => [dimension, shufflePuzzle];
}
// class PuzzleStart extends PuzzleEvent {
//   const PuzzleStart();

//   // final bool shufflePuzzle;

//   @override
//   List<Object> get props => [
//     // shufflePuzzle
//   ];
// }

class PuzzleUndo extends PuzzleEvent {
  const PuzzleUndo();
}

class PuzzleSolve extends PuzzleEvent {
  const PuzzleSolve();
}

class GPress extends PuzzleEvent {
  final bool isPressed;
  const GPress({required this.isPressed});

  @override
  List<Object> get props => [isPressed];
}

class ChangeBoardDimension extends PuzzleEvent {
  const ChangeBoardDimension();
}

class MouseAutoClickChange extends PuzzleEvent {
  const MouseAutoClickChange();
}

class TileTapped extends PuzzleEvent {
  const TileTapped(this.tile);

  final Tile tile;

  @override
  List<Object> get props => [tile];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}

class PuzzleShuffle extends PuzzleEvent {
  const PuzzleShuffle();
}
class PuzzlePeak extends PuzzleEvent {
  const PuzzlePeak({required this.peak});
  final bool peak;
}

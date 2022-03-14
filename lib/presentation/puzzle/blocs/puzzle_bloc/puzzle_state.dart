part of 'puzzle_bloc.dart';

enum PuzzleStatus { incomplete, complete }

enum TileMovementStatus { nothingTapped, cannotBeMoved, moved, undone }

class PuzzleState extends Equatable {
  const PuzzleState(
      {this.puzzle,
      // this.puzzle = const Puzzle(tiles: []),
      // this.puzzleStatus = PuzzleStatus.incomplete,
      this.tileMovementStatus = TileMovementStatus.nothingTapped,
      // this.numberOfCorrectTiles = 0,
      this.numberOfMoves = 0,
      this.lastTappedTile,
      this.autoMouseClick = 0,
      this.isGPressed = false,
      this.peak = false,
      this.peaks = 5,
      required this.images,
      // required this.image,
      this.paletteGenerator,
      // required this.imageWidth,
      this.started});
  final int autoMouseClick;
  final bool isGPressed;
  final bool peak;
  final int peaks;
  // final String image;
  final List<Image> images;
  // final int imageWidth;

  final Puzzle? puzzle;
  PuzzleStatus get puzzleStatus => puzzle?.isComplete ?? false
      ? PuzzleStatus.complete
      : PuzzleStatus.incomplete;

  final TileMovementStatus tileMovementStatus;
  final Tile? lastTappedTile;
  int get numberOfCorrectTiles => puzzle?.getNumberOfCorrectTiles() ?? 0;
  final DateTime? started;
  int get numberOfTilesLeft =>
      (puzzle?.tiles.length ?? 1) - numberOfCorrectTiles - 1;
  // Duration get duration => started != null
  //     ? DateTime.now().difference(started!)
  //     : Duration(seconds: 0);
  final int numberOfMoves;
  final PaletteGenerator? paletteGenerator;

  PuzzleState copyWith(
      {Puzzle? puzzle,
      // String? image,
      // int? imageWidth,
      // PuzzleStatus? puzzleStatus,
      TileMovementStatus? tileMovementStatus,
      // int? numberOfCorrectTiles,
      int? numberOfMoves,
      Tile? lastTappedTile,
      int? autoMouseClick,
      DateTime? started,
      List<Image>? images,
      bool? isGPressed,
      bool? peak,
      int? peaks,
      PaletteGenerator? paletteGenerator}) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      // image: image ?? this.image,
      // puzzleStatus: puzzleStatus ?? this.puzzleStatus,
      tileMovementStatus: tileMovementStatus ?? this.tileMovementStatus,
      // numberOfCorrectTiles: numberOfCorrectTiles ?? this.numberOfCorrectTiles,
      numberOfMoves: numberOfMoves ?? this.numberOfMoves,
      lastTappedTile: lastTappedTile ?? this.lastTappedTile,
      started: started ?? this.started,
      autoMouseClick: autoMouseClick ?? this.autoMouseClick,
      isGPressed: isGPressed ?? this.isGPressed,
      paletteGenerator: paletteGenerator ?? this.paletteGenerator,
      // imageWidth: imageWidth ?? this.imageWidth,
      images: images ?? this.images,
      peak: peak ?? this.peak,
      peaks: peaks ?? this.peaks
    );
  }

  @override
  List<Object?> get props => [
        puzzle,
        // image,
        images,
        // puzzleStatus,
        tileMovementStatus,
        numberOfCorrectTiles,
        numberOfMoves,
        lastTappedTile,
        started,
        autoMouseClick,
        isGPressed,
        paletteGenerator,
        peak,
        peaks,  
      ];
}

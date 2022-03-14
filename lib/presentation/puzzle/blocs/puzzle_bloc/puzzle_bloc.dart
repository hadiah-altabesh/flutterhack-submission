import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:slide_puzzle/models/tile.dart';
import 'package:slide_puzzle/models/puzzle.dart';
import 'package:slide_puzzle/utils/functions2.dart';
import 'package:slide_puzzle/utils/imageCropper.dart';
import 'package:http/http.dart' as http;
part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc({this.random}) : super(const PuzzleState(

            // image: "assets/images/test.jpg",
            //  imageWidth: 1,
            images: [])) {
    // PuzzleBloc(this._size, {this.random}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleUndo>(_onPuzzleUndo);
    on<PuzzleReset>(_onPuzzleReset);
    on<PuzzleSolve>(_onPuzzleSolve);
    on<MouseAutoClickChange>(_onMouseAutoClickChange);
    on<ChangeBoardDimension>(_onChangeBoardDimension);
    on<GPress>(_onGPress);
    on<PuzzleShuffle>(_onPuzzleShuffle);
    on<PuzzlePeak>(_onPuzzlePeak);
    // on<PuzzleStart>(_onPuzzleStart);
  }
  final GlobalKey imageKey = GlobalKey();

  Future<PaletteGenerator> _updatePaletteGenerator(
      {Rect? reigon, image}) async {
    return await PaletteGenerator.fromImageProvider(image,
        maximumColorCount: 5);
    // setState(() {});
  }

  Future<int> _calculateImageDimension({image}) {
    Completer<int> completer = Completer();
    // Image image = Image.asset(i);
    // image.
    image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          // if (myImage.width != imW) {
          // setState(() {
          //   imW = myImage.width;
          // });
          // }
          // Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(myImage.width);
        },
      ),
    );
    return completer.future;
  }
  // final int _size;

  // Timer? _timer;

  final List<List<List>> history = [];

  final Random? random;

  // void _onPuzzleStart(PuzzleStart event, Emitter<PuzzleState> emit) {
  //   // final puzzle = _generatePuzzle(_size);
  //   _timer?.cancel();
  //   _timer = Timer.periodic(Duration(milliseconds: 500), (t) {
  //     if (t.tick > 3) {
  //       t.cancel();
  //       return;
  //     }

  //   });
  //   emit(
  //     PuzzleState(
  //       puzzle: puzzle.sort(),
  //       numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
  //     ),
  //   );
  // }

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) async {
    List<Image> images = [];
    PaletteGenerator? p;
    if (event.image != null || event.networkImage != null) {
      if (event.image != null) {
        images = splitImage(
            inputImage: event.image!,
            horizontalPieceCount: event.dimension,
            verticalPieceCount: event.dimension);
        final image = Image.memory(event.image!).image;
        p = await _updatePaletteGenerator(image: image);
      } else {
        final request = await http.get(event.networkImage!);
        images = splitImage(
            inputImage: request.bodyBytes,
            horizontalPieceCount: event.dimension,
            verticalPieceCount: event.dimension);
        // final image = AssetImage("assets/images/test.jpg");
        p = await _updatePaletteGenerator(
            image: Image.memory(request.bodyBytes).image);
      }
    }
    // print(images);
    final puzzle =
        generatePuzzle(event.dimension, shuffle: event.shufflePuzzle);
    history.clear();

    // final d = await _calculateImageDimension(image: event.image);
    emit(
      PuzzleState(
          puzzle: puzzle,
          // image: state.image,
          images: images,
          // imageWidth: 500,
          // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
          paletteGenerator: p,
          started: DateTime.now()),
    );
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      // if (true) {
      if (state.puzzle!.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle!.tiles]);
        // final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        final tilesToSwap = mutablePuzzle.getTilesToSwap(tappedTile, []);
        final puzzle = mutablePuzzle.swapTiles(tilesToSwap);
        if (history.length > 5) {
          history.removeAt(0);
        }
        history
            .add(state.puzzle!.tiles.map((e) => [e.correct, e.isW]).toList());
        if (puzzle.isComplete) {
          emit(
            state.copyWith(
              puzzle: puzzle,
              // puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle,
              tileMovementStatus: TileMovementStatus.moved,
              // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onPuzzleUndo(PuzzleUndo event, Emitter<PuzzleState> emit) {
    final lastMove = history.removeLast();
    final puzzle = Puzzle(
      tiles: lastMove.map((e) {
        return Tile(
            correct: e[0],
            //  current: e[2],
            isW: e[1]);
      }).toList(),
    );
    final lastTapped = lastMove.last;
    // final puzzle = mutablePuzzle.swapTiles(lastMove
    //     .map((e) =>
    //         state.puzzle.tiles.singleWhere((element) => element.value == e))
    //     .toList());
    emit(
      state.copyWith(
        puzzle: puzzle,
        tileMovementStatus: TileMovementStatus.undone,
        // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
        numberOfMoves: state.numberOfMoves - 1,
        lastTappedTile: Tile(
            correct: lastTapped[0],
            // current: lastTapped[2],
            // correct: lastTapped[1],
            isW: lastTapped[1]),
      ),
    );
  }

  void _onPuzzleSolve(PuzzleSolve event, Emitter<PuzzleState> emit) {
    // final puzzle = _generatePuzzle(_size);
    emit(state.copyWith(
      // puzzle: state.puzzle?.sort(),
      puzzle: state.puzzle,
      // puzzleStatus: PuzzleStatus.complete,
      // numberOfCorrectTiles: state.puzzle.getNumberOfCorrectTiles()
    )
        // PuzzleState(
        //   puzzle: puzzle.sort(),
        //   numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
        // ),
        );
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) {
    final puzzle = generatePuzzle(state.puzzle?.dimention ?? 4, shuffle: false);
    history.clear();
    emit(state.copyWith(
      puzzle: puzzle,
      tileMovementStatus: TileMovementStatus.nothingTapped,
      numberOfMoves: 0,
      lastTappedTile: null,
      started: DateTime.now(),
    )
        // PuzzleState(
        //   puzzle: puzzle,
        //   image: state.image,

        //     // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
        //     ),
        );
  }

  // /// Build a randomized, solvable puzzle of the given size.
  // Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
  //   final correctPositions = <int>[];
  //   final currentPositions = <int>[];
  //   // final whitespacePosition = Position(x: size, y: size);
  //   final whitespacePosition = 16;

  //   // Create all possible board positions.
  //   for (var y = 1; y <= size; y++) {
  //     for (var x = 1; x <= size; x++) {
  //       if (x == size && y == size) {
  //         correctPositions.add(whitespacePosition);
  //         currentPositions.add(whitespacePosition);
  //       } else {
  //         final position = Position(x: x, y: y);
  //         correctPositions.add(position);
  //         currentPositions.add(position);
  //       }
  //     }
  //   }

  //   if (shuffle) {
  //     // Randomize only the current tile posistions.
  //     currentPositions.shuffle(random);
  //   }

  //   var tiles = _getTileListFromPositions(
  //     size,
  //     correctPositions,
  //     currentPositions,
  //   );

  //   var puzzle = Puzzle(tiles: tiles);

  //   if (shuffle) {
  //     // Assign the tiles new current positions until the puzzle is solvable and
  //     // zero tiles are in their correct position.
  //     while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
  //       currentPositions.shuffle(random);
  //       tiles = _getTileListFromPositions(
  //         size,
  //         correctPositions,
  //         currentPositions,
  //       );
  //       puzzle = Puzzle(tiles: tiles);
  //     }
  //   }

  //   return puzzle;
  // }

  // List<Tile> _getTileListFromPositions(
  //   int size,
  //   List<Position> correctPositions,
  //   List<int> currentPositions,
  // ) {
  //   final whitespacePosition = Position(x: size, y: size);
  //   return [
  //     for (int i = 1; i <= size * size; i++)
  //       if (i == size * size)
  //         Tile(
  //           correct: i,
  //           // correct: whitespacePosition,
  //           current: currentPositions[i - 1],
  //           isW: true,
  //         )
  //       else
  //         Tile(
  //           correct: i,
  //           // correct: correctPositions[i - 1],
  //           current: currentPositions[i - 1],
  //         )
  //   ];
  // }

  _onMouseAutoClickChange(
    MouseAutoClickChange event,
    Emitter<PuzzleState> emit,
  ) {
    emit(state.copyWith(
        autoMouseClick: state.autoMouseClick == 0
            ? 1
            : state.autoMouseClick == 1
                ? 2
                : 0));
  }

  _onChangeBoardDimension(
    ChangeBoardDimension event,
    Emitter<PuzzleState> emit,
  ) {
    // add(PuzzleInitialized(
    //     dimension: state.puzzle!.dimention == 3 ? 4 : 3, shufflePuzzle: true,));
    final d = state.puzzle!.dimention;
    emit(
      PuzzleState(
          images: state.images,
          autoMouseClick: state.autoMouseClick,
          // imageWidth: state.imageWidth,
          started: DateTime.now(),
          // images: state.images,
          paletteGenerator: state.paletteGenerator,
          puzzle: generatePuzzle(
              d == 3
                  ? 4
                  : d == 4
                      ? 5
                      : 3,
              // state.puzzle!.image,
              shuffle: false)),
    );
    // final puzzle = generatePuzzle(
    // , state.puzzle!.image);
    // emit(state.copyWith(puzzle: puzzle)
    // PuzzleState(
    // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
    // started: DateTime.now()
    // ),
    // );
  }

  _onGPress(
    GPress event,
    Emitter<PuzzleState> emit,
  ) {
    emit(state.copyWith(isGPressed: event.isPressed));
  }

  _onPuzzleShuffle(
    PuzzleShuffle event,
    Emitter<PuzzleState> emit,
  ) {
    emit(state.copyWith(puzzle: generatePuzzle(state.puzzle!.dimention)));
  }

  _onPuzzlePeak(
    PuzzlePeak event,
    Emitter<PuzzleState> emit,
  ) {
    if (state.peaks > 0 || event.peak == false) {
      emit(state.copyWith(
          peak: event.peak, peaks: event.peak ? state.peaks - 1 : state.peaks));
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:slide_puzzle/models/position.dart';
import 'package:slide_puzzle/models/puzzle.dart';
import 'package:slide_puzzle/models/tile.dart';
import 'package:slide_puzzle/presentation/puzzle/blocs/puzzle_bloc/puzzle_bloc.dart';
import 'package:slide_puzzle/presentation/puzzle/widgets/puzzle_board.dart';
import 'package:slide_puzzle/presentation/puzzle/widgets/puzzle_tile.dart';

Widget boardBuilder(int size, List<Widget> tiles) {
  return
      // Stack(
      //   children: [
      //     Column(
      //       children: [
      //         const SizedBox(
      //           height: 32,
      //         ),
      // SizedBox.square(
      // child:
      PuzzleBoard(tiles: tiles)
      // ,
      // dimension: 400,
      // ),
      // const SizedBox(
      //   height: 32,
      // )
      // ],
      // ),
      // ],
      // )
      ;
}

@override
Widget tileBuilder(Tile tile, PuzzleState state) {
  return PuzzleTile(
    tile: tile,
    state: state,
  );
}

@override
Widget whitespaceTileBuilder(w, s) {
  // return const SizedBox();
  return s.images[w.correct-1];
}

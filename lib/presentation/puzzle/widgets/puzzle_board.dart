import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_puzzle/animations/star.dart';
import 'package:slide_puzzle/constants/TileSizes.dart';
import 'package:slide_puzzle/presentation/puzzle/blocs/puzzle_bloc/puzzle_bloc.dart';

class PuzzleBoard extends StatefulWidget {
  /// {@macro dashatar_puzzle_board}
  const PuzzleBoard({
    Key? key,
    required this.tiles,
  }) : super(key: key);

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  // Timer? _completePuzzleTimer;

  bool animatePuzzleFlare = false;
  bool animateBars = false;
  bool viewCorrect = false;

  @override
  void dispose() {
    // _completePuzzleTimer?.cancel();
    super.dispose();
  }

  final List largeList = [54.0, 123.0, 192.0, 260.0];
  final List mediumList = [58.0, 138.0, 213.0];
  final List smallList = [54.0, 123.0, 200.0];
  List list = [];
  int addedSize = 15;

  @override
  Widget build(BuildContext context) {
    final c = context
        .select((PuzzleBloc bloc) => bloc.state.puzzle?.isComplete ?? false);
    final dimension =
        context.select((PuzzleBloc bloc) => bloc.state.puzzle?.dimention);
    list = dimension == 3
        ? smallList
        : dimension == 4
            ? mediumList
            : largeList;
    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) async {
        if (state.puzzleStatus == PuzzleStatus.complete &&
            state.numberOfMoves > 0) {
          animatePuzzleFlare = true;
          animateBars = true;

          Timer(Duration(seconds: 3), () {
            setState(() {
              animatePuzzleFlare = false;
            });
            Timer(Duration(milliseconds: 500), () {
              setState(() {
                addedSize = 0;
                animateBars = false;
              });
            });
          });
        } else {
          setState(() {
            addedSize = 15;
          });
        }
        // if (state.puzzleStatus == PuzzleStatus.complete) {
        //   _completePuzzleTimer =
        //       Timer(const Duration(milliseconds: 370), () async {
        //     await showDialog<void>(
        //         context: context,
        //         builder: (context) {
        //           return const Text("complete");
        //         });
        //   });
        // }
      },
      child: Stack(children: [
        ...widget.tiles,
        // if (c)
        ...List.generate(
            sqrt(widget.tiles.length).toInt() - 1,
            (index) => AnimatedPositioned(
                left: 0.25,
                duration: Duration(milliseconds: 500),
                top: list[index] + addedSize,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF2CB05),
                        Color(0xFFF29F05),
                        Color(0xFFF28705),
                        Color(0xFFF25D07),
                        Color(0xFF8C0303),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, .5, .7, .8, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  height: 12,
                  width: animateBars
                      ? sqrt(widget.tiles.length) *
                              TileSizes.getSizeFromDimension(dimension) +
                          addedSize
                      : 0,
                  // color: Colors.deepOrange
                ))),
        IgnorePointer(
          child: Stack(children: [
            // if (c)
            ...List.generate(
                sqrt(widget.tiles.length).toInt() - 1,
                (index) => AnimatedPositioned(
                    top: 0.25,
                    duration: Duration(milliseconds: 500),
                    left: list[index] + addedSize,
                    child: AnimatedContainer(
                      width: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF2CB05),
                            Color(0xFFF29F05),
                            Color(0xFFF28705),
                            Color(0xFFF25D07),
                            Color(0xFF8C0303),
                          ],
                          // begin: const FractionalOffset(0.0, 0.0),
                          // end: const FractionalOffset(1.0, 0.0),
                          begin: Alignment(-1.0, -1),
                          end: Alignment(-1.0, 1),
                          stops: [0.0, .5, .7, .8, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                      height: animateBars
                          ? sqrt(widget.tiles.length) *
                                  TileSizes.getSizeFromDimension(dimension) +
                              addedSize
                          : 0,
                      // color: Colors.deepOrange
                    ))),
            // if (c)

            ...List.generate(
                sqrt(widget.tiles.length).toInt() - 1,
                (index) => AnimatedPositioned(
                      left: list[index] + addedSize,
                      duration: Duration(seconds: 3),
                      top: animatePuzzleFlare
                          ? sqrt(widget.tiles.length) *
                                  TileSizes.getSizeFromDimension(dimension) +
                              13
                          : 2,
                      child: Sparkling(
                        horizontal: false,
                        animate: animatePuzzleFlare,
                      ),
                    )),
            // if (c)
            ...List.generate(
                sqrt(widget.tiles.length).toInt() - 1,
                (index) => AnimatedPositioned(
                      top: list[index] + addedSize,
                      duration: Duration(seconds: 3),
                      left: animatePuzzleFlare
                          ? sqrt(widget.tiles.length) *
                                  TileSizes.getSizeFromDimension(dimension) +
                              13
                          : 2,
                      child: Sparkling(
                        horizontal: true,
                        animate: animatePuzzleFlare,
                      ),
                    )),
            // if (viewCorrect)
            //   FadeInImage(
            //       fadeInCurve: Curves.bounceOut,
            //       fadeInDuration: Duration(seconds: 2),
            //       fit: BoxFit.cover,
            //       width: sqrt(widget.tiles.length) * 74 + 27,
            //       placeholder: NetworkImage(
            //           "https://www.iconsdb.com/icons/preview/white/square-xxl.png"),
            //       image: AssetImage("assets/images/green/green.png"))
            // Image.asset(
            //   "assets/images/green/green.png",
            //   fit: BoxFit.cover,
            //   width: sqrt(widget.tiles.length) * 74 + 3,
            // ),
          ]),
        )
      ]),
    );
  }
}

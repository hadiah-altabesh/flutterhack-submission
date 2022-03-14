import 'dart:async';
import 'dart:typed_data';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_puzzle/constants/TileSizes.dart';
import 'package:slide_puzzle/models/tile.dart';
import 'package:slide_puzzle/presentation/puzzle/blocs/puzzle_bloc/puzzle_bloc.dart';
import 'package:slide_puzzle/presentation/puzzle/blocs/clock_bloc/clock_bloc.dart';
import 'package:slide_puzzle/utils/duration.dart';
import 'package:slide_puzzle/utils/functions.dart';
import 'package:slide_puzzle/utils/ticker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:holding_gesture/holding_gesture.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage(
      {Key? key,
      this.puzzleImage,
      this.networkPuzzleImage,
      required this.dimension})
      : super(key: key);
  final Uint8List? puzzleImage;
  final Uri? networkPuzzleImage;
  final int dimension;

  @override
  PuzzlePageState createState() => PuzzlePageState();
}

class PuzzlePageState extends State<PuzzlePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => PuzzleBloc()
              ..add(PuzzleInitialized(
                dimension: widget.dimension,
                image: widget.puzzleImage,
                networkImage: widget.networkPuzzleImage,
                shufflePuzzle: false,
              ))),
        BlocProvider(create: (_) => ClockBloc(ticker: Ticker())
            // ..add(const PuzzleInitialized(
            //   shufflePuzzle: false,
            // ))
            )
      ],
      child: const PuzzleView(),
    );
  }
}

class PuzzleView extends StatefulWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  _PuzzleViewState createState() => _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 10));
  late final FocusNode focus;
  late final FocusAttachment _nodeAttachment;
  bool isGPressed = false;
  final GlobalKey imageKey = GlobalKey();
  PaletteGenerator? paletteGenerator;

  Future<void> _updatePaletteGenerator({Rect? reigon, image}) async {
    paletteGenerator =
        await PaletteGenerator.fromImageProvider(image, maximumColorCount: 5);
    setState(() {});
  }

  @override
  void initState() {
    // _confettiController = ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
    focus = FocusNode(debugLabel: 'Button');
    _nodeAttachment = focus.attach(context, onKey: (node, event) {
      // isGPressed = event.isKeyPressed(LogicalKeyboardKey.keyG);
      context
          .read<PuzzleBloc>()
          .add(GPress(isPressed: event.isKeyPressed(LogicalKeyboardKey.keyG)));
      return KeyEventResult.handled;
    });
    focus.requestFocus();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    focus.dispose();
    super.dispose();
  }


  void _updateLoading(bool value) {
    if (mounted) {
      context.read<PuzzleBloc>().add(PuzzlePeak(peak: value));
      // setState(() {
      //   _isLoading = value;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    _nodeAttachment.reparent();
    final colors = context.select(
        (PuzzleBloc bloc) => bloc.state.paletteGenerator?.colors.toList());
    final historyLength =
        context.select((PuzzleBloc bloc) => bloc.history.length);
    final numberOfMoves =
        context.select((PuzzleBloc bloc) => bloc.state.numberOfMoves);
    final peak =
        context.select((PuzzleBloc bloc) => bloc.state.peak);
    final peaks =
        context.select((PuzzleBloc bloc) => bloc.state.peaks);
    int autoMouseClick =
        context.select((PuzzleBloc bloc) => bloc.state.autoMouseClick);
    int? dimension =
        context.select((PuzzleBloc bloc) => bloc.state.puzzle?.dimention);
    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (ctxt, state) {
        // _updatePaletteGenerator(image: AssetImage(state.image));
        if (state.puzzleStatus == PuzzleStatus.complete &&
            state.numberOfMoves > 0) {
          Timer(const Duration(seconds: 8), () {
            _confettiController.play();
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: colors ?? [Colors.white, Colors.white],
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
                radius: 0.95,
                tileMode: TileMode.mirror
                // tileMode: TileMode.repeated,
                )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: LayoutBuilder(builder: (context, constraints) {
            return Center(
              child: Stack(
                children: [
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 25,
                    gravity: 0.05,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 32,
                            ),
                            PuzzleHeader(),
                            SizedBox(
                              height: 32,
                            ),
                            PuzzleBoard(),
                            ElevatedButton(
                                child: Text("shuffle"),
                                onPressed: () {
                                  context
                                      .read<PuzzleBloc>()
                                      .add(const PuzzleShuffle());
                                  context
                                      .read<ClockBloc>()
                                      .add(const ClockReset());
                                  context.read<ClockBloc>().add(
                                      const ClockStarted(
                                          clockType: ClockType.stopwatch,
                                          duration: 0));
                                }),
                            ElevatedButton(
                                child: Text("reset"),
                                onPressed: () {
                                  context.read<PuzzleBloc>().add(PuzzleReset());
                                  context
                                      .read<ClockBloc>()
                                      .add(const ClockReset());
                                  context
                                      .read<ClockBloc>()
                                      .add(const ClockReset());
                                }),
                            ElevatedButton(
                                child: Text(
                                  "Undo (${historyLength})",
                                ),
                                onPressed: historyLength != 0
                                    ? () {
                                        context
                                            .read<PuzzleBloc>()
                                            .add(const PuzzleUndo());
                                      }
                                    : null),
                            ElevatedButton(
                              
                                child: Text(
                                    "Solve ${numberOfMoves >= 500 ? '' : '(' + (500 - numberOfMoves).toString() + ' left to unlock)'} (Not functional yet!)"),
                              
                                onPressed:
                                //  numberOfMoves >= 500
                                //     ? () {
                                //         context
                                //             .read<PuzzleBloc>()
                                //             .add(const PuzzleSolve());
                                //       }
                                //     : null
                                null
                                    ),
                            ElevatedButton(
                                child: Text("${autoMouseClick != 2 ? 'Auto' : 'Manual'} Mouse Click ${autoMouseClick == 1 ? '(on G press)':''}"),
                                onPressed: () {
                                  context
                                      .read<PuzzleBloc>()
                                      .add(const MouseAutoClickChange());
                                }),

                            HoldTimeoutDetector(
                              onTimeout: () {
                                _updateLoading(false);
                              },
                              onTimerInitiated: () => _updateLoading(true),
                              onCancel: () => _updateLoading(false),
                              holdTimeout: Duration(milliseconds: 5000),
                              enableHapticFeedback: true,
                              child: ElevatedButton.icon(
                                onPressed: peaks >0? () {}: null,
                                
                                label: Text("Hold to Peak (5s)($peaks more)"),
                                icon: peak
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(Icons.timer_sharp),
                              ),
                            ),

                            // ElevatedButton(
                            //     child: Text("3x3 || 4x4 || 5x5"),
                            //     onPressed: () {
                            //       context
                            //           .read<PuzzleBloc>()
                            //           .add(const ChangeBoardDimension());
                            //     }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PuzzleHeader extends StatefulWidget {
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  _PuzzleHeaderState createState() => _PuzzleHeaderState();
}

class _PuzzleHeaderState extends State<PuzzleHeader> {
  @override
  Widget build(BuildContext context) {
    final duration = context.select((ClockBloc bloc) => bloc.state.duration);
    return Column(
      children: [
        Text(
            "Timer:${(duration ~/ 60 ~/ 60).toString().padLeft(2, '0')}:${(duration ~/ 60).toString().padLeft(2, '0')}:${(duration % 60).toString().padLeft(2, '0')} "),
        Text(
            "Moves: ${context.select((PuzzleBloc bloc) => bloc.state.numberOfMoves)}"),
        Text(
            "% Correct: ${context.select((PuzzleBloc bloc) => (bloc.state.numberOfCorrectTiles / ((bloc.state.puzzle?.tiles.length ?? 0) - 1) * 100).toInt())}"),
        Text(
            "Correct: ${context.select((PuzzleBloc bloc) => (bloc.state.numberOfCorrectTiles))} || Left: ${context.select((PuzzleBloc bloc) => (bloc.state.numberOfTilesLeft))}"),
      ],
    );
  }
}

class PuzzleBoard extends StatefulWidget {
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  _PuzzleBoardState createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  double addedSize = 0;
  @override
  Widget build(BuildContext context) {
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);
    final puzzleSize = puzzle?.dimention ?? 0;
    // final size = MediaQuery.of(context).size;
    // final portrait = size.height > size.width;
    // final puzzleBoardSize = portrait ? size.width * .8 : size.height * .8;
    // final s = context.select((ClockBloc bloc) => bloc.state);
    // final boardSize = 290.0+(puzzleSize==3?0:puzzleSize==4?10:70);
    if (puzzleSize == 0) return const CircularProgressIndicator();
    final double mainBoardSize =
        TileSizes.getBoardSizeFromDimension(puzzleSize);

    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) {
        if ((state.puzzle?.isComplete ?? false) && addedSize != 0) {
          Timer(Duration(seconds: 3, milliseconds: 500), () {
            setState(() {
              addedSize = 0;
            });
          });
        } else {
          if (state.numberOfMoves > 0 ||
              (!(state.puzzle?.isComplete ?? false))) {
            addedSize = 15;
          }
        }
        // }
        // if (s is ClockRunInProgress) {
        //   context.read<ClockBloc>().add(const ClockPaused());
        // }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: TileSizes.getBoardSizeFromDimension(puzzleSize) +
                addedSize +
                10,
            width: TileSizes.getBoardSizeFromDimension(puzzleSize) +
                addedSize +
                10,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: TileSizes.getBoardSizeFromDimension(puzzleSize) + addedSize,
            width: TileSizes.getBoardSizeFromDimension(puzzleSize) + addedSize,
            child: puzzle != null
                ? boardBuilder(
                    puzzleSize,
                    puzzle.tiles
                        .map(
                          (tile) => PuzzleTile(
                            key: Key('puzzle_tile_${tile.correct.toString()}'),
                            tile: tile,
                          ),
                        )
                        .toList(),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({Key? key, required this.tile}) : super(key: key);
  final Tile tile;

  @override
  _PuzzleTileState createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<PuzzleTile> {
  @override
  Widget build(BuildContext context) {
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    return
        // widget.tile.isW
        // ? whitespaceTileBuilder(widget.tile, state)
        // :
        tileBuilder(widget.tile, state);
  }
}

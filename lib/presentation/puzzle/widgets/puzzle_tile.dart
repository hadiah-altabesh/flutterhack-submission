import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slide_puzzle/constants/TileSizes.dart';
import 'package:slide_puzzle/models/tile.dart';
import 'package:slide_puzzle/presentation/puzzle/blocs/puzzle_bloc/puzzle_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;

class PuzzleTile extends StatefulWidget {
  /// {@macro dashatar_puzzle_tile}
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
    // AudioPlayerFactory? audioPlayer,
  }) :
        // _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  // final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<PuzzleTile> createState() => PuzzleTileState();
}

/// The state of [PuzzleTile].
@visibleForTesting
class PuzzleTileState extends State<PuzzleTile>
    with SingleTickerProviderStateMixin {
  // AudioPlayer? _audioPlayer;
  // late final Timer _timer;

  /// The controller that drives [_scale] animation.
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150)
            //  duration: PuzzleThemeAnimationDuration.puzzleTileScale,
            );

    _scale = Tween<double>(begin: 1, end: 0.88).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    // Delay the initialization of the audio player for performance reasons,
    // to avoid dropping frames when the theme is changed.
    // _timer = Timer(const Duration(seconds: 1), () {
    //   _audioPlayer = widget._audioPlayerFactory()
    //     ..setAsset('assets/audio/tile_move.mp3');
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    // _timer.cancel();
    // _audioPlayer?.dispose();
    super.dispose();
  }

  Future<int> _calculateImageDimension(i) {
    Completer<int> completer = Completer();
    Image image = Image.asset(i);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          // if (myImage.width != imW) {
          setState(() {
            imW = myImage.width;
          });
          // }
          // Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(myImage.width);
        },
      ),
    );
    return completer.future;
  }

  int imW = 0;

  @override
  Widget build(BuildContext context) {
    // final size = widget.state.puzzle!.dimention;
    // final theme = context.select((DashatarThemeBloc bloc) => bloc.state.theme);

    // final status =
    //     context.select((PuzzleBloc bloc) => bloc.state.status);

    // final hasStarted = status == DashatarPuzzleStatus.started;
    final hasStarted = true;

    final isComplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.complete;
    final isGPressed =
        context.select((PuzzleBloc bloc) => bloc.state.isGPressed);
    final autoMouseClick =
        context.select((PuzzleBloc bloc) => bloc.state.autoMouseClick);
    final board = context.select((PuzzleBloc bloc) => bloc.state.puzzle);
    final peak = context.select((PuzzleBloc bloc) => bloc.state.peak);

    // final movementDuration = status == DashatarPuzzleStatus.loading
    //     ? const Duration(milliseconds: 800)
    //     : const Duration(milliseconds: 370);
    const movementDuration = Duration(milliseconds: 800);
    // final image = context.select((PuzzleBloc bloc) => bloc.state.image);
    final images = context.select((PuzzleBloc bloc) => bloc.state.images);

    // final canPress = hasStarted && puzzleIncomplete;
    const canPress = true;
    int index = peak ? widget.tile.correct-1 : board!.tiles.indexOf(widget.tile);
    int boardDimension = board!.dimention;
    final x = ((index) % boardDimension) / (boardDimension - 1);
    final y = ((index) ~/ boardDimension) / (boardDimension - 1);
    final tileSize = TileSizes.getSizeFromDimension(boardDimension);
    // img.Image.
    // _calculateImageDimension(image).then((size) {});
    // if(imW==0) {
    //   _calculateImageDimension(image);
    // }

    return AnimatedAlign(
      alignment: FractionalOffset(
        // x - (isComplete ? 0.068 * x : 0),
        // y - (isComplete ? 0.068 * y : 0),
        x,
        y,
      ),
      duration: movementDuration,
      curve: Curves.easeInOut,
      child: MouseRegion(
        onEnter: (PointerEvent e) {
          if (canPress) {
            _controller.forward();
            if (autoMouseClick != 2) {
              if (autoMouseClick == 1 && !isGPressed) return;
              context.read<PuzzleBloc>().add(TileTapped(widget.tile));
            }
          }
        },
        onExit: (_) {
          if (canPress) {
            _controller.reverse();
          }
        },
        child: !widget.tile.isW || widget.tile.isW && isComplete
            ? ScaleTransition(
                key: Key('dashatar_puzzle_tile_scale_${widget.tile.correct}'),
                scale: _scale,
                child: SizedBox.square(
                  dimension: tileSize,
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: (!isComplete)
                            ? [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.75),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(2, 2))
                              ]
                            : []),
                    child: index < images.length
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: canPress
                                ? () {
                                    context
                                        .read<PuzzleBloc>()
                                        .add(TileTapped(widget.tile));
                                    // unawaited(_audioPlayer?.replay());
                                  }
                                : null,
                            icon: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  (!isComplete) ? 4.0 : 0.0),
                              // child: Image.asset(
                              //   image,
                              //   // cacheWidth: (tileSize * boardDimension).toInt(),
                              //   // cacheHeight: (tileSize * boardDimension).toInt(),
                              //   scale: imW / (tileSize * boardDimension),
                              //   alignment: FractionalOffset(
                              //       ((widget.tile.correct - 1) % boardDimension) /
                              //           (boardDimension - 1),
                              //       ((widget.tile.correct - 1) ~/ boardDimension) /
                              //           (boardDimension - 1)),
                              //   fit: BoxFit.none,
                              //   // width: tileSize,

                              //   // semanticLabel: context.l10n.puzzleTileLabelText(
                              //   //   widget.tile.value.toString(),
                              //   //   widget.tile.currentPosition.x.toString(),
                              //   //   widget.tile.currentPosition.y.toString(),
                              //   // ),
                              // ),
                              child: images[widget.tile.correct - 1],
                              // child: Image(
                              //   image: image2,

                              //   alignment: FractionalOffset(
                              //       ((widget.tile.correct - 1) % boardDimension) /
                              //           (boardDimension - 1),
                              //       ((widget.tile.correct - 1) ~/ boardDimension) /
                              //           (boardDimension - 1)),
                              // )
                            ),
                          )
                        : ElevatedButton(
                            // padding: EdgeInsets.zero,
                            onPressed: canPress
                                ? () {
                                    context
                                        .read<PuzzleBloc>()
                                        .add(TileTapped(widget.tile));
                                    // unawaited(_audioPlayer?.replay());
                                  }
                                : null,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  // if (states.contains(MaterialState.pressed))
                                  return Colors.black87;
                                  // return null; // Use the component's default.
                                },
                              ),
                            ),
                            child: Text(
                              "${widget.tile.correct}",
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                  ),
                ))
            : SizedBox(),
      ),
      // ),
    );
  }
}

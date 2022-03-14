import 'package:equatable/equatable.dart';
import 'package:slide_puzzle/models/position.dart';

class Tile extends Equatable {
  final int correct;
  // final int current;
  // final Position currentPosition;
  // Position correct(d) => Position(x: (value-1)/(d-1), y: y);
  final bool isW;



  const Tile(
      {required this.correct,
      // required this.current,
      // required this.correct,
      this.isW = false
      });


  @override
  List<Object?> get props => [correct, isW];

  Tile copyWith({ int? current}) {
    return Tile(
      correct: correct,
      // correct: correct,
      // current: current,
      isW: isW,
    );
  }

  // bool get isCorrect {
  //   return current == correct;
  // }
}

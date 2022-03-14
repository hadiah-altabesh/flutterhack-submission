import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:slide_puzzle/models/puzzle.dart';
import 'package:slide_puzzle/models/position.dart';
import 'package:slide_puzzle/models/tile.dart';
import 'package:slide_puzzle/utils/functions2.dart';

class Node extends Equatable {
  Puzzle puzzle;
  int level;
  Node? p;
  Node({required this.puzzle, this.level = 0, this.p});

  int get fScore => level + puzzle.manhattanDistance(puzzle.tiles);
  // int get fScore => level + puzzle.tiles.length - puzzle.getNumberOfCorrectTiles();

  @override
  List<Object?> get props => [puzzle, level];

  // @override
  // toString() {
  //   return fScore.toString();
  // }

  Node copyWith({puzzle, level}) {
    return Node(puzzle: puzzle ?? this.puzzle, level: level ?? this.level);
  }
}

void main() {
  // List<Node> open = [];
  List<Node> closed = [];
  final open = PriorityQueue<Node>((a, b) => a.fScore.compareTo(b.fScore));
  // queue..add('foo')..add('bazars')..add('zort');
  // open..add(Node(puzzle: generatePuzzle(3)));
  // open.add(Node(
  //     puzzle: Puzzle(
  //         tiles: [16, 1, 3, 4, 5, 2, 6, 8, 13, 10, 7, 11, 14, 9, 15, 12]
  //             .map((e) => Tile(correct: e, isW: e == 16))
  //             .toList()
  //         // [
  //         //   Tile(correct: 0),
  //         //   Tile(correct: 1),
  //         //   Tile(correct: 2),
  //         //   Tile(correct: 3),
  //         //   Tile(correct: 4),
  //         //   Tile(correct: 5),
  //         //   Tile(correct: 6),
  //         //   Tile(correct: 7),
  //         //   Tile(correct: 8),
  //         //   Tile(correct: 9),
  //         //   Tile(correct: 10),
  //         //   Tile(correct: 11),
  //         //   Tile(correct: 12),
  //         //   Tile(correct: 13),
  //         //   Tile(correct: 14),
  //         //   Tile(correct: 15, isW: true),
  //         // ]
  //         )));

  // open.add(Node(puzzle: generatePuzzle(4)));
  int i = 0;
  // while (i < 2) {
    while (true) {
    i++;
    Node n = open.removeFirst();
    Puzzle b = n.puzzle;

    // while (closed.any((element) => IterableEquality()
    //     .equals(element.puzzle.tiles, b.tiles))) {
    //     // .equals(element.puzzle.tiles, b.tiles.map((e) => e.correct).toList()))) {
    //   // closed.add(n);
    //   print("r");
    //   // print(n);
    //   n = open.removeFirst();
    //   b = n.puzzle;
    // }
    final w = b.getWhitespace();

    b.printPuzzle();

    if (b.isComplete) {
      print("complete");
      break;
    }

    List<Node> wMoves = b
        .getWhiteMoves()
        .map((e) => Node(puzzle: e, level: n.level + 1, p: n))
        .toList();

    // for (var element1 in open.toList()) {
    //   wMoves.removeWhere((element2) => element1.puzzle == element2.puzzle);
    // }
    // for (var element1 in closed) {
    //   wMoves.removeWhere((element2) => element1.puzzle == element2.puzzle);
    // }

    // print("--------");
    // for(final x in wMoves) {
    //   x.puzzle.printPuzzle();
    // print("--------");
    // }

    // wMoves.removeWhere(
    //     (element) => open.contains(element) || closed.contains(element));
    // .removeWhere((element) => open.contains(element))

    open.addAll(wMoves);
    // code snippet 1
    closed.add(n);
    print("===============");
    print(b.getNumberOfCorrectTiles());
    print(b.manhattanDistance(b.tiles));
    print(n.fScore);
    // print(open.toList().map((e) => e.fScore));
    // open.sort((a, b) {
    //   return a.fScore.compareTo(b.fScore);
    // });

    // print('* ${queue.removeFirst().tiles}');
  }
}



// code snippet 1 start

    // b.isIn(x)
    // print(b.dimention);
    // print(w.current.props);
    // print(w.correct.props);
    // print(b.isIn(w.current));
    // print(b.isIn(w.correct));
    // for (int i = 0; i < b.dimention; i++) {
    //   if (b.isIn(Position(x: w.current.x + row[i], y: w.current.y + col[i]))) {
    //     print("in");
    //     print([w.current.x + row[i], w.current.y + col[i]]);
    //     print(b.moveTiles(
    //             b.tiles.firstWhere((element) =>
    //                 element.current ==
    //                 Position(x: w.current.x + row[i], y: w.current.y + col[i])),
    //             []).getWhitespace().current.props);
    //     open.add(Node(
    //         puzzle: b.moveTiles(
    //             b.tiles.firstWhere((element) =>
    //                 element.current ==
    //                 Position(x: w.current.x + row[i], y: w.current.y + col[i])),
    //             [])));

    //   }
    // }

// code snippet 1 end
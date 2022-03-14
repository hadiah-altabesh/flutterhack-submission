import 'package:slide_puzzle/models/tile.dart';
main() {
  final l = [Tile(correct: 3, isW: false), Tile(correct: 4, isW: true), Tile(correct: 2, isW: false), Tile(correct: 1, isW: false)];
  print(l.indexOf(Tile(correct: 4),2));
  // l[1] = 3;
  // l[2] = 2;
  // print(l.indexOf(2));
  // print((9)~/(4-1));
  // print(12%4);
  // print(7);
}

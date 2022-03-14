// // // // // from collections import deque
// // // // // from itertools import chain, tee
// // // // // from math import sqrt
// // // // // from random import choice

// // // // import 'dart:math';

// // // // class Puzzle {
// // // //     static const int HOLE = 0;
// // // //     Puzzle(this.board, hole_location, int? width) : super() {
// // // //         hole = hole_location? hole_location != null :board.elementAt(HOLE);
// // // //         this.width = width ?? sqrt(board.length).toInt();
// // // //     }
// // // //     List<List<int>> board;
// // // //     late int width;

// // // //     bool get solved => board == List<dynamic>.generate(width * width-1, (index) => null) + [Puzzle.HOLE];

// // // //     possible_moves() sync* {
// // // //         // # Up, down
// // // //         for (final dest in [hole - width, hole + width]){
// // // //             if (0 <= dest && dest < board.length) {
// // // //               yield dest;
// // // //             }
// // // //               }
// // // //         // # Left, right
// // // //         for (final dest in [hole - 1, hole + 1]){
// // // //             if( dest ~/ width == hole ~/ width){
// // // //                 yield dest;}
// // // //     }}
// // // //     move(self, destination){
// // // //         board = self.board[:]
// // // //         board[hole] = board[hole]
// // // //          board[destination] = board[destination]
// // // //         return Puzzle(board, destination, self.width)
// // // //     }
// // // //     def shuffle(self, moves=1000):
// // // //         """
// // // //         Return a new puzzle that has been shuffled with random moves
// // // //         """
// // // //         p = self
// // // //         for _ in range(moves):
// // // //             p = p.move(choice(list(p.possible_moves)))
// // // //         return p

// // // //     @staticmethod
// // // //     def direction(a, b):
// // // //         """
// // // //         The direction of the movement of the hole (L, R, U, or D) from a to b.
// // // //         """
// // // //         if a is None:
// // // //             return None
// // // //         return {
// // // //                      -a.width: 'U',
// // // //             -1: 'L',    0: None,    +1: 'R',
// // // //                      +a.width: 'D',
// // // //         }[b.hole - a.hole]

// // // //     def __str__(self):
// // // //         return "\n".join(str(self.board[start : start + self.width])
// // // //                          for start in range(0, len(self.board), self.width))

// // // //     def __eq__(self, other):
// // // //         return self.board == other.board

// // // //     def __hash__(self):
// // // //         h = 0
// // // //         for value, i in enumerate(self.board):
// // // //             h ^= value << i
// // // //         return h

// // // // class MoveSequence:
// // // //     """
// // // //     Represents the successive states of a puzzle taken to reach an end state.
// // // //     """
// // // //     def __init__(self, last, prev_holes=None):
// // // //         self.last = last
// // // //         self.prev_holes = prev_holes or []

// // // //     def branch(self, destination):
// // // //         """
// // // //         Makes a MoveSequence with the same history followed by a move of
// // // //         the hole to the specified destination index.
// // // //         """
// // // //         return MoveSequence(self.last.move(destination),
// // // //                             self.prev_holes + [self.last.hole])

// // // //     def __iter__(self):
// // // //         """
// // // //         Generator of puzzle states, starting with the initial configuration
// // // //         """
// // // //         states = [self.last]
// // // //         for hole in reversed(self.prev_holes):
// // // //             states.append(states[-1].move(hole))
// // // //         yield from reversed(states)

// // // // class Solver:
// // // //     """
// // // //     An '8-puzzle' solver
// // // //     - 'start' is a Puzzle instance
// // // //     """
// // // //     def __init__(self, start):
// // // //         self.start = start

// // // //     def solve(self):
// // // //         """
// // // //         Perform breadth-first search and return a MoveSequence of the solution,
// // // //         if it exists
// // // //         """
// // // //         queue = deque([MoveSequence(self.start)])
// // // //         seen  = set([self.start])
// // // //         if self.start.solved:
// // // //             return queue.pop()

// // // //         for seq in iter(queue.pop, None):
// // // //             for destination in seq.last.possible_moves:
// // // //                 attempt = seq.branch(destination)
// // // //                 if attempt.last not in seen:
// // // //                     seen.add(attempt.last)
// // // //                     queue.appendleft(attempt)
// // // //                     if attempt.last.solved:
// // // //                         return attempt

// // // // # https://docs.python.org/3/library/itertools.html#itertools-recipes
// // // // def pairwise(iterable):
// // // //     "s -> (s0,s1), (s1,s2), (s2, s3), ..."
// // // //     a, b = tee(iterable)
// // // //     next(b, None)
// // // //     return zip(a, b)

// // // // if __name__ == '__main__':
// // // //     board = [[1,2,3],
// // // //              [4,0,6],
// // // //              [7,5,8]]

// // // //     puzzle = Puzzle(board).shuffle()
// // // //     print(puzzle)
// // // //     move_seq = iter(Solver(puzzle).solve())
// // // //     for from_state, to_state in pairwise(move_seq):
// // // //         print()
// // // //         print(Puzzle.direction(from_state, to_state))
// // // //         print(to_state)
// // // // }

// // // class Node {
// // //   List data;
// // //   int level;
// // //   int fval;
// // //   Node({required this.data, required this.level, required this.fval});

// // //   generate_child() {
// // //     // final x, y = find(data,'_');
// // //     final l = find(data, '_');
// // //     final x = l[0];
// // //     final y = l[1];

// // //     List val_list = [
// // //       [x, y - 1],
// // //       [x, y + 1],
// // //       [x - 1, y],
// // //       [x + 1, y]
// // //     ];
// // //     List children = [];
// // //     for (final i in val_list) {
// // //       List? child = shuffle(data, x, y, i[0], i[1]);
// // //       if (child != null) {
// // //         Node child_node = Node(data: child, level: level + 1, fval: 0);
// // //         children.add(child_node);
// // //       }
// // //     }
// // //     return children;
// // //   }

// // //   shuffle(puz, x1, y1, x2, y2) {
// // //     if (x2 >= 0 && x2 < data.length && y2 >= 0 && y2 < data.length) {
// // //       // List temp_puz = []
// // //       List temp_puz = copy(puz);
// // //       final temp = temp_puz[x2][y2];
// // //       temp_puz[x2][y2] = temp_puz[x1][y1];
// // //       temp_puz[x1][y1] = temp;
// // //       return temp_puz;
// // //     } else {
// // //       return;
// // //     }
// // //   }

// // //   copy(root) {
// // //     // """ Copy function to create a similar matrix of the given node"""
// // //     List temp = [];
// // //     for (final i in root) {
// // //       List t = [];
// // //       for (final j in i) {
// // //         t.add(j);
// // //       }
// // //       temp.add(t);
// // //     }
// // //     return temp;
// // //   }

// // //   find(puz, x) {
// // //     // """ Specifically used to find the position of the blank space """
// // //     for (final i in List.generate(data.length, (index) => index)) {
// // //       for (final j in List.generate(data.length, (index) => index)) {
// // //         if (puz[i][j] == x) {
// // //           return [i, j];
// // //         }
// // //       }
// // //     }
// // //   }
// // // }

// // // class Puzzle {
// // //   // def __init__(self,size):
// // //   //     """ Initialize the puzzle size by the specified size,open and closed lists to empty """
// // //   //     self.n = size
// // //   //     self.open = []
// // //   //     self.closed = []
// // //   Puzzle({required this.n});
// // //   int n;
// // //   List open = [];
// // //   List closed = [];

// // //   // accept(){
// // //   //     // """ Accepts the puzzle from the user """
// // //   //     List puz = [];
// // //   //     for (final i in List.generate(n, (index) => index)){
// // //   //         List temp = input().split(" ");
// // //   //         puz.append(temp);
// // //   //       }
// // //   //     return puz
// // //   // }
// // //   f(start, goal) {
// // //     return h(start.data, goal) + start.level;
// // //   }

// // //   h(start, goal) {
// // //     int temp = 0;
// // //     for (final i in List.generate(n, (index) => index)) {
// // //       for (final j in List.generate(n, (index) => index)) {
// // //         if (start[i][j] != goal[i][j] && start[i][j] != '_') {
// // //           temp += 1;
// // //         }
// // //       }
// // //     }
// // //     return temp;
// // //   }

// // //   process(start, goal) {
// // //     // """ Accept Start and Goal Puzzle state"""
// // //     // print("Enter the start state matrix \n");
// // //     // List start = self.accept()
// // //     // print("Enter the goal state matrix \n");
// // //     // List goal = self.accept()

// // //     start = Node(data: start, level: 0, fval: 0);
// // //     start.fval = f(start, goal);
// // //     // """ Put the start node in the open list"""
// // //     open.add(start);
// // //     // print("\n\n");
// // //     while (true) {
// // //       final cur = open[0];
// // //       // print("");
// // //       // print("  | ");
// // //       // print("  | ");
// // //       // print(" \\\'/ \n");
// // //       for (final i in cur.data) {
// // //         for (final j in i) {
// // //           // print(j);
// // //           // print(j, end = " ");
// // //         }
// // //         // print("");
// // //       }
// // //       // """ If the difference between current and goal node is 0 we have reached the goal node"""
// // //       print(h(cur.data, goal));
// // //       if (h(cur.data, goal) == 0) {
// // //         break;
// // //       }
// // //       for (final i in cur.generate_child()) {
// // //         i.fval = f(i, goal);
// // //         open.add(i);
// // //       }
// // //       closed.add(cur);
// // //       open.removeAt(0);

// // //       // """ sort the opne list based on f value """
// // //       // open.sort(key = lambda x:x.fval,reverse=False)
// // //       open.sort((x, y) => x.fval.compareTo(y.fval));
// // //     }
// // //   }
// // // }

// // // void main(List<String> args) {
// // //   final puz = Puzzle(n: 4);
// // //   puz.process([
// // //     [4, 10, 14, 5],
// // //     [9, 12, 13, 6],
// // //     [11, 8, 1, 3],
// // //     [7, 15, 2, '_']
// // //   ], [
// // //     [1, 2, 3, 4],
// // //     [5, 6, 7, 8],
// // //     [9, 10, 11, 12],
// // //     [13, 14, 15, '_']
// // //   ]);
// // // }

// // // import java.util.Arrays;
// // // import java.util.Comparator;
// // // import java.util.HashSet;
// // // import java.util.PriorityQueue;
// // import 'package:collection/collection.dart';
// // class State {
// //   List tiles;    // Tiles left to right, top to bottom.
// //   int spaceIndex;   // Index of space (zero) in tiles
// //   int g;            // Number of moves from start.
// //   int h;            // Heuristic value (difference from goal)
// //   State? prev;       // Previous state in solution chain.

// //         // A* priority function (often called F in books).
// //     priority() {
// //         return g + h;
// //     }

// //         // Build a start state.
// //         State(initial) :super() {
// //             tiles = initial;
// //             spaceIndex = tiles[0];
// //             g = 0;
// //             h = heuristic(tiles);
// //             prev = null;
// //         }

// //         // Build a successor to prev by sliding tile from given index.
// //         State(State prev, int slideFromIndex) {
// //             tiles = Arrays.copyOf(prev.tiles, prev.tiles.length);
// //             tiles[prev.spaceIndex] = tiles[slideFromIndex];
// //             tiles[slideFromIndex] = 0;
// //             spaceIndex = slideFromIndex;
// //             g = prev.g + 1;
// //             h = heuristic(tiles);
// //             this.prev = prev;
// //         }

// //         // Return true iif this is the goal state.
// //         boolean isGoal() {
// //             return Arrays.equals(tiles, goalTiles);
// //         }

// //         // Successor states due to south, north, west, and east moves.
// //         State moveS() { return spaceIndex > 2 ? new State(this, spaceIndex - 3) : null; }
// //         State moveN() { return spaceIndex < 6 ? new State(this, spaceIndex + 3) : null; }
// //         State moveE() { return spaceIndex % 3 > 0 ? new State(this, spaceIndex - 1) : null; }
// //         State moveW() { return spaceIndex % 3 < 2 ? new State(this, spaceIndex + 1) : null; }

// //         // Print this state.
// //         void print() {
// //             System.out.println("p = " + priority() + " = g+h = " + g + "+" + h);
// //             for (int i = 0; i < 9; i += 3)
// //                 System.out.println(tiles[i] + " " + tiles[i+1] + " " + tiles[i+2]);
// //         }

// //         // Print the solution chain with start state first.
// //         void printAll() {
// //             if (prev != null) prev.printAll();
// //             System.out.println();
// //             print();
// //         }

// //         @Override
// //         public boolean equals(Object obj) {
// //             if (obj instanceof State) {
// //                 State other = (State)obj;
// //                 return Arrays.equals(tiles, other.tiles);
// //             }
// //             return false;
// //         }

// //         @Override
// //         public int hashCode() {
// //             return Arrays.hashCode(tiles);
// //         }
// //     }

// // class EightPuzzle {

// //     // Tiles for successfully completed puzzle.
// //     static final goalTiles = [ 0, 1, 2, 3, 4, 5, 6, 7, 8 ];

// //     // A* priority queue.
// //     final PriorityQueue <State> queue = PriorityQueue<State>((State a, State b) {
// //             return a.priority() - b.priority();
// //         });

// //     // The closed state set.
// //     final HashSet <State> closed = new HashSet <State>();

// //     // State of the puzzle including its priority and chain to start state.

// //     // Add a valid (non-null and not closed) successor to the A* queue.
// //     void addSuccessor(State successor) {
// //         if (successor != null && !closed.contains(successor))
// //             queue.add(successor);
// //     }

// //     // Run the solver.
// //     void solve(byte [] initial) {

// //         queue.clear();
// //         closed.clear();

// //         // Click the stopwatch.
// //         long start = System.currentTimeMillis();

// //         // Add initial state to queue.
// //         queue.add(new State(initial));

// //         while (!queue.isEmpty()) {

// //             // Get the lowest priority state.
// //             State state = queue.poll();

// //             // If it's the goal, we're done.
// //             if (state.isGoal()) {
// //                 long elapsed = System.currentTimeMillis() - start;
// //                 state.printAll();
// //                 System.out.println("elapsed (ms) = " + elapsed);
// //                 return;
// //             }

// //             // Make sure we don't revisit this state.
// //             closed.add(state);

// //             // Add successors to the queue.
// //             addSuccessor(state.moveS());
// //             addSuccessor(state.moveN());
// //             addSuccessor(state.moveW());
// //             addSuccessor(state.moveE());
// //         }
// //     }

// //     // Return the index of val in given byte array or -1 if none found.
// //     static int index(byte [] a, int val) {
// //         for (int i = 0; i < a.length; i++)
// //             if (a[i] == val) return i;
// //         return -1;
// //     }

// //     // Return the Manhatten distance between tiles with indices a and b.
// //     static int manhattanDistance(int a, int b) {
// //         return Math.abs(a / 3 - b / 3) + Math.abs(a % 3 - b % 3);
// //     }

// //     // For our A* heuristic, we just use max of Manhatten distances of all tiles.
// //     static int heuristic(byte [] tiles) {
// //         int h = 0;
// //         for (int i = 0; i < tiles.length; i++)
// //             if (tiles[i] != 0)
// //                 h = Math.max(h, manhattanDistance(i, tiles[i]));
// //         return h;
// //     }

// //     public static void main(String[] args) {

// //         // This is a harder puzzle than the SO example
// //         byte [] initial = { 8, 0, 6, 5, 4, 7, 2, 3, 1 };

// //         // This is taken from the SO example.
// //         //byte [] initial = { 1, 4, 2, 3, 0, 5, 6, 7, 8 };

// //         new EightPuzzle().solve(initial);
// //     }
// // }

// import 'package:collection/collection.dart';
// import 'package:slide_puzzle/models/puzzle.dart';
// import 'package:slide_puzzle/models/tile.dart';
// import 'package:slide_puzzle/models/position.dart';
// import 'package:slide_puzzle/utils/functions2.dart';

// // class Solver {
// // }

// newNode(Puzzle puzzle, new_empty_tile_pos) {
//   List<Tile> tiles = puzzle.tiles;

//   final w = puzzle.getWhitespace();

//   final x1 = w.current.x;
//   final y1 = w.current.y;
//   final x2 = new_empty_tile_pos[0];
//   final y2 = new_empty_tile_pos[1];
//   final one =
//       tiles.singleWhere((element) => element.current == Position(x: x1, y: y1));
//   final two =
//       tiles.singleWhere((element) => element.current == Position(x: x2, y: y2));
//   final oneIndex = tiles.indexOf(one);
//   final twoIndex = tiles.indexOf(two);
//   tiles[oneIndex] =
//       one.copyWith(current: Position(x: two.current.x, y: two.current.y));
//   tiles[twoIndex] =
//       two.copyWith(current: Position(x: one.current.x, y: one.current.y));
//   // new_mat[x1][y1] = new_mat[x2][y2]
//   // new_mat[x2][y2] = new_mat[x1][y1]

//   return Puzzle(tiles: tiles);
//   // return new_node;
// }

// main() {
//   print("testtt");
//   final queue = PriorityQueue<Puzzle>((a, b) =>
//       a.getNumberOfCorrectTiles().compareTo(b.getNumberOfCorrectTiles()));
//   final row = [1, 0, -1, 0];
//   final col = [0, -1, 0, 1];

//   queue.add(generatePuzzle(4));

//   while (queue.isNotEmpty) {
//     print(queue);
//     // print(queue.length);
//     final min = queue.removeFirst();
//     if (min.getNumberOfCorrectTiles() == min.dimention * min.dimention - 1) {
//       print("correct");
//       print(min.tiles);
//       return;
//     }
//     // print(min.getNumberOfCorrectTiles());
//     for (final i in List.generate(min.dimention, (index) => index)) {
//       final newTilePos = [
//         min.getWhitespace().current.x + row[i],
//         min.getWhitespace().current.y + col[i],
//       ];
//       // print(min.g);
//       if (min.isIn(newTilePos[0], newTilePos[1])) {
//         final child = newNode(min, newTilePos);
//         queue.add(child);
//       }
//     }
//   }
// }

import 'package:equatable/equatable.dart';
import 'package:slide_puzzle/models/puzzle.dart';
import 'package:slide_puzzle/models/position.dart';
import 'package:slide_puzzle/models/tile.dart';
import 'package:slide_puzzle/utils/functions2.dart';

class Node extends Equatable {
  Node({
    required this.puzzle,
    this.parent,
    this.level = 0,
  });
  //  : super() {
  // }
  Node? parent;
  Puzzle puzzle;
  int level;
  // late List<Puzzle> adjacentMat;

  int get fScore => puzzle.manhattanDistance() + level;

  @override
  List<Object?> get props => [parent, puzzle];

  copyWith(puzzle, parent, level) {
    return Node(
        puzzle: puzzle ?? this.puzzle,
        parent: parent ?? this.parent,
        level: level ?? this.level);
  }

  Node? solve() {
    List<Node> open = [this];
    List<Node> closed = [];
    int xx = 4;
    while (open.isNotEmpty) {
      // while (xx != 0) {
      // xx--;
      Node x = open.removeAt(0);
      if (x.puzzle.isComplete) {
        print('complete');
        x.puzzle.printPuzzle();
        return x;
      }
      List<Puzzle> wMoves = x.puzzle.getWhiteMoves();
      print(wMoves.length);
      wMoves.removeWhere(
          (element) => closed.map((e) => e.puzzle).contains(element));

      print(wMoves.length);
      print(x.fScore);
      x.puzzle.printPuzzle();
      open.addAll(
          wMoves.map((e) => Node(puzzle: e, level: x.level + 1, parent: x)));

      closed.add(x);
      open.sort((x, y) => x.fScore.compareTo(y.fScore));
      print(open.map((e) => e.fScore));
    }
  }

  List<Node> generateList() {
    List<Node> list = [this];
    Node? parent = this.parent;
    while (parent != null) {
      list.add(parent);
      parent = parent.parent;
    }
    return list;
  }
}

void main(List<String> args) {
  final y = Node(
      puzzle: Puzzle(
          tiles: [3,5,7,1,2,9,4,6,8]
              .map((e) => Tile(correct: e, isW: e == 9))
              .toList(),
          image: ''
          // [
          // Tile(correct: 0),
          // Tile(correct: 1),
          // Tile(correct: 2),
          // Tile(correct: 3),
          // Tile(correct: 4),
          // Tile(correct: 6),
          // Tile(correct: 9),
          // Tile(correct: 7),
          // Tile(correct: 8),
          // Tile(correct: 5),
          // Tile(correct: 11),
          // Tile(correct: 14),
          // Tile(correct: 12),
          // Tile(correct: 15, isW: true),
          // Tile(correct: 13),
          // Tile(correct: 10),
          // ]
          ));
  y.puzzle.printPuzzle();
  // print(y.puzzle.manhattanDistance());
  final b = y.solve();
  // b?.puzzle.printPuzzle();
  // for (var item in b!.generateList()) {
  //   item.puzzle.printPuzzle();
  //   print('---------');
  // }
}

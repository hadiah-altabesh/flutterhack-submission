import 'package:equatable/equatable.dart';

class Position extends Equatable implements Comparable<Position> {
  final int x;
  final int y;

  const Position({required this.x, required this.y});

  @override
  List<Object?> get props => [x, y];
  Position add(x, y) {
    return Position(x: x + this.x, y: y + this.y);
  }

  factory Position.fromIndex(int i, {int d = 4}) {
    return Position(x: i ~/ d, y: i % d);
    // switch (i) {
    //   case 0:
    //     return const Position(x: 1, y: 1);
    //   case 1:
    //     return const Position(x: 1, y: 2);
    //   case 2:
    //     return const Position(x: 1, y: 3);
    //   case 3:
    //     return const Position(x: 1, y: 4);

    //   case 4:
    //     return const Position(x: 2, y: 1);
    //   case 5:
    //     return const Position(x: 2, y: 2);
    //   case 6:
    //     return const Position(x: 2, y: 3);
    //   case 7:
    //     return const Position(x: 2, y: 4);

    //   case 8:
    //     return const Position(x: 3, y: 1);
    //   case 9:
    //     return const Position(x: 3, y: 2);
    //   case 10:
    //     return const Position(x: 3, y: 3);
    //   case 11:
    //     return const Position(x: 3, y: 4);

    //   case 12:
    //     return const Position(x: 4, y: 1);
    //   case 13:
    //     return const Position(x: 4, y: 2);
    //   case 14:
    //     return const Position(x: 4, y: 3);
    //   case 15:
    //     return const Position(x: 4, y: 4);

    //   default:
    //     return const Position(x: -1, y: -1);
    // }
  }
  int indexFromPosition({int d = 4}) {
    return x * d + y;
    // switch (x) {
    //   case 1:
    //     switch (y) {
    //       case 1:
    //         return 0;
    //       case 2:
    //         return 1;
    //       case 3:
    //         return 2;
    //       case 4:
    //         return 3;
    //       default:
    //         return -1;
    //     }
    //   case 2:
    //     switch (y) {
    //       case 1:
    //         return 4;
    //       case 2:
    //         return 5;
    //       case 3:
    //         return 6;
    //       case 4:
    //         return 7;
    //       default:
    //         return -1;
    //     }
    //   case 3:
    //     switch (y) {
    //       case 1:
    //         return 8;
    //       case 2:
    //         return 9;
    //       case 3:
    //         return 10;
    //       case 4:
    //         return 11;
    //       default:
    //         return -1;
    //     }
    //   case 4:
    //     switch (y) {
    //       case 1:
    //         return 12;
    //       case 2:
    //         return 13;
    //       case 3:
    //         return 14;
    //       case 4:
    //         return 15;
    //       default:
    //         return -1;
    //     }
    //   default:
    //     return -1;
    // }
  }

  @override
  int compareTo(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}

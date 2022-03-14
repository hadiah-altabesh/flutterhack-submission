class TileSizes {
  static const small = 70.0;
  static const medium = 75.0;
  static const large = 80.0;

  static getSizeFromDimension(i) {
    return i == 3
        ? large
        : i == 4
            ? medium
            : small;
  }

  static const smallBoard = 240.0;
  static const mediumBoard = 300.0;
  static const largeBoard = 350.0;
  static getBoardSizeFromDimension(i) {
    return i == 3
        ? smallBoard
        : i == 4
            ? mediumBoard
            : largeBoard;
  }
}

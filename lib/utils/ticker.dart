class Ticker {
  const Ticker();
  Stream<int> ntick({required int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }

  Stream<int> tick() {
    return Stream.periodic(Duration(seconds: 1), (x) => x++);
  }
}

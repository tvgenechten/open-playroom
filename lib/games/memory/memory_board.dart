import 'dart:math';

/// The rules of Memory, apart from any widget.
///
/// Each card holds a symbol number; every number appears twice. Two different cards stay
/// face up until the next tap, so there is no time pressure to remember them.
class MemoryBoard {
  MemoryBoard(this.cards);

  factory MemoryBoard.shuffled(int pairs, [Random? random]) => MemoryBoard(
    [
      for (var i = 0; i < pairs; i++) ...[i, i],
    ]..shuffle(random),
  );

  final List<int> cards;
  final Set<int> matched = {};
  final List<int> open = [];

  bool get won => matched.length == cards.length;

  bool isFaceUp(int index) => matched.contains(index) || open.contains(index);

  void flip(int index) {
    if (open.length == 2) open.clear();
    if (isFaceUp(index)) return;
    open.add(index);
    if (open.length == 2 && cards[open[0]] == cards[open[1]]) {
      matched.addAll(open);
      open.clear();
    }
  }
}

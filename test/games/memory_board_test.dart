import 'package:flutter_test/flutter_test.dart';
import 'package:open_playroom/games/memory/memory_board.dart';

void main() {
  test('shuffled board holds every symbol exactly twice', () {
    final board = MemoryBoard.shuffled(6);
    expect(board.cards..sort(), [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5]);
  });

  test('a matching pair stays face up', () {
    final board = MemoryBoard([0, 1, 0, 1])
      ..flip(0)
      ..flip(2);
    expect(board.matched, {0, 2});
    expect(board.open, isEmpty);
  });

  test('a wrong pair stays visible until the next tap, then turns over', () {
    final board = MemoryBoard([0, 1, 0, 1])
      ..flip(0)
      ..flip(1);
    expect(board.isFaceUp(0) && board.isFaceUp(1), isTrue);

    board.flip(2);
    expect(board.isFaceUp(0), isFalse);
    expect(board.isFaceUp(1), isFalse);
    expect(board.open, [2]);
  });

  test('tapping a face-up card does nothing', () {
    final board = MemoryBoard([0, 1, 0, 1])
      ..flip(0)
      ..flip(0);
    expect(board.open, [0]);
  });

  test('the game is won when every pair is found', () {
    final board = MemoryBoard([0, 1, 0, 1]);
    for (final i in [0, 2, 1, 3]) {
      board.flip(i);
    }
    expect(board.won, isTrue);
  });
}

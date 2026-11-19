import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_playroom/games/memory/memory_game.dart';

void main() {
  testWidgets('tapping a card turns it face up', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MemoryGame())),
    );
    expect(find.byType(Icon), findsNothing);

    await tester.tap(find.byKey(const ValueKey('memory-card-0')));
    await tester.pump();
    expect(find.byType(Icon), findsOneWidget);
  });
}

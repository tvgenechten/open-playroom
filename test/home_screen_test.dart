import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_playroom/games/games.dart';
import 'package:open_playroom/main.dart';

void main() {
  for (final game in games) {
    testWidgets(
      '${game.title} opens from the home screen and "Terug" returns',
      (tester) async {
        await tester.pumpWidget(const OpenPlayroomApp());

        await tester.tap(find.text(game.title));
        await tester.pumpAndSettle();
        expect(find.text('Terug'), findsOneWidget);

        await tester.tap(find.text('Terug'));
        await tester.pumpAndSettle();
        expect(find.text('Kies een spelletje'), findsOneWidget);
      },
    );
  }

  testWidgets('home screen survives the largest system font', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const OpenPlayroomApp());
    expect(tester.takeException(), isNull);
    expect(find.byType(GridView), findsOneWidget);
  });
}

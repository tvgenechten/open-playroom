import 'package:flutter/material.dart';

import 'games/game.dart';
import 'games/games.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kies een spelletje')),
      body: LayoutBuilder(
        builder: (context, constraints) => GridView.count(
          // Two tiles on a phone, more on a tablet.
          crossAxisCount: (constraints.maxWidth ~/ 260).clamp(2, 5),
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [for (final game in games) _GameTile(game)],
        ),
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile(this.game);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: () =>
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => _GameScreen(game))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(game.icon, size: 72),
          const SizedBox(height: 12),
          Text(
            game.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _GameScreen extends StatelessWidget {
  const _GameScreen(this.game);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // A labelled button instead of a bare arrow, so leaving a game is never a puzzle.
        automaticallyImplyLeading: false,
        leadingWidth: 160,
        leading: TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, size: 32),
          label: const Text('Terug'),
        ),
        title: Text(game.title),
      ),
      body: SafeArea(child: game.builder(context)),
    );
  }
}

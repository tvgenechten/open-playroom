import 'package:flutter/material.dart';

import 'memory_board.dart';

/// Dutch name (read by screen readers), icon and colour of each symbol.
const _symbols = [
  ('hond', Icons.pets, Colors.brown),
  ('bloem', Icons.local_florist, Colors.pink),
  ('zon', Icons.wb_sunny, Colors.orange),
  ('hart', Icons.favorite, Colors.red),
  ('boom', Icons.park, Colors.green),
  ('vis', Icons.set_meal, Colors.blue),
];

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  var _board = MemoryBoard.shuffled(_symbols.length);

  @override
  Widget build(BuildContext context) {
    if (_board.won) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Goed gedaan!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => setState(
                () => _board = MemoryBoard.shuffled(_symbols.length),
              ),
              icon: const Icon(Icons.replay, size: 32),
              label: const Text('Nog eens'),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Fit every card on screen without scrolling, in either orientation.
        final columns = constraints.maxWidth > constraints.maxHeight ? 4 : 3;
        final rows = (_board.cards.length / columns).ceil();
        const gap = 12.0;
        final cardWidth =
            (constraints.maxWidth - gap * (columns + 1)) / columns;
        final cardHeight = (constraints.maxHeight - gap * (rows + 1)) / rows;
        return GridView.count(
          crossAxisCount: columns,
          childAspectRatio: cardWidth / cardHeight,
          padding: const EdgeInsets.all(gap),
          mainAxisSpacing: gap,
          crossAxisSpacing: gap,
          physics: const NeverScrollableScrollPhysics(),
          children: [for (var i = 0; i < _board.cards.length; i++) _card(i)],
        );
      },
    );
  }

  Widget _card(int index) {
    final colors = Theme.of(context).colorScheme;
    final (name, icon, color) = _symbols[_board.cards[index]];
    final faceUp = _board.isFaceUp(index);
    return Semantics(
      button: true,
      label: faceUp ? name : 'Kaart ${index + 1}, omgedraaid',
      excludeSemantics: true,
      child: Material(
        color: faceUp ? colors.surfaceContainerHighest : colors.primary,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          key: ValueKey('memory-card-$index'),
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _board.flip(index)),
          child: Center(
            child: faceUp
                ? FittedBox(child: Icon(icon, color: color, size: 96))
                : null,
          ),
        ),
      ),
    );
  }
}

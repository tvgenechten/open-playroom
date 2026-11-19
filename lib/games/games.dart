import 'package:flutter/material.dart';

import 'game.dart';
import 'memory/memory_game.dart';

/// Every game in the app, in the order the home screen shows them.
final games = <Game>[
  Game(
    title: 'Memory',
    icon: Icons.grid_view_rounded,
    builder: (_) => const MemoryGame(),
  ),
];

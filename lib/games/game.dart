import 'package:flutter/widgets.dart';

/// One entry on the home screen. [builder] returns only the playing field;
/// the home screen adds the title bar and the "Terug" button around it.
class Game {
  const Game({required this.title, required this.icon, required this.builder});

  /// Dutch, shown on the tile and in the title bar.
  final String title;
  final IconData icon;
  final WidgetBuilder builder;
}

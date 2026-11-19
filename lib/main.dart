import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home_screen.dart';
import 'theme.dart';

void main() => runApp(const OpenPlayroomApp());

class OpenPlayroomApp extends StatelessWidget {
  const OpenPlayroomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Playroom',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      // shortcut: Dutch only, no ARB/intl; upgrade when a second language is wanted.
      locale: const Locale('nl'),
      supportedLocales: const [Locale('nl')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';

import 'screens/game_home.dart';
import 'themes/dark_game_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Games',
      theme: gameTheme,
      home: const GameHomePage(),
    );
  }
}

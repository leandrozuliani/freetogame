import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/game_list_provider.dart';
import 'screens/game_home.dart';
import 'themes/dark_game_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => GameListProvider()),
      ],
      child: const MyApp(),
    ),
  );
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

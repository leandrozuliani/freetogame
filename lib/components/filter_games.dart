import 'package:flutter/material.dart';

import '../models/game.dart';

class FilterGame extends StatefulWidget {
  final List<Game> games;
  final ValueChanged<List<Game>> onChanged;

  const FilterGame({super.key, required this.games, required this.onChanged});

  @override
  FilterGameState createState() => FilterGameState();
}

class FilterGameState extends State<FilterGame> {
  String _query = '';

  void _onChangedSetState(String query) {
    setState(() {
      _query = query;
      widget.onChanged(_filterGames());
    });
  }

  List<Game> _filterGames() {
    return widget.games.where((game) {
      return game.title.toLowerCase().contains(_query.toLowerCase()) ||
          game.shortDescription.toLowerCase().contains(_query.toLowerCase()) ||
          game.publisher.toLowerCase().contains(_query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: const OutlineInputBorder(),
          hintText: 'Filtro',
        ),
        onChanged: _onChangedSetState,
      ),
    );
  }
}

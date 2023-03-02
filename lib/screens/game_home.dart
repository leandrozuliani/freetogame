import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/game_service.dart';
import 'game_list.dart';

class GameHomePage extends StatefulWidget {
  const GameHomePage({Key? key}) : super(key: key);

  @override
  GameHomePageState createState() => GameHomePageState();
}

class GameHomePageState extends State<GameHomePage> {
  late List<Game> _games;
  late List<Game> _filteredGames;
  late List<Game> _sortedGames;
  late bool _isSortBySelected = false;
  late String _selectedSortByValue;

  final List<String> _sortByOptions = ['Título', 'Lançamento'];

  @override
  void initState() {
    super.initState();
    _fetchGames();
    _selectedSortByValue = _sortByOptions[0];
  }

  /// Ordena a lista de jogos por data de lançamento, com os mais recentes primeiro.
  void _sortGamesByReleaseDate() {
    _sortedGames.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    setState(() {
      _filteredGames = List.from(_sortedGames);
      _isSortBySelected = true;
    });
  }

  /// Ordena a lista de jogos por título, em ordem alfabética crescente.
  void _sortGamesByTitle() {
    _sortedGames.sort((a, b) => a.title.compareTo(b.title));
    setState(() {
      _filteredGames = List.from(_sortedGames);
      _isSortBySelected = true;
    });
  }

  // realiza um filtro nos campos e também trata a ordenação
  void _onSearchTextChanged(String value) {
    setState(() {
      _filteredGames = _games
          .where((game) =>
              game.title.toLowerCase().contains(value.toLowerCase()) ||
              game.shortDescription
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              game.publisher.toLowerCase().contains(value.toLowerCase()))
          .toList();
      _sortedGames = List.from(_filteredGames);
    });
  }

  Future<void> _fetchGames() async {
    _games = [];
    _filteredGames = [];

    final games = await GameService.fetchGames();
    setState(() {
      _games = games;
      _filteredGames = games;
      _sortedGames = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de jogos'),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Ordernar por: ',
                  style: Theme.of(context).textTheme.bodySmall),
              DropdownButton<String>(
                value: _isSortBySelected ? _selectedSortByValue : null,
                hint: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Center(
                    child: Text(
                      _isSortBySelected ? _selectedSortByValue : 'Padrão',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                items: _sortByOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSortByValue = newValue;
                      if (_selectedSortByValue == _sortByOptions[1]) {
                        _sortGamesByReleaseDate();
                      } else if (_selectedSortByValue == _sortByOptions[0]) {
                        _sortGamesByTitle();
                      } else {
                        _sortedGames = List.from(_filteredGames);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Filtre por título, descrição ou fabricante',
              ),
              onChanged: (value) {
                setState(() {
                  _onSearchTextChanged(value);
                });
              },
            ),
            const SizedBox(height: 20),
            Flexible(
              child: GameList(games: _filteredGames),
            ),
          ],
        ),
      ),
    );
  }
}

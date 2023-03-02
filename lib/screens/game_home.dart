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
  String _searchedText = '';

  final List<String> _sortByOptions = ['Título', 'Lançamento'];
  final Map<String, bool> _genres = {};
  Map<String, bool> _selectedGenres = {};

  @override
  void initState() {
    super.initState();
    _fetchGames();
    _selectedSortByValue = _sortByOptions[0];
    _selectedGenres = Map.from(_genres);
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

  // realiza um filtro nos campos, filtra por genero e também trata a ordenação
  void _onSearchTextChanged(String value) {
    // final value = _searchController.text.toLowerCase();

    setState(() {
      _filteredGames = _games
          .where((game) =>
              game.title.toLowerCase().contains(value.toLowerCase()) ||
              game.shortDescription
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              game.publisher.toLowerCase().contains(value.toLowerCase()))
          .toList();

      _filteredGames = _filteredGames
          .where((game) => _selectedGenres[game.genre] == true)
          .toList();

      _sortedGames = List.from(_filteredGames);
    });
  }

  Future<void> _fetchGames() async {
    _games = [];
    _filteredGames = [];

    final games = await GameService.fetchGames();

    Set<String> gendersService = games.map((game) => game.genre.trim()).toSet();
    List<String> sortedGenders = gendersService.toList()..sort();
    gendersService = Set<String>.from(sortedGenders);

    for (var gender in gendersService) {
      _genres[gender.toString()] = true;
    }

    setState(() {
      _games = games;
      _filteredGames = games;
      _sortedGames = games;
      _selectedGenres = Map.from(_genres);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos'),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton<String>(
                // value: _selectedGenres[_selectedGenres.keys.first],
                hint: Text(
                  'Gêneros: ${_selectedGenres.values.where((selected) => !selected).length} excluído(s)',
                  style: const TextStyle(fontSize: 11),
                ),
                icon: const Icon(
                  Icons.arrow_downward,
                  size: 20,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGenres[newValue!] = !_selectedGenres[newValue]!;
                    _onSearchTextChanged(_searchedText);
                  });
                },
                items: _genres.entries.map((entry) {
                  final genreName = entry.key;
                  return DropdownMenuItem<String>(
                    value: genreName,
                    key: UniqueKey(),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _genres[genreName],
                          onChanged: (bool? value) {
                            setState(() {
                              _genres[genreName] = value!;
                              _selectedGenres[genreName] = value;
                              _onSearchTextChanged(_searchedText);
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                          child: Text(
                            genreName,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Text('Ordernar por: ',
                  style: Theme.of(context).textTheme.bodySmall),
              DropdownButton<String>(
                value: _isSortBySelected ? _selectedSortByValue : null,
                hint: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        _isSortBySelected ? _selectedSortByValue : 'Padrão',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
                items: _sortByOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
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
                hintText: 'Filtre por título, descrição ou publicador',
              ),
              onChanged: (value) {
                setState(() {
                  _searchedText = value;
                  _onSearchTextChanged(_searchedText);
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game.dart';
import '../providers/game_list_provider.dart';
import '../services/game_service.dart';
import 'game_list.dart';

class GameHomePage extends StatefulWidget {
  const GameHomePage({Key? key}) : super(key: key);

  @override
  GameHomePageState createState() => GameHomePageState();
}

class GameHomePageState extends State<GameHomePage> {
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
  }

  /// Ordena a lista de jogos por data de lançamento, com os mais recentes primeiro.
  void _sortGamesByReleaseDate() {
    final provider = getProvider(context);
    final sortedGames = List<Game>.from(provider.filteredAndSortedGames)
      ..sort((a, b) => b.releaseDate.compareTo(a.releaseDate));

    provider.setFilteredAndSortedGames(sortedGames);
    setState(() {
      _isSortBySelected = true;
    });
  }

  /// Ordena a lista de jogos por título, em ordem alfabética crescente.
  void _sortGamesByTitle() {
    final provider = getProvider(context);

    final sortedGames = List<Game>.from(provider.filteredAndSortedGames)
      ..sort((a, b) => a.title.compareTo(b.title));

    provider.setFilteredAndSortedGames(sortedGames);
    setState(() {
      _isSortBySelected = true;
    });
  }

  // realiza um filtro nos campos, filtra por genero e também trata a ordenação
  void _onSearchTextChanged(String value) {
    final provider = getProvider(context);

    final filteredGames = provider.games
        .where((game) =>
            game.title.toLowerCase().contains(value.toLowerCase()) ||
            game.shortDescription.toLowerCase().contains(value.toLowerCase()) ||
            game.publisher.toLowerCase().contains(value.toLowerCase()))
        .toList();

    final filteredAndSelectedGenresGames = filteredGames
        .where((game) => _selectedGenres[game.genre] == true)
        .toList();

    final sortedGames = List<Game>.from(filteredAndSelectedGenresGames);

    if (_selectedSortByValue == _sortByOptions[1]) {
      sortedGames.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    } else if (_selectedSortByValue == _sortByOptions[0]) {
      sortedGames.sort((a, b) => a.title.compareTo(b.title));
    }

    setState(() {
      provider.setFilteredAndSortedGames(sortedGames);
    });
  }

  Future<void> _fetchGames() async {
    _filteredGames = [];

    final provider = getProvider(context);

    final games = await GameService.fetchGames();

    provider.setGames(games);

    Set<String> gendersService = games.map((game) => game.genre.trim()).toSet();
    List<String> sortedGenders = gendersService.toList()..sort();
    gendersService = Set<String>.from(sortedGenders);

    for (var gender in gendersService) {
      _genres[gender.toString()] = true;
    }
    // print(_genres);
    _selectedSortByValue = _sortByOptions[0];
    _selectedGenres = Map.from(_genres);

    setState(() {
      _selectedGenres = Map.from(_genres);
    });
  }

  GameListProvider getProvider(BuildContext context) {
    return Provider.of<GameListProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Filtre por título, descrição ou publicador',
                contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                prefixIcon: Icon(Icons.search),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchedText = value;
                  _onSearchTextChanged(_searchedText);
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 160,
                  child: DropdownButton<String>(
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        _selectedGenres.values
                                .where((selected) => !selected)
                                .isNotEmpty
                            ? 'Gênero: ${_selectedGenres.values.where((selected) => !selected).length} excluído(s)'
                            : 'Gênero: (todos)',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.arrow_downward,
                        size: 18,
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        // _selectedGenres[newValue!] =
                        //     !_selectedGenres[newValue]!;
                        // _onSearchTextChanged(_searchedText);
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
                              key: UniqueKey(),
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
                ),
                Row(
                  children: [
                    Text('Ordernação:',
                        style: Theme.of(context).textTheme.bodySmall),
                    DropdownButton<String>(
                      value: _isSortBySelected ? _selectedSortByValue : null,
                      hint: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _isSortBySelected
                                  ? _selectedSortByValue
                                  : 'Padrão',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(
                          Icons.arrow_downward,
                          size: 18,
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
                            } else if (_selectedSortByValue ==
                                _sortByOptions[0]) {
                              _sortGamesByTitle();
                            } else {
                              final provider = getProvider(context);
                              provider.setFilteredAndSortedGames(
                                  provider.filteredAndSortedGames);
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Consumer<GameListProvider>(
                builder: (context, gameListProvider, _) {
                  return GameList(
                      games: gameListProvider.filteredAndSortedGames);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

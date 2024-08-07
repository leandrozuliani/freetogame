import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/genres_dropdown.dart';
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
  late bool _isSortBySelected = false;
  bool _isLoading = false;
  bool _hasError = false;
  late String _selectedSortByValue;
  String _searchedText = '';

  final List<String> _sortByOptions = ['Título', 'Lançamento'];
  final Map<String, bool> _genresMap = {};
  Map<String, bool> _selectedGenres = {};

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _fetchGames()
        .then((value) => setState(() {
              _hasError = false;
            }))
        .catchError((error) => setState(() {
              _hasError = true;
            }));
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

    if (_selectedSortByValue == 'Lançamento') {
      sortedGames.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    } else if (_selectedSortByValue == 'Título') {
      sortedGames.sort((a, b) => a.title.compareTo(b.title));
    }

    setState(() {
      provider.setFilteredAndSortedGames(sortedGames);
    });
  }

  Future<void> _fetchGames() async {
    final provider = getProvider(context);

    final games = await GameService.fetchGames();

    _isLoading = false;

    provider.setGames(games);

    Set<String> genresSet = games.map((game) => game.genre.trim()).toSet();
    List<String> sortedGenders = genresSet.toList()..sort();
    genresSet = Set<String>.from(sortedGenders);

    for (var genreSet in genresSet) {
      _genresMap[genreSet.toString()] = true;
    }

    _selectedSortByValue = '';
    _selectedGenres = Map.from(_genresMap);

    setState(() {
      _selectedGenres = Map.from(_genresMap);
    });
  }

  GameListProvider getProvider(BuildContext context) {
    return Provider.of<GameListProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return scaffoldLoading(context);
    }

    if (_hasError) {
      return scaffoldError();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jogos Free-To-Play',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaQuery.of(context).size.width > 580
                ? const Center()
                : widgetSearchField(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MediaQuery.of(context).size.width > 580
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (MediaQuery.of(context).size.width > 580)
                  SingleChildScrollView(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: widgetSearchField()),
                  ),
                GenresDropdown(
                  genresMap: _genresMap,
                  selectedGenres: _selectedGenres,
                  onGenreSelectionChanged: (genreName, value) {
                    setState(() {
                      _genresMap[genreName] = value;
                      _selectedGenres[genreName] = value;
                      _onSearchTextChanged(_searchedText);
                    });
                  },
                ),
                widgetSortingBy(context),
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

  TextField widgetSearchField() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Filtre por título, descrição ou publicador',
        hintStyle: TextStyle(
          fontSize: 12,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        prefixIcon: Icon(
          Icons.search,
          size: 16,
        ),
        isCollapsed: true,
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
    );
  }

  Widget widgetSortingBy(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 580 ? 125 : 180,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _isSortBySelected ? _selectedSortByValue : null,
          hint: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              _isSortBySelected ? _selectedSortByValue : 'Ordenação',
              style: Theme.of(context).textTheme.bodySmall,
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
                } else if (_selectedSortByValue == _sortByOptions[0]) {
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
      ),
    );
  }

  Scaffold scaffoldLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Aguarde um momento, por favor...',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await _fetchGames();
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Scaffold scaffoldError() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Ocorreu um erro ao acessar os jogos',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              [
                '1. Verifique sua conexão com a internet',
                '2. Verifique se o servidor node express está funcionando corretamente',
                '3. Leia o README do projeto para mais informações.'
              ].join('\n'),
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchGames,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/game_service.dart';

class GameList extends StatefulWidget {
  final List<Game> games;

  const GameList({Key? key, required this.games}) : super(key: key);

  @override
  GameListState createState() => GameListState();
}

class GameListState extends State<GameList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: ListView.builder(
        itemCount: widget.games.length,
        itemBuilder: (context, index) {
          final game = widget.games[index];
          return SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThumbnail(context, game),
                const SizedBox(height: 8),
                _buildGameInfo(context, game),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildThumbnail(BuildContext context, Game game) {
  return SizedBox(
    width: double.infinity,
    height: 220,
    child: Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://cors-anywhere.herokuapp.com/${game.thumbnail}', //cors trick
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/nophoto.png',
                fit: BoxFit.cover,
              );
            },
            headers: GameService.imageHeaders(),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              game.publisher,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900]),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildGameInfo(BuildContext context, Game game) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          game.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          game.shortDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              label: Text(
                game.genre,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.black54,
            ),
            Chip(
              label: Text(
                game.platform,
                style: TextStyle(fontSize: 12, color: Colors.grey[900]),
              ),
              backgroundColor: Colors.grey[200],
            ),
          ],
        ),
      ],
    ),
  );
}

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
                hintText: 'Filtro',
              ),
              onChanged: (value) {
                setState(() {
                  _onSearchTextChanged(value);
                });
              },
            ),
            Flexible(
              child: GameList(games: _filteredGames),
            ),
          ],
        ),
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
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
            game.thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/nophoto.png',
                fit: BoxFit.cover,
              );
            },
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

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    _games = [];
    _filteredGames = [];

    final games = await GameService.fetchGames();
    setState(() {
      _games = games;
      _filteredGames = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de jogos'),
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
                  _filteredGames = _games
                      .where((game) =>
                          game.title.contains(value) ||
                          game.shortDescription.contains(value) ||
                          game.publisher.contains(value))
                      .toList();
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

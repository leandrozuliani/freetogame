import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/game_service.dart';

class GameList extends StatefulWidget {
  const GameList({super.key});

  @override
  GameListState createState() => GameListState();
}

class GameListState extends State<GameList> {
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    final games = await GameService.fetchGames();
    setState(() {
      _games = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      future: GameService.fetchGames(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final games = snapshot.data!;
          return Container(
            constraints: BoxConstraints(maxWidth: 160),
            child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
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
        } else if (snapshot.hasError) {
          return Center(
            child: const Text('Ocorreu um erro ao listar os jogos.'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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
              game.genre,
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
                game.releaseDate.year.toString(),
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

class GameHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game List'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GameList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

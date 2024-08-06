import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/game.dart';
import '../models/game_details.dart';
import '../services/game_service.dart';
import 'game_details_screen.dart';

class GameList extends StatefulWidget {
  final List<Game> games;

  const GameList({Key? key, required this.games}) : super(key: key);

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  late List<Game> _pagedGames;

  final int _itemsByPage = 20;
  int _currentPage = 1;

  void nextPage() {
    final int nextPage = _currentPage + 1;
    final int gamesCount = widget.games.length;

    if ((nextPage - 1) * _itemsByPage < gamesCount) {
      _currentPage = nextPage;
      _pagedGames = widget.games.sublist(0, _currentPage * _itemsByPage);
    } else {
      resetPage();
    }
    setState(() {});
  }

  void resetPage() {
    _currentPage = 1;
    _pagedGames = widget.games.take(_itemsByPage).toList();
  }

  @override
  void didUpdateWidget(GameList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // quando o filtro é ativo, estou voltando para a página 1 para não criar complexidade aqui
    resetPage();
  }

  @override
  void initState() {
    super.initState();
    _pagedGames = widget.games.take(_itemsByPage).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final gridItemWidth = screenWidth > 640 ? 250.0 : 230.0;
    final crossAxisCount = (screenWidth / gridItemWidth).floor();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          nextPage();
        }
        return true;
      },
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        physics: const AlwaysScrollableScrollPhysics(),
        childAspectRatio: crossAxisCount == 1
            ? 1.45
            : crossAxisCount == 2
                ? 0.75
                : 0.7,
        mainAxisSpacing: crossAxisCount == 1 ? 0 : 16,
        crossAxisSpacing: crossAxisCount == 1 ? 0 : 16,
        shrinkWrap: true,
        children: _pagedGames.map((game) {
          return Padding(
            padding: EdgeInsets.only(bottom: crossAxisCount == 1 ? 16.0 : 0),
            child: InkWell(
              onTap: () {
                // _showGameDetails(context, game);
                showDialog(
                  context: context,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
                GameService.fetchSpecificGame(game.id).then((detailedGame) {
                  Navigator.pop(context);
                  _showGameDetails(context, detailedGame);
                }).catchError((onError) {
                  // ignore: todo
                  // TODO: tratamento de erro após chamar fetchSpecificGame
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.shade600,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildThumbnail(context, game),
                    ),
                    Expanded(
                      flex: screenWidth <= 480 ? 3 : 2,
                      child: _buildGameInfo(context, game),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showGameDetails(BuildContext context, GameDetails detailedGame) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameDetailsScreen(game: detailedGame),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, Game game) {
    return FutureBuilder<Uint8List>(
      future: fetchImageBytes(game.thumbnail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Image.asset(
            'assets/images/nophoto.png',
            fit: BoxFit.cover,
          );
        } else {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }

  Future<Uint8List> fetchImageBytes(String imageUrl) async {
    final response = await http.get(
      Uri.parse(imageUrl),
      headers: const {
        'x-rapidapi-host': 'free-to-play-games-database.p.rapidapi.com',
        'x-rapidapi-key':
            String.fromEnvironment('X_RAPIDAPI_KEY', defaultValue: ''),
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed loading image ${response.statusCode}');
    }
  }
}

Widget _buildGameInfo(BuildContext context, Game game) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          game.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          game.shortDescription,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              label: Text(
                game.genre,
                style: const TextStyle(fontSize: 11),
              ),
              backgroundColor: Colors.black54,
            ),
            Chip(
              label: Text(
                game.platform,
                style: TextStyle(fontSize: 11, color: Colors.grey[900]),
              ),
              backgroundColor: Colors.grey[200],
            ),
          ],
        ),
      ],
    ),
  );
}

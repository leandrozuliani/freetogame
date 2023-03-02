import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/game_details.dart';
import '../services/game_service.dart';
import 'game_details_screen.dart';

class GameList extends StatefulWidget {
  final List<Game> games;

  const GameList({Key? key, required this.games}) : super(key: key);

  @override
  GameListState createState() => GameListState();
}

class GameListState extends State<GameList> {
  @override
  Widget build(BuildContext context) {
    const double itemWidth = 250.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / itemWidth).floor();

    return GridView.count(
      crossAxisCount: crossAxisCount,
      physics: const AlwaysScrollableScrollPhysics(),
      childAspectRatio: 0.75,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      children: widget.games.map((game) {
        return InkWell(
          onTap: () {
            // _showGameDetails(context, game);
            showDialog(
              context: context,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            GameService.fetchSpecificGame(game.id).then((detailedGame) {
              Navigator.pop(context);
              _showGameDetails(context, detailedGame);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
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
                  flex: screenWidth <= 500 ? 3 : 2,
                  child: _buildGameInfo(context, game),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
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
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
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
  );
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

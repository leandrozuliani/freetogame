import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/game_details.dart';
import '../services/game_service.dart';
import 'game_details_screen.dart';

class GameList extends StatelessWidget {
  final List<Game> games;

  const GameList({Key? key, required this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final gridItemWidth = screenWidth > 640 ? 250.0 : 230.0;
    final crossAxisCount = (screenWidth / gridItemWidth).floor();

    return GridView.count(
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
      children: games.map((game) {
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
        //'https://cors-anywhere.herokuapp.com/${game.thumbnail}', //cors trick
        'https://proxy.cors.sh/${game.thumbnail}', //cors trick
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

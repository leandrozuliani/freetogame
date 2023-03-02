import 'package:flutter/material.dart';
import 'package:freetogame/models/game_details.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildGameInfo(BuildContext context, GameDetails game) {
  return SizedBox(
    height: 200,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Publicador:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              Text(
                game.publisher,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white60),
              ),
              const SizedBox(height: 20),
              Text(
                'Gênero:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              Text(
                game.genre,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white60),
              ),
              const SizedBox(height: 20),
              Text(
                'Desenvolvedor:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              Text(
                game.developer,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white60),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Data de lançamento:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              Text(
                '${game.releaseDate.day} ${_getMonthName(game.releaseDate.month)} ${game.releaseDate.year}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white60),
              ),
              const SizedBox(height: 20),
              Text(
                'Plataforma:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              Text(
                game.platform,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white60),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.https(game.freetogameProfileUrl));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[300],
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Mais informações em FreeToGame'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

String _getMonthName(int month) => [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ][(month - 1) % 12];

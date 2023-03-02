import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/game.dart';

class GameDetails extends StatelessWidget {
  final Game game;

  const GameDetails({Key? key, required this.game}) : super(key: key);

  Widget _buttonPlayNow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.play_arrow),
          label: const Text('JOGAR AGORA'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 8.0),
        const Icon(Icons.arrow_forward, size: 20),
      ],
    );
  }

  Widget _buildGameInfo(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Jogo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.network(
                  'https://cors-anywhere.herokuapp.com/${game.thumbnail}',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buttonPlayNow(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                game.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                game.shortDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Informações adicionais'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildGameInfo(context),
            ),
          ],
        ),
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
}

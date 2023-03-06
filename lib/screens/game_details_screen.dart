import 'package:flutter/material.dart';
import 'package:freetogame/components/details_system_requirements.dart';
import 'package:freetogame/models/game_details.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/details_game_info.dart';
import '../services/game_service.dart';

class GameDetailsScreen extends StatefulWidget {
  final GameDetails game;

  const GameDetailsScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes do Jogo',
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.network(
                  '${GameService.baseUrl}${widget.game.thumbnail}',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Image.asset(
                        'assets/images/nophoto.png',
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
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
                widget.game.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                text: TextSpan(
                  text: widget.game.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white60),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Informações adicionais'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildGameInfo(context, widget.game),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Screenshots de ${widget.game.title}'),
                ),
                widget.game.screenshots != null
                    ? Screenshots(
                        game: widget.game,
                      )
                    : const Text('Nenhuma screenshot neste jogo'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.game.minimumSystemRequirements == null
                  ? const Center(
                      child: Text('Não há informações do sistema operacional'),
                    )
                  : const Text('Requisitos mínimos do sistema'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.game.minimumSystemRequirements != null
                  ? buildSystemRequirements(context, widget.game)
                  : const Center(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonPlayNow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.widgets_rounded,
            size: 14,
          ),
          label: Text(widget.game.status),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade900,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            launchUrl(Uri.base.resolve(widget.game.gameUrl));
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('JOGAR AGORA'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        )
      ],
    );
  }
}

class Screenshots extends StatelessWidget {
  const Screenshots({
    super.key,
    required this.game,
  });

  final GameDetails game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...List.generate(
                  game.screenshots!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        '${GameService.baseUrl}${game.screenshots![index].image}',
                        fit: BoxFit.cover,
                        width: 200,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

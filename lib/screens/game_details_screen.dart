import 'package:flutter/material.dart';
import 'package:freetogame/components/details_system_requirements.dart';
import 'package:freetogame/models/game_details.dart';

import '../components/details_game_info.dart';

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
                  'https://cors-anywhere.herokuapp.com/${widget.game.thumbnail}',
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
                widget.game.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.game.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white60),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.game.minimumSystemRequirements == null
                  ? const Center()
                  : const Text('Requisios mínimos do sistema'),
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
          icon: const Icon(Icons.play_arrow),
          label: const Text('JOGAR AGORA'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }
}

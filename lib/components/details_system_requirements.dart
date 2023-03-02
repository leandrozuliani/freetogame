import 'package:flutter/material.dart';
import 'package:freetogame/models/game_details.dart';

Widget buildSystemRequirements(BuildContext context, GameDetails game) {
  final systemRequirements = game.minimumSystemRequirements!;

  final informationSystemRequirements = game.minimumSystemRequirements == null
      ? Container()
      : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Sistema Operacional:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    systemRequirements.os != null ? systemRequirements.os! : '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white60),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Processador:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    systemRequirements.processor != null
                        ? systemRequirements.processor!
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white60),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Memória:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    systemRequirements.memory != null
                        ? systemRequirements.memory!
                        : '',
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
                    'Placa de Vídeo:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    systemRequirements.graphics != null
                        ? systemRequirements.graphics!
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white60),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Armazenamento:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    systemRequirements.storage != null
                        ? systemRequirements.storage!
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ),
          ],
        );

  return MediaQuery.of(context).size.width < 500
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Requisitos do Sistema',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            informationSystemRequirements,
          ],
        )
      : SizedBox(
          height: 200,
          child: informationSystemRequirements,
        );
}

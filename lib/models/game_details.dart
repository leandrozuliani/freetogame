import 'package:freetogame/models/game.dart';

import 'screenshot.dart';
import 'system_requirements.dart';

class GameDetails extends Game {
  final String status;
  final String description;
  final SystemRequirements? minimumSystemRequirements;
  final List<Screenshot>? screenshots;

  GameDetails({
    required int id,
    required String title,
    required String thumbnail,
    required String shortDescription,
    required String gameUrl,
    required String genre,
    required String platform,
    required String publisher,
    required String developer,
    required DateTime releaseDate,
    required String freetogameProfileUrl,
    required this.status,
    required this.description,
    this.minimumSystemRequirements,
    this.screenshots,
  }) : super(
          id: id,
          title: title,
          thumbnail: thumbnail,
          shortDescription: shortDescription,
          gameUrl: gameUrl,
          genre: genre,
          platform: platform,
          publisher: publisher,
          developer: developer,
          releaseDate: releaseDate,
          freetogameProfileUrl: freetogameProfileUrl,
        );

  factory GameDetails.fromJson(Map<String, dynamic> json) {
    return GameDetails(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      shortDescription: json['short_description'],
      gameUrl: json['game_url'],
      genre: json['genre'],
      platform: json['platform'],
      publisher: json['publisher'],
      developer: json['developer'],
      releaseDate: DateTime.parse(json['release_date']),
      freetogameProfileUrl: json['freetogame_profile_url'],
      status: json['status'],
      description: json['description'],
      minimumSystemRequirements: json['minimum_system_requirements'] == null
          ? null
          : SystemRequirements.fromJson(json['minimum_system_requirements']),
      screenshots: List<Screenshot>.from(json['screenshots']
          .map((screenshot) => Screenshot.fromJson(screenshot))),
    );
  }
}

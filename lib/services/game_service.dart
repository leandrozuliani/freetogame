import 'dart:convert';
import 'package:freetogame/models/game_details.dart';
import 'package:http/http.dart' as http;
import 'package:freetogame/models/game.dart';

class GameService {
  static const String baseUrl =
      'https://free-to-play-games-database.p.rapidapi.com';

  static const Map<String, String> headers = {
    'x-rapidapi-host': 'free-to-play-games-database.p.rapidapi.com',
    'x-rapidapi-key':
        String.fromEnvironment('X_RAPIDAPI_KEY', defaultValue: ''),
  };

  static Future<List<Game>> fetchGames() async {
    final request = http.Request('GET', Uri.parse('$baseUrl/api/games'));
    request.headers.addAll(headers);

    final response = await request.send();
    final jsonList = jsonDecode(await response.stream.bytesToString());

    return List<Game>.from(jsonList.map((game) => Game.fromJson(game)));
  }

  static Future<GameDetails> fetchSpecificGame(int id) async {
    final gameDetailUrl = '$baseUrl/api/game?id=$id';

    final request = http.Request('GET', Uri.parse(gameDetailUrl));
    request.headers.addAll(headers);

    final response = await request.send();
    final jsonMap = jsonDecode(await response.stream.bytesToString());

    return GameDetails.fromJson(jsonMap);
  }
}

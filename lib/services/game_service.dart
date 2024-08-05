import 'dart:convert';
import 'package:freetogame/models/game_details.dart';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameService {
  static const String baseUrl =
      'https://free-to-play-games-database.p.rapidapi.com';

  static Future<List<Game>> fetchGames() async {
    final request = http.Request('GET', Uri.parse('$baseUrl/api/games'));

    final response = await request.send();
    final jsonList = jsonDecode(await response.stream.bytesToString());

    return List<Game>.from(jsonList.map((game) => Game.fromJson(game)));
  }

  static Future<GameDetails> fetchSpecificGame(int id) async {
    String gameDetailUrl = '$baseUrl/api/game?id=$id';

    final request = http.Request('GET', Uri.parse(gameDetailUrl));

    final response = await request.send();
    final jsonMap = jsonDecode(await response.stream.bytesToString());

    return GameDetails.fromJson(jsonMap);
  }
}

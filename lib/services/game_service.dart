import 'dart:convert';
import 'package:freetogame/models/game_details.dart';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameService {
  static const String baseUrl = 'http://localhost:3000/resource?url=';
  static const String _gameUrl =
      '${baseUrl}https://free-to-play-games-database.p.rapidapi.com';

  static const String _apiUrl = '$_gameUrl/api/games';

  static Future<List<Game>> fetchGames() async {
    final request = http.Request('GET', Uri.parse(_apiUrl));

    final response = await request.send();
    final jsonList = jsonDecode(await response.stream.bytesToString());

    return List<Game>.from(jsonList.map((game) => Game.fromJson(game)));
  }

  static Future<GameDetails> fetchSpecificGame(int id) async {
    String gameDetailUrl = '$_gameUrl/api/game?id=$id';

    final request = http.Request('GET', Uri.parse(gameDetailUrl));

    final response = await request.send();
    final jsonMap = jsonDecode(await response.stream.bytesToString());

    return GameDetails.fromJson(jsonMap);
  }
}

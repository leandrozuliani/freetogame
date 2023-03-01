import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameService {
  static const String _apiUrl =
      'https://free-to-play-games-database.p.rapidapi.com/api/filter?tag=3d.mmorpg.fantasy.pvp&platform=pc';

  static Future<List<Game>> fetchGames() async {
    Map<String, String> headers = getHeaders();

    final request = http.Request('GET', Uri.parse(_apiUrl));
    request.headers.addAll(headers);

    final response = await request.send();
    final jsonList = jsonDecode(await response.stream.bytesToString());

    return List<Game>.from(jsonList.map((game) => Game.fromJson(game)));
  }

  static Map<String, String> getHeaders() {
    return {
      "X-RapidAPI-Key": "f05c31a25amshc81d8eb31d1b4b1p18a40ajsnb82160234b41",
      "X-RapidAPI-Host": "free-to-play-games-database.p.rapidapi.com",
    };
  }
}

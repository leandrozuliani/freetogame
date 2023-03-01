import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameService {
  static const String _apiUrl = 'https://www.freetogame.com/api/games';

  static Future<List<Game>> fetchGames() async {
    final response = await http.get(Uri.parse(_apiUrl));

    final json = jsonDecode(response.body) as List<dynamic>;
    return json.map((jsonMap) => Game.fromJson(jsonMap)).toList();
  }
}

import 'dart:convert';
import 'package:freetogame/models/game_details.dart';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameService {
  // https://www.freetogame.com/api/games - essa API requer registro que se torna a URL abaixo
  static const String _apiUrl =
      'https://free-to-play-games-database.p.rapidapi.com/api/games';

  static Future<List<Game>> fetchGames() async {
    Map<String, String> headers = getHeaders();

    final request = http.Request('GET', Uri.parse(_apiUrl));
    request.headers.addAll(headers);

    final response = await request.send();
    final jsonList = jsonDecode(await response.stream.bytesToString());

    return List<Game>.from(jsonList.map((game) => Game.fromJson(game)));
  }

  static Future<GameDetails> fetchSpecificGame(int id) async {
    const String gameDetailUrl =
        'https://free-to-play-games-database.p.rapidapi.com/api/game';

    Map<String, String> headers = getHeaders();

    final request = http.Request('GET', Uri.parse('$gameDetailUrl?id=$id'));
    request.headers.addAll(headers);

    final response = await request.send();
    final jsonMap = jsonDecode(await response.stream.bytesToString());

    return GameDetails.fromJson(jsonMap);
  }

  /// TODO: valor da Key não deve ficar guardado aqui
  /// Flutter Web não suporta  Platform.environment`
  /// final String appkey = Platform.environment['X-RapidAPI-Key'].toString();

  static Map<String, String> getHeaders() {
    return {
      "X-RapidAPI-Key": "f05c31a25amshc81d8eb31d1b4b1p18a40ajsnb82160234b41",
      "X-RapidAPI-Host": "free-to-play-games-database.p.rapidapi.com",
    };
  }

  // retorna os header para a API de thumbnails dos jogos, que requerem tratamento de CORS
  // foi utilizado o serviço publico https://proxy.cors.sh/ que requer registro
  static Map<String, String> imageHeaders() {
    return {'x-cors-api-key': 'temp_543b6fc5efb095715c6c5b3c511bc8aa'};
  }
}

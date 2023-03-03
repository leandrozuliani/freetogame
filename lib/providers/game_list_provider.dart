import 'package:flutter/material.dart';
import 'package:freetogame/models/game.dart';

class GameListProvider extends ChangeNotifier {
  List<Game> _games = [];
  List<Game> _filteredAndSortedGames = [];

  List<Game> get games => _games;
  List<Game> get filteredAndSortedGames => _filteredAndSortedGames;

  void setGames(List<Game> games) {
    _games = games;
    _filteredAndSortedGames = games;
    notifyListeners();
  }

  void setFilteredAndSortedGames(List<Game> filteredAndSortedGames) {
    _filteredAndSortedGames = filteredAndSortedGames;
    notifyListeners();
  }
}

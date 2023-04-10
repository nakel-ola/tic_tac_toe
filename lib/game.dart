import 'dart:math';

import 'package:collection/collection.dart';

const List<List<int>> winIndexes = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6]
];

String? _user, _computer;
String _playerTurn = "user";

class Game {
  List<String> _tiles = List.generate(9, (index) => "");
  int _userScore = 0, _computerScore = 0;
  Map<String, dynamic>? _latestWinner;

  String? get user => _user;
  String? get computer => _computer;
  String get playerTurn => _playerTurn;
  List<String> get tiles => _tiles;
  int get userScore => _userScore;
  int get computerScore => _computerScore;
  Map<String, dynamic>? get latestWinner => _latestWinner;

  void updatePlayer(String user, String computer) {
    _user = user;
    _computer = computer;
  }

  void resetGame() {
    _tiles = List.generate(9, (index) => "");
    _latestWinner = null;
    _playerTurn = "user";
    _computerScore = 0;
    _userScore = 0;
    _user = null;
    _computer = null;
  }

  void restartGame() {
    _tiles = List.generate(9, (index) => "");
    _latestWinner = null;
    _playerTurn = "user";
  }

  List<int> _checksWinner(List<int> element, List<int> list) {
    List<int> newList = [];
    for (var el in list) {
      if (element.contains(el)) newList.add(el);
    }
    return newList;
  }

  List<int> _getIndexes(String value) {
    List<int> list = [];

    for (var i = 0; i < _tiles.length; i++) {
      if (_tiles[i] == value) list.add(i);
    }

    Function eq = const ListEquality().equals;

    for (var element in winIndexes) {
      final newList = _checksWinner(element, list);
      if (eq(newList, element)) return newList;
    }

    return [];
  }

  bool _getWinInx() {
    // finding the length user and computer have occupied
    int userTotal = _tiles.where((item) => item == user).length;
    int computerTotal = _tiles.where((item) => item == computer).length;

    // if user total is greater then or equal 3
    if (userTotal >= 3) {
      // getting matching indexes
      final indexes = _getIndexes(user!);

      // checking if matching indexes length is equal to 3
      if (indexes.length == 3 && _latestWinner == null) {
        // updating user score and winner tile
        _userScore += 1;
        _latestWinner = {"name": user, "indexes": indexes};

        return true;
      }
    }

    // if computer total is greater then or equal 3
    if (computerTotal >= 3) {
      // getting matching indexes
      final indexes = _getIndexes(computer!);

      if (indexes.length == 3 && _latestWinner == null) {
        // updating computer score and winner tile
        _computerScore += 1;
        _latestWinner = {"name": computer, "indexes": indexes};

        return true;
      }
    }

    return false;
  }

  List<int> _getEmptyTiles() {
    List<int> list = [];

    for (var i = 0; i < _tiles.length; i++) {
      if (_tiles[i].isEmpty) list.add(i);
    }

    return list;
  }

  List<int> _removeFilledInx(List<int> list) {
    List<int> newList = [];

    for (var i = 0; i < list.length; i++) {
      if (_tiles[list[i]] == "") newList.add(list[i]);
    }

    return newList;
  }

  List<int> _findMatch(List<int> postions) {
    List<int> result = [];

    for (var indexes in winIndexes) {
      List<int> possMatch = [];

      for (var inx in indexes) {
        if (postions.contains(inx)) possMatch.add(inx);
      }

      if (possMatch.length == 2) {
        List<int> newIndexes = [...indexes];
        newIndexes.remove(possMatch[0]);
        newIndexes.remove(possMatch[1]);
        result.add(newIndexes[0]);
      }
    }

    return _removeFilledInx(result);
  }

  List<int> _findComputerPossibleWin() {
    // find list of tiles that as the computer symbol
    int computerTotal = _tiles.where((item) => item == computer).length;

    // checking if total computer tiles is less than 2 then return an empty list
    if (computerTotal < 2) return [];

    List<int> computerPositions = [];

    for (var i = 0; i < _tiles.length; i++) {
      if (_tiles[i] == computer) computerPositions.add(i);
    }

    return _findMatch(computerPositions);
  }

  void computerPlay() {
    if (_playerTurn != "computer" || _latestWinner != null) return;

    int? computerIndex;
    // getting array of index that can make computer win
    final possibleList = _findComputerPossibleWin();

    // if possible win is not empty return the first index
    if (possibleList.isNotEmpty) computerIndex = possibleList[0];

    // if possible win is empty get empty tile
    final emptyTiles = _getEmptyTiles();

    if (computerIndex == null) {
      // generate a random number from the empty list
      final nextInx = Random().nextInt(emptyTiles.length - 1);
      computerIndex = emptyTiles[nextInx];
    }

    // adding user picked inx
    _tiles[computerIndex] = _computer!;

    // checking if user won
    final bool computerWin = _getWinInx();

    final emptyTiles_1 = _getEmptyTiles();

    if (computerWin || emptyTiles_1.isEmpty) return;

    _playerTurn = "user";
  }

  void onTileTap(int index) {
    if (_playerTurn != "user") return;

    final bool isIndexEmpty = _tiles[index].isEmpty;

    if (_latestWinner != null || !isIndexEmpty) return;

    _tiles[index] = user!;

    // checking if user won
    final bool win = _getWinInx();

    final List<int> emptyTiles = _getEmptyTiles();

    if (win || emptyTiles.isEmpty) return;

    _playerTurn = "computer";
  }
}

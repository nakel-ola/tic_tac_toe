import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../widgets/widgets.dart';

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

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> _items = List.generate(9, (index) => "");
  int _userScore = 0;
  int _aiScore = 0;
  String _playerTurn = "ai";
  Map<String, dynamic>? _latestWinner;

  _resetGame() {
    setState(() {
      _items = List.generate(9, (index) => "");
      _latestWinner = null;
      _playerTurn = "ai";
    });
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

    for (var i = 0; i < _items.length; i++) {
      if (_items[i] == value) list.add(i);
    }

    Function eq = const ListEquality().equals;

    for (var element in winIndexes) {
      final newList = _checksWinner(element, list);
      if (eq(newList, element)) return newList;
    }

    return [];
  }

  bool _getWinInx() {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    dynamic ai = data["ai"];
    dynamic user = data["user"]!;

    // finding the length user and ai have occupied
    int userTotal = _items.where((item) => item == user).length;
    int aiTotal = _items.where((item) => item == data["ai"]).length;

    // if user total is greater then or equal 3
    if (userTotal >= 3) {
      // getting matching indexes
      final indexes = _getIndexes(user);

      // checking if matching indexes length is equal to 3
      if (indexes.length == 3 && _latestWinner == null) {
        // updating user score and winner tile
        setState(() {
          _userScore += 1;
          _latestWinner = {"name": user, "indexes": indexes};
        });

        return true;
      }
    }

    // if ai total is greater then or equal 3
    if (aiTotal == 3) {
      // getting matching indexes
      final indexes = _getIndexes(ai);

      if (indexes.length == 3 && _latestWinner == null) {
        // updating ai score and winner tile
        setState(() {
          _aiScore += 1;
          _latestWinner = {"name": ai, "indexes": indexes};
        });

        return true;
      }
    }
    return false;
  }

  List<int> _getEmpty() {
    List<int> list = [];
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].isEmpty) list.add(i);
    }

    return list;
  }

  List<int> _removeFillInx(List<int> list) {
    List<int> newList = [];

    for (var i = 0; i < list.length; i++) {
      if (_items[list[i]] == "") newList.add(list[i]);
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

    return _removeFillInx(result);
  }

  List<int> _findAiPossibleWin() {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    dynamic ai = data["ai"]!;

    // find list of tiles that as the ai symbol
    int aiTotal = _items.where((item) => item == ai).length;

    // checking if total ai tiles is less than 2 then return an empty list
    if (aiTotal < 2) return [];

    List<int> aiPositions = [];

    for (var i = 0; i < _items.length; i++) {
      if (_items[i] == ai) aiPositions.add(i);
    }

    return _findMatch(aiPositions);
  }

  _playAi() {
    // getting array of index that can make ai win
    final possibleList = _findAiPossibleWin();

    // if possible win is not empty return the first index
    if (possibleList.isNotEmpty) return possibleList[0];

    // if possible win is empty get empty tile
    final emptyList = _getEmpty();

    // generate a random number from the empty list
    final nextInx = Random().nextInt(emptyList.length - 1);

    return emptyList[nextInx];
  }

  _onCardTap(int inx) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    final bool isIndexEmpty = _items[inx].isEmpty;

    if (_latestWinner != null || !isIndexEmpty) return;

    // adding user picked inx

    setState(() => _items[inx] = data["user"]!);

    // checking if user won
    final bool win = _getWinInx();

    final List<int> emptyList = _getEmpty();

    // if not let ai play

    if (win || emptyList.isEmpty) return;

    setState(() => _playerTurn = "ai");
    // delaying ai for 0.5 seconds
    Future.delayed(const Duration(milliseconds: 500), () {
      final aiInx = _playAi();

      // adding user picked inx
      setState(() => _items[aiInx] = data["ai"]!);

      // checking if user won
      final bool aiWin = _getWinInx();

      if (!aiWin) {
        setState(() => _playerTurn = "user");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Scores(aiScore: _aiScore, userScore: _userScore),
            const SizedBox(height: 16.0),
            GameBoard(
              items: _items,
              onCardTap: _onCardTap,
              winIndexes: _latestWinner,
              isAiTurn: _playerTurn == "ai",
            ),
            const SizedBox(height: 24.0),
            Text(
              _playerTurn == "ai" ? "Ai turn" : "Your turn",
              style: TextStyle(
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

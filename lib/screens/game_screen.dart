import 'package:flutter/material.dart';

import '../game.dart';
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
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              game.restartGame();
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                game.restartGame();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8.0)
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Scores(aiScore: game.computerScore, userScore: game.userScore),
              const SizedBox(height: 16.0),
              GameBoard(
                items: game.tiles,
                onCardTap: (index) {
                  if (game.latestWinner != null) return;

                  game.onTileTap(index);
                  setState(() {});

                  Future.delayed(const Duration(milliseconds: 500), () {
                    game.computerPlay();
                    setState(() {});
                  });
                },
                winIndexes: game.latestWinner,
                isAiTurn: game.playerTurn == "computer",
              ),
              const SizedBox(height: 24.0),
              Text(
                game.playerTurn == "computer" ? "Computer turn" : "Your turn",
                style: TextStyle(
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

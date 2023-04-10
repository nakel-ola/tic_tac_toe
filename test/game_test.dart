import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/game.dart';

// String? get user => _user;
//   String? get computer => _computer;
//   String get playerTurn => _playerTurn;
//   List<String> get tiles => _tiles;
//   int get userScore => _userScore;
//   int get computerScore => _computerScore;
//   Map<String, dynamic>? get latestWinner => _latestWinner;
void main() {
  // given when then

  group("Game class", () {
    final Game game = Game();

    test(
      "given game class when it is instantiated then the value of user should be null",
      () {
        expect(game.user, null);
        expect(game.computer, null);
        expect(game.playerTurn, "user");
        expect(game.tiles.length, 9);
        expect(game.userScore, 0);
        expect(game.computerScore, 0);
        expect(game.latestWinner, null);
      },
    );

    test(
      "given game class when players are updated then the value of user should be x and the value of computer should be o",
      () {
        game.updatePlayer("x", "o");

        expect(game.user, "x");
        expect(game.computer, "o");
      },
    );

    test(
      "given game class when user play then the value of tiles index 0 should be x",
      () {
        game.onTileTap(0);

        final firstValue = game.tiles[0];

        expect(firstValue, "x");
      },
    );

    test(
      "given game class when restart is clicked then the value of initiated variable should be null",
      () {
        game.restartGame();
        expect(game.playerTurn, "user");
        expect(game.tiles.length, 9);
        expect(game.latestWinner, null);
      },
    );

    test(
      "given game class when reset is clicked then the value of initiated variable should be null",
      () {
        game.resetGame();
        expect(game.user, null);
        expect(game.computer, null);
        expect(game.playerTurn, "user");
        expect(game.tiles.length, 9);
        expect(game.userScore, 0);
        expect(game.computerScore, 0);
        expect(game.latestWinner, null);
      },
    );
  });
}

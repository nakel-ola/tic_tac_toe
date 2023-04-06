import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final List<String> items;
  final Function(int) onCardTap;
  final Map<String, dynamic>? winIndexes;
  final bool isAiTurn;

  const GameBoard({
    super.key,
    required this.items,
    required this.onCardTap,
    required this.winIndexes,
    required this.isAiTurn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.9,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        children: [
          for (int i = 0; i < items.length; i++)
            GestureDetector(
              onTap: () {
                if (winIndexes == null || !isAiTurn) {
                  onCardTap(i);
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: getRadius(i),
                  side: BorderSide(color: getColor(i), width: 2.0),
                ),
                margin: const EdgeInsets.all(2.0),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  child: items[i].isNotEmpty
                    ? Center(
                        child: Image.asset(
                          items[i] == "o" ? "assets/o.png" : "assets/x.png",
                          width: 60,
                        ),
                      )
                    : null,
                ),
              ),
            )
        ],
      ),
    );
  }

  BorderRadiusGeometry getRadius(int inx) {
    const Radius radius = Radius.circular(20);
    switch (inx) {
      case 0:
        return const BorderRadius.only(topLeft: radius);
      case 2:
        return const BorderRadius.only(topRight: radius);
      case 6:
        return const BorderRadius.only(bottomLeft: radius);
      case 8:
        return const BorderRadius.only(bottomRight: radius);
      default:
        return BorderRadius.circular(0.0);
    }
  }

  Color getColor(int i) {
    if (winIndexes == null) return Colors.transparent;

    final bool isIndex =
        winIndexes!["indexes"].indexWhere((inx) => inx == i) != -1;

    if (isIndex) {
      if (winIndexes!["name"] == "o") {
        return Colors.blue;
      } else {
        return Colors.red;
      }
    }

    return Colors.transparent;
  }
}

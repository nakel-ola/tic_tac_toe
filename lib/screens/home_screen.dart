import 'package:flutter/material.dart';

import '../game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Game game = Game();

  String currentOption = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Pick your side",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildImage(
                  src: "assets/x.png",
                  name: "x",
                  onChanged: (value) {
                    setState(() {
                      currentOption = value;
                      game.updatePlayer("x", "o");
                    });
                  },
                ),
                buildImage(
                  src: "assets/o.png",
                  name: "o",
                  onChanged: (value) {
                    setState(() {
                      currentOption = value;
                      game.updatePlayer("o", "x");
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  "/game",
                  arguments: {
                    "user": currentOption,
                    "ai": currentOption == "x" ? "o" : "x"
                  },
                );
              },
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  buildImage({
    required String src,
    required String name,
    required Function onChanged,
  }) {
    return Column(
      children: [
        Image.asset(src, width: 100),
        const SizedBox(
          height: 24.0,
        ),
        Transform.scale(
          scale: 1.5,
          child: Radio(
            value: name,
            groupValue: currentOption,
            onChanged: (value) => onChanged(value!),
          ),
        )
      ],
    );
  }
}

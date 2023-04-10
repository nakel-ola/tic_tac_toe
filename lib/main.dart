import 'package:flutter/material.dart';

import 'color_schemes.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        fontFamily: "Roboto",
      ),
      routes: {
        "/": (ctx) => const HomeScreen(),
        "/game": (ctx) => const GameScreen(),
      },
    );
  }
}

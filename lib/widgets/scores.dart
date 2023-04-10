import 'package:flutter/material.dart';
import 'responsive.dart';

class Scores extends StatelessWidget {
  final int userScore;
  final int aiScore;
  const Scores({super.key, required this.userScore, required this.aiScore});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "You",
                style: TextStyle(
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            flex: Responsive.isMobile(context) ? 2 : 1,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Center(
                  child: Text(
                    "$userScore - $aiScore",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Computer",
                style: TextStyle(
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

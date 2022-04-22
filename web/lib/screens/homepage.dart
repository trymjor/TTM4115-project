import 'package:flutter/material.dart';
import 'package:web/widgets/home_cards/chess_game_card.dart';
import 'package:web/widgets/home_cards/on_hover_card.dart';
import 'package:web/widgets/home_cards/quiz_card.dart';
import 'package:web/widgets/home_cards/video_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                'Join or create a new lobby:',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    OnHoverCard(child: ChessGameCard()),
                    OnHoverCard(child: QuizCard()),
                  ],
                ),
                const OnHoverCard(child: VideoCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

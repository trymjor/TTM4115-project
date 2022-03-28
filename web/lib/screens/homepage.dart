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
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "Join Button",
              onPressed: () {
                print("Lobby joined.");
              },
              child: const Icon(Icons.wheelchair_pickup),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
                heroTag: "Create Button",
                onPressed: () {
                  print("Lobby created.");
                },
                child: const Icon(
                  Icons.add,
                )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

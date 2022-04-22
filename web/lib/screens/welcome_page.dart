import 'package:flutter/material.dart';
import 'package:web/screens/quiz_page.dart';
import 'package:web/widgets/home_cards/chess_game_card.dart';
import 'package:web/widgets/home_cards/on_hover_card.dart';
import 'package:web/widgets/home_cards/quiz_card.dart';
import 'package:web/widgets/home_cards/video_card.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<WelcomePage> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                'Lets play Quiz!',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            const Text("Please enter team name below"),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 400,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Team name',
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuizPage(
                              title: 'Quiz Page',
                              teamName: _controller.text,
                            )),
                  );
                },
                child: const Text("Start Quiz")),
          ],
        ),
      ),
    );
  }
}

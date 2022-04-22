import 'package:flutter/material.dart';

class QuizScore extends StatelessWidget {
  const QuizScore({Key? key, required this.score}) : super(key: key);
  final score;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Score',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Score'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  score,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

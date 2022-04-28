import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:web/modules/question.dart';
import 'package:web/screens/quiz_score_page.dart';
//import 'package:web/widgets/quiz_widgets/quiz_answer.dart';
//import 'package:web/widgets/quiz_widgets/quiz_question.dart';

final String backend = "https://ttm4115-quiz-backend.herokuapp.com";

/// QuizPage
class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.title, required this.teamName})
      : super(key: key);
  final String title;
  final String teamName;
  @override
  State<QuizPage> createState() => _QuizPage();
}

class _QuizPage extends State<QuizPage> {
  List<Question> quizQuestions = [];
  late Question currentQuestion;
  int _currentQuestionIndex = 0;
  List<String> _answers = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await fetchQuestions();
      setState(() {});
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  quizQuestions[_currentQuestionIndex].question,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                width: 500,
                height: 500,
                child: getQuestionChoices(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchQuestions() async {
    final response = await http.get(Uri.parse(backend + "/room/1"));
    Map<String, dynamic> data = jsonDecode(response.body);
    for (var entry in data['questions']) {
      final question = Question(
          question: entry['question'],
          answersChoices: entry['possible_answers']);
      quizQuestions.add(question);
    }
  }

  ListView getQuestionChoices() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      // Let the ListView know how many items it needs to build.
      itemCount: quizQuestions[_currentQuestionIndex].answersChoices.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = quizQuestions[_currentQuestionIndex].answersChoices[index];
        return SizedBox(
          height: 100,
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(item),
              onPressed: () {
                _checkAnswer(item);
              },
            ),
          ), //RaisedButton
        );
      },
    );
  }

  /// Sendes score to server and navigates to QuizScore page
  void _getScore() async {
    // Send answsers to server
    Map data = {'answers': _answers, "name": widget.teamName};
    await http.post(Uri.parse(backend + "/room/1/"),
        headers: {"Content-Type": "application/json"}, body: json.encode(data));
    final response =
        await http.get(Uri.parse(backend + "/score/1/${widget.teamName}"));
    final score = response.body;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuizScore(
                score: score,
              )),
    );
  }

  /// Gets new quizquestion from server and displays it
  void _getNextQuestion() async {
    if (_currentQuestionIndex >= quizQuestions.length - 1) {
      print("Quiz over");
      _getScore();
    } else {
      _currentQuestionIndex++;
      setState(() {
        getQuestionChoices();
      });
    }
  }

  /// Checks if the given [answer] is correct
  _checkAnswer(String answer) {
    _answers.add(answer);
    _getNextQuestion();
    print("Questions left: ${10 - _currentQuestionIndex}");
  }
}

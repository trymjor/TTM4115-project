import 'package:flutter/material.dart';
import 'package:web/screens/video_page.dart';

class QuizQuestion extends StatelessWidget {
  const QuizQuestion({Key? key, required this.question}) : super(key: key);
  final String question;

  @override
  Widget build(BuildContext context) {
    return Text(question);
  }
}

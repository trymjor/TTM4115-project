import 'package:flutter/material.dart';
import 'package:web/screens/video_page.dart';

class QuizAnswer extends StatelessWidget {
  const QuizAnswer({Key? key, required this.answer, required this.notifyParent})
      : super(key: key);
  final Function() notifyParent;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text(answer),
          onPressed: () {},
        ),
      ), //RaisedButton
    ); //Container
  }
}

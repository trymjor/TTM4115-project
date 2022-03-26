import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizCard extends StatefulWidget {
  const QuizCard({Key? key}) : super(key: key);
  @override
  State<QuizCard> createState() => _QuizCard();
}

class _QuizCard extends State<QuizCard> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height / 3,
      width: screenSize.height / 3,
      padding: const EdgeInsets.all(10),
      child: const Card(
        child: Image(
          image: AssetImage('assets/quiz_image.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

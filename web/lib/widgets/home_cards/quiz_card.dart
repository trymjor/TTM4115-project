import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web/screens/quiz_page.dart';
import 'package:web/screens/welcome_page.dart';

class QuizCard extends StatefulWidget {
  const QuizCard({Key? key}) : super(key: key);
  @override
  State<QuizCard> createState() => _QuizCard();
}

class _QuizCard extends State<QuizCard> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const WelcomePage(
                    title: 'Quiz Page',
                  )),
        );
      },
      child: Container(
        height: screenSize.height / 3,
        width: screenSize.height / 3,
        padding: const EdgeInsets.all(10),
        child: const Card(
          child: Image(
            image: AssetImage('assets/quiz_image.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

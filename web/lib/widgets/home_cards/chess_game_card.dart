import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web/screens/chess_page.dart';

///Each Card is used as a routing element for a new page.
class ChessGameCard extends StatefulWidget {
  const ChessGameCard({Key? key}) : super(key: key);
  @override
  State<ChessGameCard> createState() => _ChessGameCard();
}

class _ChessGameCard extends State<ChessGameCard> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ChessPage(
                    title: 'Chess Page',
                  )),
        );
      },
      child: Container(
        height: screenSize.height / 3,
        width: screenSize.height / 3,
        padding: const EdgeInsets.all(10),
        child: const Card(
          child: Image(
            image: AssetImage('assets/chess_image.jpg'),
          ),
        ),
      ),
    );
  }
}

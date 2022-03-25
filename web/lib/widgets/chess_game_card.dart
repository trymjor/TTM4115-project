import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChessGameCard extends StatefulWidget {
  const ChessGameCard({Key? key}) : super(key: key);
  @override
  State<ChessGameCard> createState() => _ChessGameCard();
}

class _ChessGameCard extends State<ChessGameCard> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height / 3,
      width: screenSize.height / 3,
      padding: const EdgeInsets.all(10),
      child: const Card(
        color: Colors.blue,
      ),
    );
  }
}

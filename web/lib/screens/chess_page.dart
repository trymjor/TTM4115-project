import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class ChessPage extends StatefulWidget {
  const ChessPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<ChessPage> createState() => _ChessPage();
}

class _ChessPage extends State<ChessPage> {
  ChessBoardController controller = ChessBoardController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          height: 600,
          width: 600,
          child: ChessBoard(
            controller: controller,
            boardColor: BoardColor.orange,
            boardOrientation: PlayerColor.white,
          ),
        ),
      ),
    );
  }
}

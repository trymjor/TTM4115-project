import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<VideoPage> createState() => _VideoPage();
}

class _VideoPage extends State<VideoPage> {
  ChessBoardController controller = ChessBoardController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
    );
  }
}

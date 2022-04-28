import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

class ChessPage extends StatefulWidget {
  const ChessPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<ChessPage> createState() => _ChessPage();
}

class _ChessPage extends State<ChessPage> {
  ChessBoardController controller = ChessBoardController();
  late bool userTurn;
  PlayerColor playerColor = PlayerColor.white;
  Color teamColor = Color.WHITE;

  String isGameOver() {
    if (controller.isGameOver()) {
      return "Game over! Resetting game";
    }
    return "";
  }

  void resetGame() async {
    if (controller.isGameOver()) {
      await Future.delayed(Duration(seconds: 3));
      controller.resetBoard();
    }
  }

  @override
  void initState() {
    connectToBroker();
    super.initState();
    checkUserTurn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess'),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme().apply(bodyColor: Colors.white),
            ),
            child: PopupMenuButton<int>(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text("Menu"),
              ),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: const Text('Black'),
                  onTap: () {
                    setState(() {
                      teamColor = Color.BLACK;
                      playerColor = PlayerColor.black;
                      checkUserTurn();
                    });
                  },
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: const Text('White'),
                  onTap: () {
                    setState(() {
                      teamColor = Color.WHITE;
                      playerColor = PlayerColor.white;
                      checkUserTurn();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ChessBoard(
              controller: controller,
              size: 500,
              boardColor: BoardColor.orange,
              boardOrientation: playerColor,
              enableUserMoves: userTurn,
              onMove: () {
                sendFen(controller.getFen());
              },
            ),
          ),
          Center(
            child: ValueListenableBuilder<Chess>(
                valueListenable: controller,
                builder: (context, game, _) {
                  resetGame();
                  return Text(isGameOver(),
                      textAlign: TextAlign.center, textScaleFactor: 2);
                }),
          ),
        ],
      ),
    );
  }

  void checkUserTurn() {
    if (controller.game.turn == teamColor) {
      userTurn = true;
    } else {
      userTurn = false;
    }
    setState(() {});
  }

  var gameFEN = "";
  final client = MqttBrowserClient('ws://test.mosquitto.org', '')
    ..setProtocolV311()
    ..keepAlivePeriod = 2000
    ..port = 8080
    ..websocketProtocols = MqttClientConstants.protocolsSingleDefault;
  void sendFen(String fen) async {
    try {
      await client.connect();
      print("connected");
    } on Exception catch (e) {
      print("could not connect");
      client.disconnect();
      return;
    }

    const pubTopic = 'ramindra3';
    final builder = MqttClientPayloadBuilder();
    builder.addString(fen);
    client.subscribe(pubTopic, MqttQos.exactlyOnce);
    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!,
        retain: true);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      gameFEN =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      controller.loadFen(gameFEN);
      print(controller.getFen());
      checkUserTurn();
    });
    await MqttUtilities.asyncSleep(60);
    client.unsubscribe("ramindra3");
    print("disconnecting");
    client.disconnect();
    return;
  }

  void connectToBroker() async {
    try {
      await client.connect();
      print("connected");
    } on Exception catch (e) {
      print("could not connect");
      client.disconnect();
      return;
    }
    const pubTopic = 'ramindra3';
    client.subscribe(pubTopic, MqttQos.exactlyOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      gameFEN =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      controller.loadFen(gameFEN);
      checkUserTurn();
      print(controller.getFen());
    });
    await MqttUtilities.asyncSleep(60);
    client.unsubscribe("ramindra3");
    print("disconnecting");
    client.disconnect();
    return;
  }
}

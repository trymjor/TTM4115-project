import 'dart:io';

import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChessBoardController controller = ChessBoardController();

  String isGameOver() {
    if (controller.isGameOver()) {
      return "Game Over!";
    }
    return "";
  }

  void resetGame() {
    controller.resetBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess'),
      ),
      body: Column(
        children: [
          Center(
            child: ChessBoard(
              controller: controller,
              size: 500,
              boardColor: BoardColor.orange,
              boardOrientation: PlayerColor.white,
              onMove: () {
                sendFen(controller.getFen());
              },
            ),
          ),
          Center(
            child: ValueListenableBuilder<Chess>(
                valueListenable: controller,
                builder: (context, game, _) {
                  return Text(isGameOver(),
                      textAlign: TextAlign.center, textScaleFactor: 2);
                }),
          ),
          Center(
            child: ValueListenableBuilder<Chess>(
                valueListenable: controller,
                builder: (context, game, _) {
                  return TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        primary: Colors.red,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      onPressed: resetGame,
                      child: const Text("Restart Game"));
                }),
          ),
        ],
      ),
    );
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
    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      gameFEN =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      controller.loadFen(gameFEN);
      print(controller.getFen());
    });
    await MqttUtilities.asyncSleep(60);
    client.unsubscribe("cudo_test");
    print("disconnecting");
    client.disconnect();
    return;
  }
}

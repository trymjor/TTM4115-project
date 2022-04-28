import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/screens/video_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:typed_data';

///Each Card is used as a routing element for a new page.
class VideoCard extends StatefulWidget {
  const VideoCard({Key? key}) : super(key: key);
  @override
  State<VideoCard> createState() => _VideoCard();
}

class _VideoCard extends State<VideoCard> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        final client = MqttBrowserClient('ws://test.mosquitto.org', '')
          ..setProtocolV311()
          ..keepAlivePeriod = 2000
          ..port = 8080
          ..websocketProtocols = MqttClientConstants.protocolsSingleDefault;
        await client.connect();
        final builder = MqttClientPayloadBuilder();
        builder.addString('user joined room');
        client.publishMessage(
            "zoom_room", MqttQos.exactlyOnce, builder.payload!);
        const url =
            'https://NTNU.zoom.us/j/7789086717?pwd=MVowZEs0dzRKazdMZ1Zrenp2TFRqdz09';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        height: screenSize.height / 3,
        width: screenSize.height / 3,
        padding: const EdgeInsets.all(10),
        child: const Card(
          child: Image(
            image: AssetImage('assets/videocall_image.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

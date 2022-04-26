import 'package:flutter/material.dart';
import 'package:web/screens/video_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

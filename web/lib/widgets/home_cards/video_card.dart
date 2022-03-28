import 'package:flutter/material.dart';
import 'package:web/screens/video_page.dart';

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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const VideoPage(
                    title: 'Video Call Page',
                  )),
        );
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

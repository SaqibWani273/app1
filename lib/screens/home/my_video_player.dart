import 'package:app_for_publishing/screens/home/home_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'home.dart';

class MyVideoPlayer extends StatefulWidget {
  final Map<String, String> videoData;
  const MyVideoPlayer(this.videoData, {super.key});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  // using youtubeplayer controller
  late String videoId;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    //using youtube video player

    videoId = YoutubePlayer.convertUrlToId(widget.videoData['videoUrl']!)!;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        //mute: true,
      ),
    );
    final data = _controller.metadata;
    print(data.toString());
    print('last statement in  initstate');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SizedBox(
      height: deviceHeight,
      child: Column(
        children: [
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.amber,
                      progressColors: ProgressBarColors(
                        playedColor: Colors.amber,
                        handleColor: Colors.amberAccent,
                      ),
                      onReady: () {
                        _controller.addListener(() {
                          //   _controller.play();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12.0,
                      ),
                      child: Text('${widget.videoData['description']}'),
                    ),
                  )
                ],
              )),
          Expanded(flex: 7, child: Container()),
        ],
      ),
    ));
  }
}

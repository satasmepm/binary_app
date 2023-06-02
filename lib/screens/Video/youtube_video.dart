import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlay extends StatefulWidget {
  String Linkid;

  YouTubeVideoPlay({
    required this.Linkid,
  });

  @override
  _YouTubeVideoPlayState createState() => _YouTubeVideoPlayState();
}

class _YouTubeVideoPlayState extends State<YouTubeVideoPlay> {
  late VideoPlayerController videoplayercontroller;

  @override
  void initState() {
    super.initState();

    disableCapture();
  }

  disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() async {
    super.dispose();
    // videoplayercontroller.dispose();

    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  late YoutubePlayerController _controller;
  Future<void> initializePlayer() async {
    _controller = YoutubePlayerController(
      // initialVideoId: _ids.first,

      initialVideoId: YoutubePlayer.convertUrlToId(widget.Linkid)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    // await _videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play youtube video"),
        backgroundColor: Colors.black,
      ),
      body: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: initializePlayer(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

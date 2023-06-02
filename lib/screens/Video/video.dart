import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class videoplay extends StatefulWidget {
  String Linkid;

  videoplay({
    required this.Linkid,
  });

  @override
  _videoplayState createState() => _videoplayState();
}

class _videoplayState extends State<videoplay> {
  late VideoPlayerController videoplayercontroller;
  ChewieController? chewievontroller;

  Future<void> _initPlayer() async {
    videoplayercontroller = VideoPlayerController.network(
      widget.Linkid,
    );
    await Future.wait({
      videoplayercontroller.initialize(),
    });

    chewievontroller = ChewieController(
        videoPlayerController: videoplayercontroller,
        autoPlay: false,
        looping: false,
        // fullScreenByDefault: true,
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: () => debugPrint("Option 1 pressed"),
              iconData: Icons.chat,
              title: 'Optionm 1',
            ),
            OptionItem(
                onTap: () => debugPrint("Option 2 pressed"),
                iconData: Icons.share,
                title: 'Optionm 2'),
          ];
        });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // disableCapture();
    // _controller1 = VideoPlayerController.network(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
    _initPlayer();
    disableCapture();
  }

  disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // videoplayercontroller.dispose();
    // chewievontroller!.dispose();
  }

  @override
  void dispose() async {
    super.dispose();
    videoplayercontroller.dispose();
    chewievontroller!.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play video"),
        backgroundColor: Colors.black,
      ),
      body: Scaffold(
        backgroundColor: Colors.black,
        body: chewievontroller != null &&
                chewievontroller!.videoPlayerController.value.isInitialized
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Chewie(
                  controller: chewievontroller!,
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

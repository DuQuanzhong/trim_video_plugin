import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

///视频播放
class VideoPlayerWidget extends StatefulWidget{

  final String videoUri;
  final VideoType type;

  VideoPlayerWidget({this.videoUri,this.type = VideoType.network});

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWidgetState();
  }

}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {

  Future<void> inited;
  VideoPlayerController _controller;

  @override
  void initState() {

    if(widget.type == VideoType.asset){
      _controller = VideoPlayerController.asset(widget.videoUri);
    }else if(widget.type == VideoType.file){
      _controller = VideoPlayerController.file(File(widget.videoUri));
    }else{
      _controller = VideoPlayerController.network(widget.videoUri);
    }
    _controller.setLooping(true);
    inited = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: inited,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller)..controller.play(),
              ),
            );
          }
          return Container();
        });
  }
}

enum VideoType{
  network,
  file,
  asset
}

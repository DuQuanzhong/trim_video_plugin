import 'package:flutter/material.dart';
import 'package:trim_video_plugin/nwdn_trim_video.dart';
import 'package:trim_video_plugin_example/video_bottom_thumbnails_widget.dart';
import 'package:trim_video_plugin_example/video_player_widget.dart';

class VideoEditPage extends StatefulWidget {
  final String videoPath;

  const VideoEditPage({Key key, this.videoPath}) : super(key: key);

  @override
  _VideoEditPageState createState() => _VideoEditPageState();
}

class _VideoEditPageState extends State<VideoEditPage> {

  TrimVideoPlugin trimPlugin = TrimVideoPlugin();

  String trimVideoPath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('视频编辑'),
      ),
      body: Column(
        children: [
          //todo: 视频播放器
          trimVideoPath == null
              ? Expanded(
                  child: Container(
                  alignment: Alignment.center,
                  child: VideoPlayerWidget(
                    videoUri: widget.videoPath,
                    type: VideoType.file,
                  ),
                ))
              : Container(
                  height: 20,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text(
                    "视频截取结果",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),

          trimVideoPath == null ? Container(
            height: 20,
            color: Colors.red,
            alignment: Alignment.center,
            child: Text(
              "原视频",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ) : Expanded(
              child: Container(
                alignment: Alignment.center,
                child: VideoPlayerWidget(
                  videoUri: trimVideoPath,
                  type: VideoType.file,
                ),
              )),


          //todo:  视频缩略图
          VideoBottomThumbnailsWidget(
            videoPath: widget.videoPath,
            trimPlugin: trimPlugin,
          ),

          //todo: 截取视频
          _buildTrimWidget(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildTrimWidget() {
    return InkWell(
      onTap: () async {
        var result = await trimPlugin.trimVideo(widget.videoPath, 2.0, 3.0);
        print("截取视屏的结果");
        print(result);
        trimVideoPath = result;
        if (mounted) {
          setState(() {});
        }
      },
      child: Container(
        color: Colors.red.withOpacity(0.4),
        padding: EdgeInsets.all(20),
        child: Text('截取视频'),
      ),
    );
  }


}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trim_video_plugin/nwdn_trim_video.dart';

class VideoBottomThumbnailsWidget extends StatefulWidget {

  final String videoPath;
  final TrimVideoPlugin trimPlugin;

  const VideoBottomThumbnailsWidget({Key key, this.videoPath, this.trimPlugin}) : super(key: key);

  @override
  _VideoBottomThumbnailsWidgetState createState() => _VideoBottomThumbnailsWidgetState();
}

class _VideoBottomThumbnailsWidgetState extends State<VideoBottomThumbnailsWidget> {
  List imgDataList;

  ///  缩略图的宽度
  double imgItemWidth;
  ///  边框的宽度
  double checkBoxWidth;
  ///  屏幕的宽度
  double screenWidth;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVideoThumbnails(widget.videoPath);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    imgItemWidth = screenWidth/9;
    checkBoxWidth = imgItemWidth/4;

    if (imgDataList == null) {
      return SizedBox(
        height: imgItemWidth*1.5+ checkBoxWidth + checkBoxWidth/2,
        width: screenWidth,
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: checkBoxWidth),
      height: imgItemWidth*1.5+ checkBoxWidth + checkBoxWidth/2,
      width: screenWidth - imgItemWidth,
      child: Container(
        margin: EdgeInsets.only(
            top: checkBoxWidth,
            bottom: checkBoxWidth / 2,
            left: checkBoxWidth,
            right: checkBoxWidth),
        width: screenWidth - imgItemWidth,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: imgItemWidth,
              height: imgItemWidth * 1.5,
              child: Image.memory(
                imgDataList[index],
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: imgDataList?.length ?? 0,
        ),
      ),
    );
  }


  // todo: 获取视频的缩略图
  _getVideoThumbnails(String videoPath) {
    try {
      widget.trimPlugin.getVideoThumbnails(videoPath, callback: (double duration, List thumbnailsDataList){
        print("视屏的长度单位秒: $duration");
        imgDataList = thumbnailsDataList;
        if (mounted) {
          setState(() {});
        }
      });
    } on PlatformException {
      print('获取缩略图失败');
      return null;
    }
  }
}

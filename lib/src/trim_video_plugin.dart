
import 'dart:async';

import 'package:flutter/services.dart';

const String _methodChannelName = 'com.nwdn.plugins/trim/video/method/channel';
// const String _eventChannelName = 'com.nwdn.plugins/trim/video/event/channel';

class TrimVideoPlugin {


  static const  MethodChannel _methodChannel = const MethodChannel(_methodChannelName);
  // MethodChannel get methodChannel => _methodChannel;
  // static const EventChannel _eventChannel = const EventChannel(_eventChannelName);

  //todo: 获取视频的缩略图
  /*
  * videoPath  视频路劲
  * count      缩略图张数
  * callback   回调 视频时长和 缩略图数组
  * */
  Future getVideoThumbnails(String videoPath, {int count = 8, Function(double duration, List thumbnailsDataList) callback}) async {
    var result = await _invokeMethod("videoThumbnails", paras: {"videoPath": videoPath, 'count': count});
    ///  视屏时长
    var duration = result['duration'];
    ///  视频缩略图
    List thumbnailsDataList = result["thumbnails"];
    callback(duration, thumbnailsDataList);
  }

  //todo: 截取视频  返回视频的路劲
  /*
  * videoPath  视频路劲
  * startTime  开始时间
  * duration   截取时长
  * */
  Future<String> trimVideo(String videoPath, double startTime, double duration) async {
    var result = await _invokeMethod("trimVideo", paras: {
      "videoPath": videoPath,
      "startTime": startTime,
      "duration": duration
    });
    return result;
  }

  Future<dynamic> _invokeMethod(String method, {Map<String, dynamic> paras}) async {
    var result = await _methodChannel.invokeMethod(method, paras);
    return result;
  }
}

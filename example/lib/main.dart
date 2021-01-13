import 'package:flutter/material.dart';
import 'dart:async';

import 'package:camera_album/camera_album.dart';
import 'video_edit_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckVideoPage(),
    );
  }

}


class CheckVideoPage extends StatefulWidget {
  @override
  _CheckVideoPageState createState() => _CheckVideoPageState();
}

class _CheckVideoPageState extends State<CheckVideoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: RaisedButton(child: Text('选择视频') ,onPressed: (){
          getVideo();
        },),
      ),
    );
  }

  Future getVideo() async {

    CameraAlbum.openAlbum(
        config: CameraAlbumConfig(
            title: '选择视频',
            inType: 'video',
            firstCamera: false,
            showBottomCamera: false,
            showGridCamera: false,
            showAlbum: true,
            isMulti: false,
            multiCount: 5,
            cute: false),
        context: context,
        callback: (backs) async {
          var uploadImage = backs.paths[0];
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return VideoEditPage(
              videoPath: uploadImage,
            );
          }));
        });

  }
}

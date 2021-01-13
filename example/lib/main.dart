import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';

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

  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            getVideo();
          },
          child: Text('选取视频'),
        ),
      ),
    );
  }

  Future getVideo() async {

    // PickedFile videoFile = await picker.getVideo(source: ImageSource.gallery);
    // if (videoFile != null) {
    //   print('视频路径${videoFile.path}');
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return VideoEditPage(
    //       videoPath: videoFile.path,
    //     );
    //   }));
    // }

    CameraAlbum.openAlbum(
        config: CameraAlbumConfig(
            title: 'jjjj',
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

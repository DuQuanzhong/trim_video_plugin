import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';

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
    PickedFile videoFile = await picker.getVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return VideoEditPage(
          videoPath: videoFile.path,
        );
      }));
    }
  }
}

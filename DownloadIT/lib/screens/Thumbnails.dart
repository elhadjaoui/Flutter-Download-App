import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reddit_video_downloader/WidgetHelper/Playbtn.dart';
import 'package:reddit_video_downloader/constants/appConstant.dart';
import 'package:reddit_video_downloader/screens/VideoPlayer.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  VideoItem({this.file});
  final File file;
  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Video_Player(
                        file: widget.file,
                      ),
                    ),
                  );
                },
                child: Container(
                    height: screenWidthSize(120, context),
                    width: screenWidthSize(120, context),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: VideoPlayer(_controller)),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Play(
                    file: widget.file,
                  ),
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}

import 'dart:io';
import 'package:chewie/chewie.dart';

import 'package:flutter/material.dart';
import 'package:reddit_video_downloader/constants/appConstant.dart';
import 'package:reddit_video_downloader/screens/galleryScreen.dart';
import 'package:share_extend/share_extend.dart';
import 'package:video_player/video_player.dart';

class Video_Player extends StatefulWidget {
  final File file;
  Video_Player({this.file});
  // This will contain the URL/asset path which we want to play
  @override
  _Video_PlayerState createState() => _Video_PlayerState();
}

class _Video_PlayerState extends State<Video_Player> {
  ChewieController _chewieController;
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    // Wrapper on top of the videoPlayerController
    videoPlayerController = VideoPlayerController.file(widget.file);
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 4,

      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      looping: false,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Icon(
            Icons.error,
            color: Colors.blue,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(

        actions: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.share),
            ),
            onTap: () {
              ShareExtend.share(widget.file.path, "video");
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.delete),
            ),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Warning'),
                    content: Text(
                        'Are you sure you want to delete this video. '),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: Navigator.of(context).pop,
                      ),
                      FlatButton(
                          child: Text('Confirm'),
                          onPressed: () {
                            widget.file.delete();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GalleryScreen()));
                          }),
                    ],
                  );
                },
              );
              //  setState(() {});
            },
          )
        ],
        title: Text(
          'Video Player',
          style: new TextStyle(
            fontFamily: 'Billabong',
            fontSize: 34,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources
    videoPlayerController.dispose();
    _chewieController.dispose();
  }
}

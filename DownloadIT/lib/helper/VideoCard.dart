

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reddit_video_downloader/screens/Thumbnails.dart';
import 'package:reddit_video_downloader/screens/VideoPlayer.dart';
import 'package:reddit_video_downloader/screens/galleryScreenReddit.dart';
import 'package:share_extend/share_extend.dart';

class VideoCard extends StatefulWidget {
  VideoCard({this.file, this.info});

  final File file;
  final Widget info;

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  BoxDecoration _buildShadowAndRoundedCorners() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.4),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          spreadRadius: 2.0,
          blurRadius: 10.0,
          color: Colors.black26,
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: <Widget>[
          VideoItem(file: widget.file,),
          Positioned(
            bottom: 12.0,
            right: 12.0,
            child: _buildPlayButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return Material(
      color: Colors.black87,
      type: MaterialType.circle,
      child: InkWell(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Video_Player(
                file: widget.file,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175.0,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      decoration: _buildShadowAndRoundedCorners(),
      child: Flexible(flex: 1, child: _buildThumbnail()),
    );
  }
}
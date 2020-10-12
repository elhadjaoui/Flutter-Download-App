import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reddit_video_downloader/WidgetHelper/Playbtn.dart';
import 'package:reddit_video_downloader/constants/appConstant.dart';
import 'package:reddit_video_downloader/helper/AdsHelper.dart';
import 'package:reddit_video_downloader/helper/VideoCard.dart';
import 'package:reddit_video_downloader/screens/Thumbnails.dart';
import 'package:share_extend/share_extend.dart';


import 'VideoPlayer.dart';


Directory dir = Directory('/storage/emulated/0/DownloadIT Now/');
//Directory thumbDir = Directory('/storage/emulated/0/.DownloadIt/.thumbs');

class RedditGallery extends StatefulWidget {
  @override
  _RedditGalleryState createState() => _RedditGalleryState();
}

class _RedditGalleryState extends State<RedditGallery> {
 // List<bool> _isImage = [];


  @override
  void initState() {
    super.initState();
    //Change appId With Admob Id


  }



  @override
  Widget build(BuildContext context) {
    if (!dir.existsSync()) {
      return Center(
          child: new Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Sorry, No Downloads Found!',
                style: TextStyle(fontSize: 18.0),
              )),
        );

    } else {
      var fileList = dir.listSync();
      if (fileList.length > 0) {
        return Scaffold(
         // appBar: screenAppBar('Gallery'),
          body: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,bottom: 66.0),
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            child: GridView.builder(
              itemCount: fileList.length,
              itemBuilder: (context, index) {
                File file = fileList[index];
                return VideoItem(file: file,);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.9,
              ),
            ),
          ),
        );
      } else {
        return  Center(
            child: new Container(
                padding: EdgeInsets.only(bottom: 60.0),
                child: Text(
                  'Sorry, No Downloads Found!',
                  style: TextStyle(fontSize: 18.0),
                )),
          );
      }
    }
  }
}

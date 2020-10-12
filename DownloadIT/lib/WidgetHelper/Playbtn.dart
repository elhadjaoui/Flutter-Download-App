import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit_video_downloader/helper/AdsHelper.dart';
import 'package:reddit_video_downloader/helper/ShowAds.dart';
import 'package:reddit_video_downloader/screens/VideoPlayer.dart';

class Play extends StatelessWidget {
  final file;
  Play({this.file});
  ShowAds _showAds = ShowAds(adUnitID: AdsHelper.nativeAds);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      type: MaterialType.circle,
      child: InkWell(
        onTap: () async {
         // _showAds.showInerstitial();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Video_Player(
                file: file,
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
}


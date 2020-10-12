import 'dart:io';
import 'dart:ui';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:reddit_video_downloader/constants/appConstant.dart';
import 'package:reddit_video_downloader/helper/AdsHelper.dart';
import 'package:reddit_video_downloader/screens/whatsappDownload/imageScreen.dart';
import 'package:reddit_video_downloader/screens/whatsappDownload/videoScreen.dart';

import 'package:video_thumbnail/video_thumbnail.dart';
const String testDevice = 'MobileId';

final Directory _videoDir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses/');
final Directory thumbDir = Directory('/storage/emulated/0/.downloadit/.thumbs/');

class WhatsappDownload extends StatefulWidget {
  @override
  _WhatsappDownloadState createState() => _WhatsappDownloadState();
}

class _WhatsappDownloadState extends State<WhatsappDownload> with TickerProviderStateMixin {
  TabController _whatsappTabController;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['video', 'download'],
  );
  BannerAd _bannerAd;


  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId:AdsHelper.bannerAds,
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  _loadthumb() async {
    if (Directory("${_videoDir.path}").existsSync()) {
      var videoList = _videoDir.listSync().map((item) => item.path).where((item) => item.endsWith(".mp4")).toList(growable: false);

      for (var x in videoList) {
        var tmp = x.replaceAll(_videoDir.path.toString(), '');

        if (!File(thumbDir.path.toString() + tmp.substring(0, tmp.length - 4) + '.png').existsSync()) {
          await VideoThumbnail.thumbnailFile(
            video: x,
            thumbnailPath: thumbDir.path,
            imageFormat: ImageFormat.PNG,
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _bannerAd = createBannerAd()
      ..load().then((loaded) {
        if (loaded && this.mounted) {
          _bannerAd..show();
        }

      });
    _whatsappTabController = TabController(length: 2, vsync: this);
    if (!thumbDir.existsSync()) {
      thumbDir.createSync(recursive: true);
    }
    _loadthumb();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
    _whatsappTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: screenAppBar("WhatsApp Downloader"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              child: TabBar(controller: _whatsappTabController, indicatorColor: Colors.blue, labelColor: Colors.blue, unselectedLabelColor: Colors.blueGrey, labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0), isScrollable: false, unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0), tabs: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.photo_library),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('IMAGES'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.live_tv),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('VIDEOS'),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              height: screenHeightSize(500, context),
              child: TabBarView(
                controller: _whatsappTabController,
                children: <Widget>[
                  WAImageScreen(
                    scaffoldKey: _scaffoldKey,
                  ),
                  WAVideoScreen(
                    scaffoldKey: _scaffoldKey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

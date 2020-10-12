import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reddit_video_downloader/constants/appConstant.dart';
import 'package:reddit_video_downloader/helper/AdsHelper.dart';
import 'package:reddit_video_downloader/screens/facebookDownload/galleryScreen.dart';
import 'package:reddit_video_downloader/screens/galleryScreenReddit.dart';
import 'package:reddit_video_downloader/screens/instagramDownload/galleryScreen.dart';
import 'package:reddit_video_downloader/screens/tiktokDownload/galleryScreen.dart';
import 'package:reddit_video_downloader/screens/whatsappDownload/galleryScreen.dart';

const String testDevice = 'MobileId';
class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with TickerProviderStateMixin {
  TabController _galleryTabController;
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
  @override
  void initState() {
    super.initState();
    _bannerAd = createBannerAd()
      ..load().then((loaded) {
        if (loaded && this.mounted) {
          _bannerAd..show();
        }

      });
    _galleryTabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
    _galleryTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: screenAppBar('App Gallery'),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              child: TabBar(
                controller: _galleryTabController,
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.blueGrey,
                isScrollable: true,
                tabs: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('WhatsApp'),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('Reddit'),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('Instagram'),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('Facebook'),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('TikTok'),
                    ),
                  ),
                  // Tab(
                  //   icon: Icon(Icons.photo_library),
                  //   text: 'IMAGES',
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: screenHeightSize(650, context),
              child: TabBarView(
                controller: _galleryTabController,
                children: <Widget>[
                  WhatsappGallery(),
                  RedditGallery(),
                  InstagramGallery(),
                  FacebookGallery(),
                  TiktokGallery(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

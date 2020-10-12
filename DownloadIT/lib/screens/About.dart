import 'package:flutter/material.dart';
import 'package:reddit_video_downloader/constants/appConstant.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  Future<void> _lauchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        enableJavaScript: true,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      print('Can\'t Lauch url');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: screenAppBar('About us'),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Image.asset(
                  "assets/images/rvd.png",
                  scale: 2.0,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                alignment: Alignment.center,
                child: Hero(
                  tag: 'tagged',
                  child: Text('Reddit Video Downloader is a free app to download HD Videos with audio, Reddit video downloader helps you to save your favorite video to your gallery.\n if you loved this free video downloader please share it with your friends and rate us on Playstore. ',style:
                    TextStyle( fontFamily: 'WorkSans',fontSize: 15),textAlign: TextAlign.center,),
                ),
              ),
              SizedBox(height: 20,),
              Card(
                child: Column(
                  children: [
                    GestureDetector(child: ListTile(leading: Icon(Icons.share),title: Text('Share the App',style: TextStyle( fontFamily: 'WorkSans'),),),
                      onTap: (){
                        Share.share('Download Stories,Videos,Status and much more in One Click using Reddit Video Downloader App.\n\n Checkout the Link below also share it with your Friends.\n https://play.google.com/store/apps/details?id=com.downloading.social_media');

                      },),
                    GestureDetector(child: ListTile(leading: Icon(Icons.star),title: Text('Rate App App',style: TextStyle( fontFamily: 'WorkSans'),),),
                      onTap: (){
                        _lauchUrl('https://play.google.com/store/apps/details?id=com.downloading.social_media');
                      },),
                    GestureDetector(child: ListTile(leading: Icon(Icons.more),title: Text('More App',style: TextStyle( fontFamily: 'WorkSans'),),),
                      onTap: (){
                        _lauchUrl('https://play.google.com/store/apps/developer?id=HD+Video+downloader+-+Video+to+mp3+converter');
                      },),
                  ],
                ),
              ),

            ],
        ),
      ),
    );
  }
}

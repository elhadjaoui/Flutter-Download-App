import 'dart:ui';

import 'package:backdrop/backdrop.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reddit_video_downloader/WidgetHelper/ContainerLotties.dart';
import 'package:reddit_video_downloader/constants/appTheme.dart';
import 'package:reddit_video_downloader/helper/app_animations.dart';
import 'package:reddit_video_downloader/helper/theme_changer.dart';
import 'package:reddit_video_downloader/screens/About.dart';
import 'package:reddit_video_downloader/screens/facebookDownload/facebookDownloadScreen.dart';
import 'package:reddit_video_downloader/screens/galleryScreen.dart';
import 'package:reddit_video_downloader/screens/galleryScreenReddit.dart';
import 'package:reddit_video_downloader/screens/home/download.dart';
import 'package:reddit_video_downloader/screens/instagramDownload/instagramDownloadScreen.dart';
import 'package:reddit_video_downloader/screens/tiktokDownload/tiktokDownloadScreen.dart';
import 'package:reddit_video_downloader/screens/whatsappDownload/whatsappDownloadScreen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
bool mode = false;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _checkPermission() async
  {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      debugPrint(permissions.toString());
      var status = permissions[PermissionGroup.storage];

      if (status != PermissionStatus.granted) {
        Navigator.pop(context);
        SystemNavigator.pop();
        debugPrint('access denied');

      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermission();
  }
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
    return BackdropScaffold(
appBar:  BackdropAppBar(
  title: Text("DownloadIt"),

),
     // stickyFrontLayer: true,
      animationCurve: Curves.linear,
headerHeight: MediaQuery.of(context).size.height * 0.2,
      backLayer: BackdropNavigationBackLayer(items: [
        SingleChildScrollView(

          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(bottom: 50.0),
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
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                alignment: Alignment.center,
                child: Text(' if you loved this free video downloader please share it with your friends and rate us on Playstore. ',style:
                TextStyle( fontFamily: 'WorkSans',fontSize: 15),textAlign: TextAlign.center,),
              ),
              SizedBox(height: 10,),
              Card(
                child: Column(
                  children: [
                    GestureDetector(child: ListTile(leading: Icon(Icons.share),title: Text('Share the App',style: TextStyle( fontFamily: 'WorkSans'),),),
                      onTap: (){
                        Share.share('Download Stories,Videos,Status and much more in One Click using Reddit Video Downloader App.\n\n Checkout the Link below also share it with your Friends.\n https://play.google.com/store/apps/details?id=com.downloading.social_media');

                      },),
                    GestureDetector(child: ListTile(leading: Icon(Icons.star),title: Text('Rate us',style: TextStyle( fontFamily: 'WorkSans'),),),
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
              SizedBox(height: 10,),

              ListTile(
                title: new Text(
                  "Exit",
                  style: new TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: new Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        )
      ]),
      frontLayerBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
       frontLayer:   Scaffold(
         backgroundColor: Colors.black12.withOpacity(0.1),
           body :  Padding(
             padding:  EdgeInsets.only(top: MediaQuery.of(context).padding.top),
             child: CustomScrollView(
               slivers: <Widget>[
                 SliverPadding(
                   padding: const EdgeInsets.all(26.0),
                   sliver: SliverGrid.count(
                     crossAxisCount: 2,
                     mainAxisSpacing: 10,
                     crossAxisSpacing: 10,
                     children: <Widget>[
                       GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>FacebookDownload()));},
                           child: ContainerLotties(header:'Facebook' ,animationPath: AppAnimations.fb,)),
                       GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>InstagramDownload()));},
                           child: ContainerLotties(header:'Instagram' ,animationPath: AppAnimations.insta,)),
                       GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>WhatsappDownload()));},
                           child: ContainerLotties(header:'Whatsapp' ,animationPath: AppAnimations.whatsapp,)),
                       GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Download()));},
                           child: ContainerLotties(header:'Reddit' ,animationPath: AppAnimations.reddit,)),
                       GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>TiktokDownload()));},
                           child: ContainerLotties(header:'TikTok' ,animationPath: AppAnimations.tiktok,)),
                       GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>GalleryScreen()));},
                           child: ContainerLotties(header:'Go to your Downloads' ,animationPath: AppAnimations.download,)),
                     ],
                   ),
                 ),
               ],
             ),
           )) ,
    );






}
}

class RedditResponse {
  final String videoUrl;

  RedditResponse({this.videoUrl});
}

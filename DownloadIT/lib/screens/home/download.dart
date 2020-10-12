import 'package:connectivity/connectivity.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:reddit_video_downloader/actions/actions.dart';
import 'package:reddit_video_downloader/constants/appConstant.dart';
import 'package:reddit_video_downloader/helper/AdsHelper.dart';
import 'package:reddit_video_downloader/helper/ShowAds.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:reddit_video_downloader/models/app_state.dart';
import 'package:redux_epics/redux_epics.dart';

const String testDevice = 'MobileId';

class Download extends StatefulWidget {
  static const platform = const MethodChannel('app.channel.shared.data');
  TextEditingController urlController = TextEditingController();



  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  ShowAds _showAds = ShowAds(adUnitID: AdsHelper.nativeAds);
  var _fbScaffoldKey = GlobalKey<ScaffoldState>();
  //final _nativeAdmob = NativeAdmob();
//  final _nativeAdController = NativeAdmobController();
//
//  static const _adUnitID = AdsHelper.nativeAds;
//  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    testDevices: testDevice != null ? <String>[testDevice] : null,
//    nonPersonalizedAds: true,
//    keywords: <String>['video', 'download'],
//  );
//  InterstitialAd _interstitialAd;
//  InterstitialAd createInterstitialAd() {
//    return InterstitialAd(
//        adUnitId: AdsHelper.interstitialAds,
//        //Change Interstitial AdUnitId with Admob ID
//        targetingInfo: targetingInfo,
//        listener: (MobileAdEvent event) {
//          print("IntersttialAd $event");
//        });
//  }

  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
   // ShowAds..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void startDownload() {
      StoreProvider.of<AppState>(context).dispatch(
          new StartDownloadAction(widget.urlController.text, context));
      widget.urlController.clear();
    }

    return Scaffold(
      key: _fbScaffoldKey,
      appBar: screenAppBar("Reddit Downloader"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: StoreConnector<AppState, bool>(
                converter: (store) => store.state.download.isDownloading,
                builder: (context, isDownloading) {
                  if (!isDownloading) {
                    return Column(children: <Widget>[
                     SizedBox(height: 60,),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: widget.urlController,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              hintText: 'https://www.reddit.com/...'),
                          onChanged: (value) {
                            //getButton(value);
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MyButton(
                            text: 'PASTE',
                            onPressed: () async {
                              Map<String, dynamic> result = await SystemChannels
                                  .platform
                                  .invokeMethod('Clipboard.getData');
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) => widget.urlController.text =
                                    result['text'].toString(),
                              );
                            },
                          ),
                          MyButton(
                            text: 'Download',
                            onPressed: () async {
                              var connectivityResult =
                                  await Connectivity().checkConnectivity();
                              if (connectivityResult ==
                                  ConnectivityResult.none) {
                                _fbScaffoldKey.currentState.showSnackBar(
                                    mySnackBar(context, 'No Internet'));
                                return;
                              }
                              _showAds.showInerstitial();
                              startDownload();
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          //You Can Set Container Height
                          height: MediaQuery.of(context).size.height*0.3,
                          child: _showAds.showNative(),
                        ),
                      )
                    ]);
                  } else {
                    return Downloading();
                  }
                })),
      ),
    );
  }
}

class Downloading extends StatefulWidget {
  @override
  _DownloadingState createState() => _DownloadingState();
}

class _DownloadingState extends State<Downloading> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
      converter: (Store<AppState> store) => store.state.download.status,
      builder: (context, String status) {
        double percent = 0.0;
        percent = DateTime.now().second / 100;
        print(percent);
        if (status == 'Success') percent = 1.0;

        return Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              new CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                //animation: true,
                percent: status == 'Success' ? 1.0 : percent,
                center: new Text(
                  "${(percent * 100).toStringAsFixed(2)} %",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer: new Text(
                  "In Progress...",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.purple,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: status == 'Success'
                    ? Text(
                        'Done',
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        status,
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

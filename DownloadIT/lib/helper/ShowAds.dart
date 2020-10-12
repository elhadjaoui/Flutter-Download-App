
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:reddit_video_downloader/helper/AdsHelper.dart';

class ShowAds
{
  ShowAds({this.adUnitID});
  static const String testDevice = 'MobileId';
  //static  InterstitialAd _interstitialAd;
  final _nativeAdController = NativeAdmobController();
  final adUnitID;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['video', 'download'],
  );
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: AdsHelper.interstitialAds,
        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }
  showInerstitial()
  {
    createInterstitialAd()
      ..load()
      ..show();
  }

  showNative()
  {
    return NativeAdmob(
      // Your ad unit id
      adUnitID: adUnitID,
      controller: _nativeAdController,
      type: NativeAdmobType.full,
      error: CupertinoActivityIndicator(),
    );
  }
  _showBanner()
  {

  }
}
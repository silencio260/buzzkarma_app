import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:genrevibes/ads/unity_ads.dart';

String placementId = kReleaseMode
    ? "519065109113122" //"519063392446627_519065109113122"
    : "IMG_16_9_APP_INSTALL#519063392446627_519065109113122";

String InterstitialPlacementId = '533771637642469';
// kReleaseMode ? "533771637642469" : "IMG_16_9_APP_INSTALL#519063392446627_533771637642469";

void InitFacebookAds() {
  print('start');
  FacebookAudienceNetwork.init(
//    testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",
      );
}

//Widget showNativeAds() {
//  return FacebookBannerAd(
//    placementId: "519063392446627_519065109113122",
//    //     "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047", //testid
//    bannerSize: BannerSize.STANDARD,
//    listener: (result, value) {
//      print("Banner Ad: $result -->  $value");
//    },
//  );
//}

Widget showNativeAds() {
  //return Container();
  return FacebookNativeAd(
    placementId: placementId,
    adType: NativeAdType.NATIVE_AD,
    width: double.infinity,
    height: 300,
    backgroundColor: Colors.blue,
    titleColor: Colors.white,
    descriptionColor: Colors.white,
    buttonColor: Colors.deepPurple,
    buttonTitleColor: Colors.white,
    buttonBorderColor: Colors.white,
    keepAlive: true, //set true if you do not want adview to refresh on widget rebuild
    keepExpandedWhileLoading:
        true, // set false if you want to collapse the native ad view when the ad is loading
    expandAnimationDuraion:
        10, //300, //in milliseconds. Expands the adview with animation when ad is loaded
    listener: (result, value) {
//      print("Native Ad: $result --> $value");
    },
  );
}

Widget showInterstitialAds() {
//  return Container();
  print('---------------------------=====================------------');
  FacebookInterstitialAd.loadInterstitialAd(
      placementId: InterstitialPlacementId,
      listener: (result, value) {
        print(result);
        print(value);
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd(delay: 5000);
        } else if (result == InterstitialAdResult.ERROR) {
          showUnityInterstitial();
        }
      });
}

Widget DisplayAdInList(int index, int length) {
  int middle = (length ~/ 2).toInt();
  if (index > 1 && index < 3) {
    return showNativeAds();
  } else if (index == middle) {
    return showNativeAds();
  } else
    return Container();
}

Widget ButtomAdDispaly(int index, int length) {
  if (index == length) {
    return showNativeAds();
  } else
    return Container();
}

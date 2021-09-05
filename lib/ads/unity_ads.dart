import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:unity_ads_plugin/unity_ads.dart';
import 'package:genrevibes/services/reward_services.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

void InitUnityAds() {
  UnityAds.init(
    gameId: '4156877',
    testMode: kReleaseMode ? false : true,
    listener: (state, args) => print('Init Listener: $state => $args'),
  );
}

Widget showUnityVideo() {
  UnityAds.showVideoAd(
    placementId: 'Rewarded_Android',
    listener: (state, args) {
      if (state == UnityAdState.complete) {
        print('User watched a video. User should get a reward!');
        Rewards().RewardsApi(kvideoRewards);
        showToast('You Just Earned 250', Colors.green);
      } else if (state == UnityAdState.skipped) {
        print('User cancel video.');
      }
    },
  );
}

Widget showUnityInterstitial() {
  UnityAds.showVideoAd(
    placementId: 'Interstitial_Android_',
    listener: (state, args) {
      if (state == UnityAdState.complete) {
//        print('User watched a video. User should get a reward!');
//        Rewards().RewardsApi(kvideoRewards);
//        showToast('You Just Earned 250', Colors.green);
      } else if (state == UnityAdState.skipped) {
        print('User cancel video.');
      }
    },
  );
}

void showToast(String msg, Color color) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

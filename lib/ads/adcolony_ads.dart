import 'package:flutter/material.dart';
import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:genrevibes/services/reward_services.dart';
import 'package:genrevibes/constants/constants.dart';

final zones = ['vz62e11f6857b245baa7'];

void InitAdcolony() {
  AdColony.init(AdColonyOptions(
    'app068ef053149b4197b6',
    '0',
    zones,
  ));
}

listener(AdColonyAdListener event, int reward) {
  if (event == AdColonyAdListener.onRequestFilled) {
    AdColony.show();
    Rewards().RewardsApi(kvideoRewards);
  }
}

void ShowAdcolonyVideo() {
  print('===========================================');
  AdColony.request(zones[0], listener);
}

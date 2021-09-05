import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';
import 'package:flutter/foundation.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:get/get.dart';
import 'package:genrevibes/controller/user_controller.dart';

// Pollfish initialization options

const String apiKey = 'cea8b8bc-08fb-49f7-9730-5cd6ef533efb';
const bool releaseMode = kReleaseMode;
const int indicatorPadding = 20;
const Position indicatorPosition = Position.middleRight;
const String requestUUID = null;
const userProperties = <String, dynamic>{'gender': '1', 'education': '1'};

class PollFish extends StatefulWidget {
  @override
  _PollFishState createState() => _PollFishState();
}

class _PollFishState extends State<PollFish> {
  final userController = Get.put(UserController());
  bool _rewardMode = false;
  var userId;

  @override
  void initState() {
    super.initState();
    userId = userController.user.value.id;
    initPollfish();
  }

  @override
  void dispose() {
    FlutterPollfish.instance.removeListeners();
    super.dispose();
  }

  Future<void> initPollfish() async {
    String logText = 'Initializing Pollfish...';

//    _showButton = false;
//    _completedSurvey = false;

    FlutterPollfish.instance.init(
      apiKey: apiKey,
      indicatorPosition: indicatorPosition,
      indicatorPadding: indicatorPadding,
      rewardMode: _rewardMode,
      releaseMode: kReleaseMode,
      offerwallMode: true,
      requestUUID: userId,
      userProperties: userProperties,
    );

    FlutterPollfish.instance.setPollfishSurveyReceivedListener(onPollfishSurveyReceived);

    FlutterPollfish.instance.setPollfishSurveyCompletedListener(onPollfishSurveyCompleted);

    FlutterPollfish.instance.setPollfishOpenedListener(onPollfishOpened);

    FlutterPollfish.instance.setPollfishClosedListener(onPollfishClosed);

    FlutterPollfish.instance.setPollfishSurveyNotAvailableListener(onPollfishSurveyNotAvailable);

    FlutterPollfish.instance.setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);

    FlutterPollfish.instance.setPollfishUserNotEligibleListener(onPollfishUserNotEligible);

    setState(() {
//      _logText = logText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }

  void onTabTapped(int index) {
    initPollfish();
  }

  Text findCurrentTitle(int currentIndex) {
    return const Text('Pollfish Offerwall Integration');
  }

  void onPollfishSurveyReceived(SurveyInfo surveyInfo) => setState(() {});

  void onPollfishSurveyCompleted(SurveyInfo surveyInfo) => setState(() {});

  void onPollfishOpened() => setState(() {});

  void onPollfishClosed() => setState(() {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });

  void onPollfishSurveyNotAvailable() => setState(() {});

  void onPollfishUserRejectedSurvey() => setState(() {});

  void onPollfishUserNotEligible() => setState(() {});
}

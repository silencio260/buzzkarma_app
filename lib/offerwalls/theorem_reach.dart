//import 'package:flutter/material.dart';
//import 'package:trsurveys/trsurveys.dart';
//
//class TheoremSurvey extends StatefulWidget {
//  @override
//  _TheoremSurveyState createState() => _TheoremSurveyState();
//}
//
//class _TheoremSurveyState extends State<TheoremSurvey> {
//  @override
//  void initState() {
//    TheoremReach.instance.init(apiToken: 'api_token', userId: 'user_id');
//    TheoremReach.instance.setOnRewardListener(onTheoremReachReward);
//    TheoremReach.instance.setRewardCenterClosed(onTheoremReachRewardCenterClosed);
//    TheoremReach.instance.setRewardCenterOpened(onTheoremReachRewardCenterOpened);
//    TheoremReach.instance.setSurveyAvaiableListener(onTheoremReachSurveyAvailable);
//    super.initState();
//    TheoremReach.instance.show();
//  }
//
//  void onTheoremReachReward(int quantity) {
//    print('TR: $quantity');
//  }
//
//  void onTheoremReachSurveyAvailable(int survey) {
//    print('TR: $survey');
//  }
//
//  void onTheoremReachRewardCenterClosed() {
//    print('TR: closed');
//  }
//
//  void onTheoremReachRewardCenterOpened() {
//    print('TR: opened');
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
////  @override
////  Widget build(BuildContext context) {
////    return MaterialApp(
////      home: Scaffold(
////        appBar: AppBar(
////          title: const Text('Plugin example app'),
////        ),
////        body: Center(
////            child: Column(
////          mainAxisAlignment: MainAxisAlignment.center,
////          children: <Widget>[
////            ElevatedButton(
////              child: Text("Launch TheoremReach"),
////              onPressed: () => TheoremReach.instance.show(),
////            ),
////            ElevatedButton(
////              child: Text("Launch TheoremReach Placement"),
////              onPressed: () => TheoremReach.instance.show(),
////            )
////          ],
////        )),
////      ),
////    );
////  }
//}

import 'package:flutter/material.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_countdown_timer/index.dart';
import 'package:custom_timer/custom_timer.dart';

class DailyRewards extends StatefulWidget {
  int endTime;
  bool canClaim;
  bool alreadyClaimed;

  DailyRewards({this.endTime, this.canClaim});

  @override
  _DailyRewardsState createState() => _DailyRewardsState();
}

class _DailyRewardsState extends State<DailyRewards> {
  bool isFinished = false;
  Box<String> timerBox;
  Color background = Colors.red;
//  CountdownTimerController controller;
  int endTime = 1; //DateTime.now().add(Duration(seconds: 30)).second; //+ 30;
  final CustomTimerController _controller = new CustomTimerController();

  void saveTime() {
    var end = DateTime.now().add(Duration(seconds: 24));
    timerBox.put('end', end.toString());

    setState(() {
      print('[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]');
      endTime = end.second; //DateTime.parse(await timerBox.get('end')).second;
      print(endTime);
    });
  }

  void openBox() async {
    timerBox = await Hive.openBox<String>('dailyRewards');
    var getEnd = DateTime.parse(await timerBox.get('end')).second;
    print(getEnd);
    print(endTime);
    if (getEnd != null) {
//      setState(() {
//        widget.endTime = getEnd;
//        endTime = getEnd;
//        _controller.reset();
//        _controller.start();
//      });
    } else {
      endTime = DateTime.parse(await timerBox.get('end')).second;
    }
  }

  void Initialize() {
    if (widget.canClaim == true) {
      setState(() {
        _controller.reset();
        isFinished = true;
      });
    }
  }

  void onEnd() {
    print('onEnd');
    saveTime();
  }

  @override
  void initState() {
    super.initState();
    openBox();
    Initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: background,
          child: GestureDetector(
            onTap: () {
              if (isFinished == true) {
                setState(() {
                  isFinished = false;
                  background = Colors.red;
                  widget.endTime = Duration(hours: 3)
                      .inSeconds; //DateTime.now().add(Duration(seconds: 4)).second;
                  print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
                  print(widget.endTime);
                  saveTime();
                  _controller.start();
                });
              }
            },
            child: CustomTimer(
              controller: _controller,
              from: Duration(seconds: widget.endTime),
              to: Duration(hours: 0),
              onBuildAction: CustomTimerAction.auto_start,
              onStart: () {
                print('{{{{{{{{{stated}}}}}}}}}}}}');
              },
              onFinish: () => {
                setState(() {
                  isFinished = true;
                  background = Colors.green;
                })
              },
              builder: (CustomTimerRemainingTime remaining) {
                return Text(
                  "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                  style: TextStyle(fontSize: 30.0),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

//*****************IF Implemented should be called in main function
//**************** and pass values down to the widget
//Daily Rewards Timer**************************
//Should eventually move this to its on get provider
//int dailyRewardsTimer;
//bool canClaimDailyReward = false;
//
//void dailyReward() {
//  if (timerBox.get('end') != null) {
//    var savedDate = DateTime.parse(timerBox.get('end'));
//    var getEnd = savedDate.difference(DateTime.now()).inSeconds;
//    if (getEnd >= 0) {
//      dailyRewardsTimer = getEnd;
//    } else {
//      var newDate = DateTime.now();
//      timerBox.put('end', newDate.toString());
//      dailyRewardsTimer = newDate.second;
//      canClaimDailyReward = true;
//    }
//  } else {
//    var newDate = DateTime.now();
//    timerBox.put('end', newDate.toString());
//    dailyRewardsTimer = newDate.second;
//    canClaimDailyReward = true;
//  }
//}

//      DailyRewards(endTime: dailyRewardsTimer, canClaim: canClaimDailyReward),

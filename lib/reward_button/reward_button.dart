import 'dart:async';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'sound.dart';
import 'package:genrevibes/services/reward_services.dart';
import 'package:genrevibes/constants/constants.dart';

int some = 0;

void startTimer() {
  // Start the periodic timer which prints something after 5 seconds and then stop it .
//  const r = Restar
  Timer timer = new Timer.periodic(new Duration(seconds: 0), (time) {
    some = time.tick;
    print('Something');
    print(some);

    if (time.tick > 30) {
      time.cancel();
    }

//    time.cancel();
  });
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter({this.lineColor, this.completeColor, this.completePercent, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width; //width - 4;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 30);
    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

///*************************************************/ Also replace HomeContent with RewardButton
class RewardButton extends StatefulWidget {
  @override
  _RewardButtonState createState() => _RewardButtonState();
}

class _RewardButtonState extends State<RewardButton> with TickerProviderStateMixin {
  final timeout = Stopwatch();
  FToast fToast;
  double percentage;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
//  AnimationController _percentValueAnimationController;
  Animation<double> animation;
  AnimationController controller;
  Tween<double> _rotationTween = Tween(begin: 1, end: 30);

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

//    timerStream = stopWatchStream();
//    timerSubscription = timerStream.listen((int newTick) {
////      setState(() {
////        percentage = newTick.toDouble(); //0.0;
////        print(percentage);
////      });
//    });

    controller = AnimationController(
      duration: new Duration(milliseconds: 30000),
      vsync: this,
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {
          //percentage += animation.value; //lerpDouble(percentage, percentage * 1, controller.value);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
//          controller.repeat();
          controller.stop();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  //*********************************************************************
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 12.0,
        ),
        Text("You earned 50 points"),
        Icon(Icons.check),
      ],
    ),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 0, 0, 0),
      child: new Center(
        child: new Container(
          height: 70.0, //70.0,
          width: 70.0, //70.0,
          child: new CustomPaint(
            foregroundPainter: new MyPainter(
              lineColor: Colors.white54,
              completeColor: Colors.amber,
              completePercent: animation.value, //percentage * animation.value,
              width: 4.0,
            ),
            child: new Padding(
              padding: const EdgeInsets.all(0.0), //const EdgeInsets.all(8.0),
              child: new RaisedButton(
                  color: Colors.redAccent,
                  splashColor: Colors.lightBlueAccent,
                  shape: new CircleBorder(),
                  child: new Icon(
                    Icons.monetization_on,
                    size: 35.0,
                    color: Colors.white,
                  ),
                  elevation: 5.0,
                  onPressed: () {
                    setState(
                      () {
//                      percentage += some; //10.0;

                        if (animation.status == AnimationStatus.completed) {
                          controller.reset();

                          Rewards().RewardsApi(krewards);
                          fToast.showToast(
                            child: toast,
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 3),
                          );
                          PlayRewardSound();
                        }
//                      controller.stop(); controller.forward();
                        // timerSubscription.cancel();
                        //timerStream = null;
                      },
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////
Stream<int> stopWatchStream() {
  StreamController<int> streamController;
  Timer timer;
  Duration timerInterval = Duration(seconds: 1);
  int counter = 0;

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
      counter = 0;
      streamController.close();
    }
  }

  void tick(_) {
    counter++;
    streamController.add(counter);
  }

  void startTimer() {
    timer = Timer.periodic(timerInterval, tick);
  }

  streamController = StreamController<int>(
    onListen: startTimer,
    onCancel: stopTimer,
    onResume: startTimer,
    onPause: stopTimer,
  );

  return streamController.stream;
}

import 'package:flutter/material.dart';
import 'package:genrevibes/services/reward_services.dart';
import 'package:get/get.dart';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:genrevibes/profile/referral_toast.dart';
import 'package:share/share.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:genrevibes/payment/payment.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:genrevibes/payment/payout_history.dart';
import 'package:genrevibes/offers/giveaway.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:genrevibes/ads/adcolony_ads.dart';
import 'package:genrevibes/ads/facebook_ads.dart';
import 'package:genrevibes/ads/unity_ads.dart';
import 'package:connectivity/connectivity.dart';
import 'package:genrevibes/services/internet_access.dart';
//import 'package:genrevibes/main.dart';

class Profile extends StatelessWidget {
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar,
//      backgroundColor: Colors.grey,
      body: GetX<UserController>(builder: (controller) {
        var profile = controller.user.value;
        print(controller.user.value.email);

        if (controller.user.value.email == null) {
          InternetAcces();
          return Container();
        }
        return ListView(
//        shrinkWrap: true,

          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                ),
                child: Container(
                  width: double.infinity,
                  height: 300.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://i.imgur.com/tdi3NGa.png",
                          ),
                          radius: 60.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          profile.name, //"Alice James",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Points Total",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        profile.allTimepoints.toString(), //"5200",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Income Today",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        profile.points.toString(), //"25.9k",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Redeemed",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "1300",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new ListTile(
                              title: new Text(
                                profile.referralCode.toUpperCase(), //'BVCRY905',
                                style: new TextStyle(fontSize: 20.0),
                              ),
                              subtitle: Text(
                                  'your referral code refer a friend and earn 500 points and 5% of all there earnings'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Earn points',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                    new Card(
                      child: new Column(
                        children: <Widget>[
                          EarnMore(profile.referralCode),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        pushNewScreen(
                          context,
                          screen: PayoutHistory(),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        )
                      },
                      child: Card(
                        child: new ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Colors.grey,
                            size: 30.0,
                          ),
                          title: new Text('Check History'),
                        ),
                      ),
                    ),
                    PaymentButton(),
                    SizedBox(
                      height: 20,
                    ),
                    MacBookOffer(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class PaymentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 1,
        child: RaisedButton.icon(
          padding: EdgeInsets.all(9.0),
          onPressed: () async {
//            showInterstitialAds();
            showUnityInterstitial();
            pushNewScreen(
              context,
              screen: Payment(),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          label: Text(
            'Cash Out',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          icon: Icon(
            Icons.monetization_on,
            color: Colors.white,
          ),
          textColor: Colors.white,
          splashColor: Colors.red,
          color: Colors.lightBlue,
        ),
      ),
    );
  }
}

class EarnMore extends StatelessWidget {
  EarnMore(referralCode) {
    this.referralCode = referralCode;

    shareText =
        'I’m earning real cash by simply reading and watching in GenRevibes! Join me using my referral '
        'link: ${kshareUrl}. To earn extra bonus, enter my referral code ${referralCode} after you start using it! '
        'Download from Google Play to win big reward!';
  }

  String referralCode;
  String shareText;
  final userController = Get.put(UserController());
  final InAppReview inAppReview = InAppReview.instance;
  bool playStoreReview = false;

  _shareWithFriends() async {
    await Share.share(shareText);
  }

//  _launchURL() async {
//    const url = kfbUrl;
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      //use alert to show better message latter
//      throw 'Could not launch $url';
//    }
//  }

  void AppReview() async {
    playStoreReview = userController.user.value.playStoreReview;
    if (playStoreReview == false) {
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
        Rewards().RewardsApi(kreviewRewards);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: Icon(
              Icons.thumb_up,
              color: Colors.grey,
              size: 25.0,
            ), //FlutterLogo(),
            title: new Text('Like our facebook page'),
          ),
          GestureDetector(
            onTap: () async => {await _shareWithFriends()},
            child: new ListTile(
              leading: Icon(
                Icons.ios_share,
                color: Colors.grey,
                size: 25.0,
              ), //FlutterLogo(),
              title: new Text('Share with Friends'),
            ),
          ),
          GestureDetector(
            onTap: () => EnerReferralCode(context, userController.token),
            child: new ListTile(
              leading: Icon(
                Icons.people_rounded,
                color: Colors.grey,
                size: 25.0,
              ),
              title: new Text('Enter Referral Code'),
            ),
          ),
          GestureDetector(
            onTap: () => AppReview,
            child: new ListTile(
              leading: Icon(
                Icons.book,
                color: Colors.grey,
                size: 25.0,
              ),
              title: new Text('Give A Review - 5000 points'),
            ),
          ),
          GestureDetector(
            onTap: () => ShowAdcolonyVideo(),
            child: new ListTile(
              leading: Icon(
                Icons.tv,
                color: Colors.grey,
                size: 25.0,
              ),
              title: new Text('Watch Video - 250 points'),
            ),
          ),
        ],
      ),
    );
  }
}

/*
SizedBox(
              height: 100.0,
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              width: 300.00,
              child: RaisedButton(
                onPressed: () {
                  EnerReferralCode(context, controller.token);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                elevation: 0.0,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Colors.redAccent, Colors.pinkAccent]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Contact me",
                      style: TextStyle(
                          color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
            ),

 */

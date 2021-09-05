import 'package:flutter/material.dart';
import 'package:http/http.dart';

bool kshowLoginPage = false;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

const kAppName = 'BuzzKarma';
final MyAppBar = AppBar(
  title: Text(kAppName),
  elevation: 0.0,
//  actions: [
//    IconButton(
//      icon: Icon(
//        Icons.live_tv,
//        color: Colors.white,
//      ),
//      onPressed: () {
//        // do something
//      },
//    ),
//  ],
);

const MaterialColor kColorTheme = Colors.blueGrey;
const ktabBackgroundColor = Colors.blueGrey; //Color(0xff2196f3);
const ktabIndicatorColor = Colors.white70;
const ktabLabelColor = Colors.white;

Map<String, String> kheaders = {"x-auth-token": kTempToken};

const kshareUrl = 'https://buzzbreak.news/';
const kfbUrl = 'https://facebook.com/101123275307099/';
//'http://f05e538d7551.ngrok.io'; http://192.168.43.49:5000
const kserverUrl = 'http://192.168.43.49:5000';
const kserver = '$kserverUrl/api';
final kofferCategory = Uri.parse('${kserver}/offerwall/');
final kcustomoffer = Uri.parse('${kserver}/offers/');
final kgetUser = Uri.parse('${kserver}/user');
final kpostReferralCode = Uri.parse('${kserver}/user/referral_code');

final kpayment = Uri.parse('${kserver}/payout/paypal/');
final kgetPayouts = Uri.parse('${kserver}/user/payouts');

final kuserAuth = Uri.parse('$kserver/user/auth');
final kgetCountry = Uri.parse('$kserver/user/detectproxy');

final krewards = Uri.parse('$kserver/user/reward');
final kdailyRewards = Uri.parse('$kserver/user/reward/daily');
final kvideoRewards = Uri.parse('$kserver/user/reward/video');
final kreviewRewards = Uri.parse('$kserver/user/reward/review');
final knewsUrl = '$kserver/news';

const kTempToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
    ".eyJ1c2VyIjp7ImlkIjoiNWY1YzliNzAyYTlhZDMyOTFjYTBmNzZkIn0sImlhdCI6MTYxMDQ1NTUzMiwiZXhwIjoxNjEwODE1NTMyfQ"
    ".y7gmuZgHdx2b8yHBEqj1chywtleICgnlaDK68KQ9nDA";

import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:genrevibes/services/news.dart';
import 'package:genrevibes/news/home.dart';
import 'package:genrevibes/offers/offer_page.dart';
import 'package:genrevibes/profile/profile.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:get/get.dart';
import 'package:genrevibes/ads/facebook_ads.dart';

import 'package:genrevibes/controller/user_controller.dart';

import 'package:genrevibes/reward_button/reward_button.dart';
import 'package:genrevibes/sign_in/sign_in.dart';
import 'package:genrevibes/services/detect_proxy.dart';
import 'package:genrevibes/reward_button/daily_rewards.dart';
import 'package:genrevibes/ads/unity_ads.dart';
import 'package:genrevibes/ads/adcolony_ads.dart';
import 'package:country_codes/country_codes.dart';
import 'package:genrevibes/services/internet_access.dart';

//to check if my app is in debug mode with kReleaseMode
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
//  print('.......................................2...');
//  print(document.path);
  Hive.init(document.path);
  await Hive.openBox<String>('auth');
  await Hive.openBox<String>('dailyRewards');
  InitFacebookAds();
  InitUnityAds();
  InitAdcolony();
//  detectProxy();
  await CountryCodes.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      //MaterialApp(
//      title: 'Flutter Demo',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        primarySwatch: kColorTheme, //Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.doneAuth = false}) : super(key: key);

  final String title;
  final bool doneAuth;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userController = Get.put(UserController());
  Box<String> authBox;
  Box<String> timerBox;
  bool isExpired = false; //Jwt.isExpired(kTempToken);
  String token = null;
  String userId = null;

  void Initialize() {
    // TODO: $$$$ change this to  !isExpired and implement conditions for isExpired = true
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@222');

    if (!kDebugMode) {
      isExpired = Jwt.isExpired(kTempToken);
      if (isExpired) {
        authBox.put('token', kTempToken);
        token = authBox.get('token');
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        userId = payload['user']['id'];
        authBox.put('id', userId);
        userController.onTest();
        print(token);
        print(userId);
      } else {
        print('======== token expired');
      }
    } else {
      token = authBox.get('token');
      isExpired = token != null ? Jwt.isExpired(token) : isExpired;
      // Or || isExpired
      if (token == null) {
        setState(() {
          print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
          if (widget.doneAuth) {
//            userController.fetchUser();
            kshowLoginPage = false;
          } else {
            kshowLoginPage = true;
          }
        });
      } else {
        setState(() {
//          print('**************************************8');
//          userController.fetchUser();
          kshowLoginPage = false;
        });
      }
    }
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@999');
    print(token);
  }

  @override
  void initState() {
    super.initState();
    authBox = Hive.box<String>('auth');
    timerBox = Hive.box<String>('dailyRewards');

    Initialize();
    InternetAcces();
  }

  int _selectedIndex = 0;
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _buildScreens() {
    return [
      NewsPage(),
      OfferPage(),
      SignIn(),
//      RewardButton(),
      Profile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.list_alt_rounded),
        title: ("Offers"),
        activeColor: Colors.teal,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        title: ("Add"),
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.grey,
        activeContentColor: Colors.blue,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_rounded),
        title: ("Profile"),
        activeColor: Colors.deepOrange,
        inactiveColor: Colors.grey,
      ),
//      PersistentBottomNavBarItem(
//        icon: Icon(Icons.settings),
//        title: ("Settings"),
//        activeColor: Colors.indigo,
//        inactiveColor: Colors.grey,
//      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print(kshowLoginPage);
//    kshowLoginPage = false;
    var localToken = authBox.get('token');
    print('[[[[[[[[[[[]]]]]]]][[[[**********]]]]]]]]');
    print(kshowLoginPage);
    print(localToken);
    if (kshowLoginPage == true) {
      return SignIn();
    } else
      return Scaffold(
//      appBar: AppBar(
//        title: Text('GenRevibes'),
//        elevation: 0.0,
//      ),
        body: PersistentTabView(
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears.
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
        ),
      );
  }
}

//    return MaterialApp(
//        initialRoute: '/',
//        routes: {
////        '': (context) => HomePage(),
//          '/details': (context) => OfferPage(), //LoadingButton(),
//          '/offer_page': (context) => OfferPage(),
//        },
//        home: DefaultTabController(
//          length: 3,
//          child: Scaffold(
//            appBar: AppBar(
//              bottom: TabBar(
//                tabs: [
//                  Tab(text: 'For You'),
//                  Tab(text: 'Entertainment'),
//                  Tab(text: 'Sports'),
////                Tab(icon: Icon(Icons.directions_transit)),
////                Tab(icon: Icon(Icons.directions_bike)),
//                ],
//              ),
//              title: Text('Gen Revibes'),
//            ),
//            body: PersistentTabView(
//              controller: _controller,
//              screens: _buildScreens(),
//              items: _navBarsItems(),
//              confineInSafeArea: true,
//              backgroundColor: Colors.white,
//              handleAndroidBackButtonPress: true,
//              resizeToAvoidBottomInset: true,
//              stateManagement: true,
//              hideNavigationBarWhenKeyboardShows: true,
//              margin: EdgeInsets.all(10.0),
//              popActionScreens: PopActionScreensType.once,
//              bottomScreenMargin: 0.0,
//              decoration: NavBarDecoration(
//                  colorBehindNavBar: Colors.indigo, borderRadius: BorderRadius.circular(20.0)),
//              popAllScreensOnTapOfSelectedTab: true,
//              itemAnimationProperties: ItemAnimationProperties(
//                duration: Duration(milliseconds: 400),
//                curve: Curves.ease,
//              ),
//              screenTransitionAnimation: ScreenTransitionAnimation(
//                animateTabTransition: true,
//                curve: Curves.ease,
//                duration: Duration(milliseconds: 200),
//              ),
//              navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property
//            ),
//          ),
//        )
////          TabBarView(
////            children: [
//////              HomePage(),
//////              OfferPage(),
////              Profile(),
////              HomePage(category: 'entertainment'),
////              HomePage(category: 'sports'),
////            ],
////          ),
//
//        );
//  }
//}

//static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//static const List<Widget> _widgetOptions = <Widget>[
//  Text(
//    'Index 0: Home',
//    style: optionStyle,
//  ),
//  Text(
//    'Index 1: Business',
//    style: optionStyle,
//  ),
//  Text(
//    'Index 2: School',
//    style: optionStyle,
//  ),
//];
//
//void _onItemTapped(int index) {
////    print(i);
//  setState(() {
//    _selectedIndex = index;
//  });
//  switch (index) {
//    case 0:
//      Navigator.pushNamed(context, '/offer_page');
//      break;
//    case 1:
//      Navigator.pushNamed(context, '/details');
//      break;
////      case 2:
////        Navigator.pushNamed(context, 'page3');
////        break;
//    default:
//      Navigator.pushNamed(context, '/offer_page');
//  }
//}
//
//@override
//Widget build(BuildContext context) {
//  return MaterialApp(
//    initialRoute: '/',
//    routes: {
////        '': (context) => HomePage(),
//      '/details': (context) => OfferPage(), //LoadingButton(),
//      '/offer_page': (context) => OfferPage(),
//    },
//    home: DefaultTabController(
//      length: 3,
//      child: Scaffold(
//        appBar: AppBar(
//          bottom: TabBar(
//            tabs: [
//              Tab(text: 'For You'),
//              Tab(text: 'Entertainment'),
//              Tab(text: 'Sports'),
////                Tab(icon: Icon(Icons.directions_transit)),
////                Tab(icon: Icon(Icons.directions_bike)),
//            ],
//          ),
//          title: Text('Gen Revibes'),
//        ),
//        body: TabBarView(
//          children: [
////              HomePage(),
////              OfferPage(),
//            Profile(),
//            HomePage(category: 'entertainment'),
//            HomePage(category: 'sports'),
//          ],
//        ),
//        bottomNavigationBar: BottomNavigationBar(
//          items: const <BottomNavigationBarItem>[
//            BottomNavigationBarItem(
//              icon: Icon(Icons.home),
//              title: Text('Home'),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.business),
//              title: Text('Business'),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.school),
//              title: Text('School'),
//            ),
//          ],
//          currentIndex: _selectedIndex,
//          selectedItemColor: Colors.amber[800],
//          onTap: _onItemTapped,
//        ),
//      ),
//    ),
//  );
//}
//}

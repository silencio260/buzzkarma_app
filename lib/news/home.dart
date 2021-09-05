import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:genrevibes/services/news.dart';
import 'package:genrevibes/news/article_tile.dart';
import 'package:genrevibes/reward_button/reward_button.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:genrevibes/offers/giveaway.dart';
import 'package:genrevibes/ads/facebook_ads.dart';
import 'package:hive/hive.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:genrevibes/services/reward_services.dart';
import 'package:genrevibes/ads/unity_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:genrevibes/news/news_tile.dart';
import 'package:genrevibes/news/skeleton_frame.dart';
import 'package:genrevibes/rss/rss_request.dart';
//import 'package:flutter_html/flutter_html.dart';
//import 'package:news_app_api/helper/data.dart';
//import 'package:news_app_api/models/categorie_model.dart';
//import 'package:news_app_api/views/categorie_news.dart';
//import '../helper/news.dart';

class NewsList extends StatefulWidget {
  final String category;
  final bool googleRss;
  List outNews;

  NewsList({this.category = null, this.googleRss = false});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> with RouteAware {
//  NewsList({this.category});

//  var cat = widget.category;
  final userController = Get.put(UserController());
  bool _loading = true;
  var newslist;
  Box<String> timerBox;
  bool calimDailyRewards = false;

  OverlayEntry entry = OverlayEntry(builder: (BuildContext overlayContext) {
    return RewardButton();
  });

  void getNews() async {
    News news = News();
    await news.getNews(widget.category);
    newslist = news.news;

    setState(() {
      _loading = false;
    });
  }

  void DailyRewards() {
    DateTime today = DateTime.now();

    if (timerBox.get('daily') != null) {
      var savedDate = DateTime.parse(timerBox.get('daily'));
//      print('}}}}}}}}}}}}}}}}}}}}}}}}}{{{{{{{{{{{{{{{{{{{{{{{{{');
//      print(savedDate.hour);
//      print(today.hour);
//      print(today.difference(savedDate).inDays);
      if (today.difference(savedDate).inDays >= 1) {
        //savedDate.isBefore(today) savedDate.day > today.day
        setState(() {
          calimDailyRewards = true;
        });
      }
    } else {
      timerBox.put('daily', today.toString());
      setState(() {
        calimDailyRewards = true;
      });
    }
  }

  void ResetDailyRewardTimer() {
    DateTime now = DateTime.now();
    timerBox.put('daily', now.toString());
  }

  Widget ClaimDaily(BuildContext ncontext) {
    if (calimDailyRewards == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AwesomeDialog(
          context: ncontext,
          headerAnimationLoop: false,
          dialogType: DialogType.NO_HEADER,
          useRootNavigator: true,
//          isDense: true,
          title: 'Claim Your Daily Rewards',
          desc: 'You Earned 2500 points ',
          btnOkOnPress: () {
            debugPrint('OnClcik');
            AwesomeDialog().dismiss();
          },
          btnOkIcon: Icons.check_circle,
        )..show();

        setState(() {
          calimDailyRewards = false;
//          userController.user.value.id;
          ResetDailyRewardTimer();
          Rewards().RewardsApi(kdailyRewards);
        });
      });
    }
    return Container();
  }

  @override
  void initState() {
    _loading = true;
    // TODO: implement initState
    super.initState();
    timerBox = Hive.box<String>('dailyRewards');

    DailyRewards();
    getNews();
  }

  Widget DisplayList(BuildContext context) {
    Widget display = Container(
      child: Column(
        //Stack(alignment: Alignment.bottomCenter,
        children: <Widget>[
          ClaimDaily(context),
          PaypalGiveaway(),

          ///Top ADS Display
//          showNativeAds(),
//          FloatingActionButton(onPressed: () {
//            setState(() {
//              print('--------');
//              calimDailyRewards = true;
//            });
//          }),

          /// News Article
          Container(
            margin: EdgeInsets.only(top: 16),
            child: ListView.builder(
              itemCount: newslist.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    DisplayAdInList(index, newslist.length),
                    Container(
                      height: 100,
                      child: Card(
//                    margin: EdgeInsets.all(5.0),
                        child: ArticleTile.fromArticle(
                          newslist[index],
                          context,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          ///Buttom ADS Display
//          showNativeAds(),
        ],
      ),
    );

    if (widget.googleRss == false) {
      return SingleChildScrollView(child: display);
    } else {
      return ColumnBuilder(
        itemBuilder: (context, index) {
          if (index == newslist.length - 1) {
            return Container(
              padding: EdgeInsets.only(bottom: 15),
              child: showNativeAds(),
            );
          }
          return ArticleTile.fromArticle(
            newslist[index],
            context,
          );
        },
        itemCount: newslist.length,
      ); //display;
    }
  }

  @override
  Widget build(BuildContext context) {
//
    if (widget.googleRss == false) {
      return Scaffold(
        body: SafeArea(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : DisplayList(context),
        ),
      );
    }
    return _loading
        ? Container(
            //Center(
            height: 100,
            width: 100,
            child: Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          )
        : DisplayList(context);
  }
}

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar,
      body: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
            labelColor: ktabLabelColor,
            indicatorColor: ktabIndicatorColor,
            background: Container(
              color: ktabBackgroundColor,
            )),
        tabBarViewProperties: TabBarViewProperties(),
        tabs: [
          Text('General'),
          Text('Sports'),
          Text('Entertain'),
          Text('Politics'),
          Text('Business'),
        ],
        views: [
          NewsList(),
          NewsList(category: 'sport'),
          NewsList(category: 'entertainment'),
          NewsList(category: 'politics'),
          NewsList(category: 'business')
//          Container(color: Colors.red),
//          Container(color: Colors.green),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List output =
        List.generate(this.itemCount, (index) => this.itemBuilder(context, index)).toList();
    print(']]]]]]]]]]]]]]]]]]]]]] ${output.length}');
    return Column(
      children: output,
    );
  }
}

final HomeAppBar = AppBar(
  title: Text(kAppName),
  elevation: 0.0,
  actions: [
    IconButton(
      icon: Icon(
        Icons.ondemand_video,
        color: Colors.white,
      ),
      onPressed: () {
        print('show ads ');
        showUnityVideo();
      },
    ),
  ],
);

//                              return NewsTile(
//                                imgUrl: newslist[index].urlToImage ?? "",
//                                title: newslist[index].title ?? "",
//                                desc: newslist[index].description ?? "",
//                                content: newslist[index].content ?? "",
//                                posturl: newslist[index].articleUrl ?? "",
//                              );

//                      Align(
//                        alignment: Alignment.topCenter,
//                        child: Container(
//                          margin: EdgeInsets.only(top: 20),
//                          alignment: Alignment.center,
//                          height: 70,
//                          width: 300,
//                          child: HomeContent(),
//                        ),
//                      ),

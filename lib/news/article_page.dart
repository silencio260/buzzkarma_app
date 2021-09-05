//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:genrevibes/models/article.dart';
//import '../components/article_tile.dart';
//import '../components/image_placeholder.dart';
import 'package:flutter_villains/villain.dart';
import 'package:genrevibes/services/news.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:share/share.dart';
//import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:genrevibes/news/home.dart';
import 'package:genrevibes/reward_button/reward_button.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:getwidget/getwidget.dart';
import 'package:genrevibes/ads/facebook_ads.dart';
import 'package:jiffy/jiffy.dart';

class ArticlePage extends StatelessWidget {
  ArticlePage(this.article, {this.category}) : assert(article != null);

  final Article article;
  final String category;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar,
      body: Villain(
        villainAnimation: VillainAnimation.fromBottom(
          curve: Curves.fastOutSlowIn,
          relativeOffset: 0.05,
          from: Duration(milliseconds: 200),
          to: Duration(milliseconds: 400),
        ),
        secondaryVillainAnimation: VillainAnimation.fade(),
        animateExit: true,
        child: Stack(
          children: <Widget>[
            _Content(article, category: category ?? null),
//            _BottomSheet(url: article.urlToImage),
//            _Actions(actions: [
//              IconButton(
//                icon: Theme.of(context).platform == TargetPlatform.iOS
//                    ? Icon(Icons.arrow_back_ios)
//                    : Icon(
//                        Icons.arrow_back,
//                        color: Colors.white,
//                      ),
//                onPressed: () => Navigator.pop(context),
//              ),
//            ]),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  _Content(
    this.article, {
    this.category,
  }) : assert(article != null);

  final Article article;
  final String category;

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends State<_Content> with RouteAware {
  OverlayEntry entryButton = OverlayEntry(builder: (BuildContext overlayContext) {
    return RewardButton();
  });

  void _addOverlay(OverlayEntry entry) async {
    await Overlay.of(context).insert(entry);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _addOverlay(entryButton);
  }

  @override
  void didPush() {
//    _addOverlay(entryButton);
  }

  @override
  void dispose() {
    entryButton.remove();
    print('====================leaving now=========');
//    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    Overlay.of(context).insert(entryButton);

    return Stack(
      children: [
        ListView(
          children: <Widget>[
            SizedBox(height: 4.0),
            title(context),
            SizedBox(height: 8.0),
            image(),
            articleCategory(context),
            SizedBox(height: 24.0),
            source(context),
            SizedBox(height: 20.0),
            preview(context),
            SizedBox(height: 20.0),
            Container(
//              color: Colors.black,
              width: 1.0,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: GFButton(
                color: Colors.red,
                fullWidthButton: true,
                size: GFSize.LARGE,
                type: GFButtonType.outline2x,
                onPressed: () => _launchUrl(context),
                text: "View Original",
                shape: GFButtonShape.pills,
                blockButton: false,
              ),
            ),
            SizedBox(height: 20.0),

            ///Top ADS Display
            showNativeAds(),

            Container(
              child: NewsList(googleRss: true),
            ),
          ],
        ),

        ///Buttom ADS Display
//        showNativeAds(),

        Positioned(
          top: 400,
          left: 10,
          child: Container(
            height: 80,
            width: 80,
//            color: Colors.red,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: RewardButton(),
            ),
          ),
        ),
      ],
    );
  }

  Widget test(BuildContext context) {
    for (int i = 0; i < 20; i++) {}
    return ColumnBuilder(
      itemBuilder: (context, index) {
        return Container(
          width: 200,
          height: 100,
          margin: EdgeInsets.all(10),
          color: Colors.black,
        );
      },
      itemCount: 2,
    ); //display;

//    return Container(
//      width: 200,
//      height: 100,
//      color: Colors.redAccent,
//    );
  }

  Widget source(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        widget.article.author != null
            ? 'Source: ${widget.article.author}'
            : 'Error: No source found.',
        style: Theme.of(context).textTheme.body1.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
      ),
    );
  }

  Widget image() {
    if (widget.article.urlToImage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: FadeInImage.memoryNetwork(
//        height: 500,
          image: widget.article.urlToImage,
          placeholder: kTransparentImage,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ImagePlaceholder(
        'No image',
        height: 200.0,
      );
    }
  }

  Widget preview(BuildContext context) {
    if (widget.article.content != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          widget.article.description,
          style: Theme.of(context).textTheme.body1.copyWith(
                fontSize: 16.0, //or 18
                letterSpacing: 1.0,
                fontWeight: FontWeight.w300,
                height: 1.0,
              ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget articleCategory(BuildContext context) {
    List<String> categories = ['us'];
    if (widget.category != null) {
      if (widget.category == 'home') {
        categories.add('front page');
      } else {
        categories.add(widget.category);
      }
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 38.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (BuildContext context, int index) {
          return Text(
            'Published ${Jiffy(widget.article.publshedAt).fromNow()} ',
            style: Theme.of(context).textTheme.overline.copyWith(
                  color: Colors.black54,
                  fontSize: 13.0,
                  height: 2.8,
                ),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return Text(
            '', //categories[index].toUpperCase(),
            style: Theme.of(context).textTheme.overline.copyWith(
                  fontSize: 13.0,
                  height: 2.9,
                ),
          );
        },
      ),
    );
  }

  Widget title(BuildContext context) {
    final String title = widget.article.title.split(" - ")[0];
    print(title);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline.copyWith(
              height: 1.0,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  void _launchUrl(BuildContext context) async {
    try {
      FlutterWebBrowser.openWebPage(
        url: widget.article.articleUrl,
        customTabsOptions: CustomTabsOptions(
          colorScheme: CustomTabsColorScheme.dark,
          toolbarColor: Colors.white12,
          secondaryToolbarColor: Colors.green,
          navigationBarColor: Colors.white12,
          addDefaultShareMenuItem: true,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        ),
        safariVCOptions: SafariViewControllerOptions(
          barCollapsingEnabled: true,
          preferredBarTintColor: Colors.green,
          preferredControlTintColor: Colors.white12,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          modalPresentationCapturesStatusBarAppearance: true,
        ),
      );
//      await launch(
//        widget.article.articleUrl,
//        option: CustomTabsOption(
//          toolbarColor: Theme.of(context).primaryColor,
//          enableDefaultShare: true,
//          enableUrlBarHiding: true,
//          showPageTitle: true,
//          animation: CustomTabsAnimation.slideIn(),
//        ),
//      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class _BottomSheet extends StatelessWidget {
  _BottomSheet({
    @required this.url,
  }) : assert(url != null);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        child: Material(
          color: Theme.of(context).cardColor,
          elevation: 24.0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FlatButton(
                    textColor: Theme.of(context).accentColor,
                    child: Text('Share'),
                    onPressed: () => _share(),
                  ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    colorBrightness: Brightness.dark,
                    child: Text('Full article'),
                    onPressed: () => _launchUrl(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _share() {
    Share.share(url);
  }

  void _launchUrl(BuildContext context) async {
    try {
//      await launch(
//        url,
//        option: CustomTabsOption(
//          toolbarColor: Theme.of(context).primaryColor,
//          enableDefaultShare: true,
//          enableUrlBarHiding: true,
//          showPageTitle: true,
//          animation: CustomTabsAnimation.slideIn(),
//        ),
//      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class _Actions extends StatelessWidget {
  _Actions({
    this.actions,
  })  : assert(actions != null),
        assert(actions.isNotEmpty);

  final List<IconButton> actions;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SafeArea(
        child: Container(
          width: 56.0 * actions.length,
          height: 56.0,
          child: Material(
            color: Theme.of(context).primaryColor,
            elevation: 4.0,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0)),
            ),
            child: ListView.builder(
              itemCount: actions.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return actions[index];
              },
            ),
          ),
        ),
      ),
    );
  }
}

//should be in another file
class ImagePlaceholder extends StatelessWidget {
  ImagePlaceholder(
    this.text, {
    this.width,
    this.height,
  });

  final String text;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).accentColor.withOpacity(0.3),
          ],
        ),
      ),
      child: Text(text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}

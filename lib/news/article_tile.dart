import 'package:flutter/material.dart';
import 'package:genrevibes/models/article.dart';
import 'package:transparent_image/transparent_image.dart';
import './fade_route.dart';
import './article_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ArticleTile extends StatelessWidget {
  ArticleTile({
    this.article,
    this.title,
    this.thumbnail,
    this.published,
    this.expanded,
  });

  ArticleTile.fromArticle(Article article, BuildContext context, {bool expanded: false})
      : article = article,
        title = Text(
          cleanTitle(article.title),
//          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,

          style: Theme.of(context).textTheme.body1.copyWith(
                fontSize: 16.0, //15.0
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
              ),
        ),
        thumbnail = article.urlToImage != null
            ? ImagePlaceholder('No image.')
//            FadeInImage.memoryNetwork(
//                image: article.urlToImage,
//                placeholder: kTransparentImage,
//                fit: BoxFit.cover,
//              )
            : null, //ImagePlaceholder('No image.'),
        published = SizedBox.shrink(),
//        published = Text(
//          _timestamp(article.publshedAt),
//          style: Theme.of(context).textTheme.subtitle.copyWith(
//                color: Colors.black54,
//                fontSize: 14.0,
//              ),
//        ),
        expanded = expanded;

  final Article article;
  final Widget title;
  final Widget thumbnail;
  final Widget published;
  final bool expanded;

  Widget build(BuildContext context) {
    Route currentRoute;
    Navigator.popUntil(context, (route) {
      currentRoute = route;
      return true;
    });
    final String category =
        currentRoute.settings.name != '/search' && currentRoute.settings.name != null
            ? currentRoute.settings.name.replaceAll('/', '')
            : null;
    return InkWell(
      onTap: () => pushNewScreen(
        context,
        screen: ArticlePage(article, category: category),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ), //Navigator.push(context, FadeRoute(ArticlePage(article, category: category))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: expanded ? _expandedTile() : _compactTile(),
      ),
    );
  }

  Widget _expandedTile() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Thumbnail.
        Flexible(
          flex: 3,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AspectRatio(aspectRatio: 4.0 / 3.0, child: Container(color: Colors.black26)),
              AspectRatio(aspectRatio: 4.0 / 3.0, child: thumbnail),
            ],
          ),
        ),

        // Title and timestamp.
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: published),
              title,
            ],
          ),
        ),
      ],
    );
  }

  Widget _compactTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(bottom: 6.0), child: published),
              title,
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0), //20.0
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AspectRatio(aspectRatio: 1.0 / 1.0, child: Container(color: Colors.black26)),
                AspectRatio(aspectRatio: 1.0 / 1.0, child: thumbnail),
              ],
            ),
          ),
        )
      ],
    );
  }

  static String cleanTitle(String originalTitle) {
    List<String> split = originalTitle.split(' - ');
    String text = split[0];
    int index = 70; //77
    text = text.length < index ? text : text.replaceRange(index, text.length, '...');

    return text;
  }

  /// Returns the article's published date in a readable
  /// form.
  static String _timestamp(DateTime oldDate) {
    String timestamp;
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(oldDate);
    if (difference.inSeconds < 60) {
      timestamp = 'Now';
    } else if (difference.inMinutes < 60) {
      timestamp = '${difference.inMinutes}M';
    } else if (difference.inHours < 24) {
      timestamp = '${difference.inHours}H';
    } else if (difference.inDays < 30) {
      timestamp = '${difference.inDays}D';
    }
    return timestamp;
  }
}

import 'package:http/http.dart' as http;
//import 'package:webfeed/webfeed.dart';
//import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:genrevibes/models/article.dart';

class GoogleNews {
  List<Article> news = [];

  void Request_news() async {
    var client = http.Client();

    // RSS feed
//    var response = await client
//        .get('https://news.google.com/rss/search?q=sports'); //'https://news.google.com/rss');
//    var channel = RssFeed.parse(response.body);
//
//    for (int i = 0; i < 5; i++) {
//      //channel.items.length
//      var data = await extract(channel.items[i].link);
////    print(data.title);
//      Article article = Article(
//        title: data.title,
//        author: channel.items[i].author,
//        description: channel.items[i].description,
//        urlToImage: data.image,
//        publshedAt: channel.items[i].pubDate,
//        content: '', //element["content"],
//        articleUrl: channel.items[i].link,
//      );
//      news.add(article);
//    }
//
//    print('|||||||||||||||||||||||||||||');
//    news.forEach((element) {
//      print(element.title);
//      print(element.articleUrl);
//      print(element.description);
//      print(element.urlToImage);
//      print('\\\\\\\\\\\\\\\]');
//    });
//
//    client.close();
  }
}

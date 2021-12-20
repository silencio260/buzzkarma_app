import 'package:flutter/cupertino.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:genrevibes/models/article.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:country_codes/country_codes.dart';
import 'dart:io';

const apiKey = '11cd66d3a6994c108e7fb7d92cee5e12';

class News {
  List<Article> news = [];
  String url;
  final userController = Get.put(UserController());

//  final CountryDetails details = CountryCodes.detailsForLocale();
//  details.alpha2Code;

  Future<void> getNews(String category) async {
    var response;
    var isoCode = userController.user.value.countyCode;

    if (kReleaseMode) {
      url =
          "https://newsapi.org/v2/top-headlines?country=ng&sortBy=publishedAt&language=en&apiKey=${apiKey}";

      if (category != null) {
        url =
            "https://newsapi.org/v2/everything?q=${category}&sortBy=publishedAt&language=en&apiKey=${apiKey}";
      }

      response = await http.get(Uri.parse(url));
    } else {
      url = knewsUrl;
//      print('00000000000000000000000000000');
//      print(userController.user.value.email);
//      print(userController.user.value.countyCode);
      if (category == null) {
        category = 'home';
      }
      if (isoCode == null) {
        isoCode = 'us';
      }
      Map<String, String> headers = {"country": isoCode, "category": category};

      response = await http.get(Uri.parse(url), headers: headers);
    }

    var jsonData = jsonDecode(response.body);
    print('=====+++++++==========+++++++++==========');
    print(jsonData['articles'][0]);

//    if (jsonData['status'] == "ok") {
    jsonData["articles"].forEach((element) {
      if (element['title'] != null) {
        String description = element['body']; //element['description'];;
        String image = element['urlToImage'];
        String author; //= element['source']['name'] ?? null;

        if (element['body'] == null || element['description'].length > element['body'].length) {
          description = element['description'];
        }

        if (element['urlToImage'] == null) {
          image = element['body'] != null ? element['image']['url'] : '';
        }

        if (element['source'] == null) {
          String temp = element['provider']['name'];
          author = temp != null ? temp.toUpperCase() : '';
        } else {
          author = element['source']['name'];
        }

        Article article = Article(
          title: element['title'],
          author:
              author, //element['author'] == null ? element['provider']['name'] : element['author'],
          description: description,
          urlToImage: image, //(element['urlToImage'] ?? element['image']['url']) ?? '',
          publshedAt: element['publishedAt'] != null
              ? DateTime.parse(element['publishedAt'])
              : DateTime.parse(element['datePublished']),
          content: description, //element["content"],
          articleUrl: element["url"],
        );

        if (image != '') {
          news.add(article);
        }
      }
    });
//    }
    print('---------------------==');
    print(news[0].title);
  }
}

/******Legacy code from newsapi.org************

    //    if (jsonData['status'] == "ok") {
    jsonData["articles"].forEach((element) {
    if (element['urlToImage'] != null && element['description'] != null) {
    Article article = Article(
    title: element['title'],
    author: element['author'],
    description: element['description'],
    urlToImage: element['urlToImage'],
    publshedAt: DateTime.parse(element['publishedAt']),
    content: element["content"],
    articleUrl: element["url"],
    );
    news.add(article);
    }
    });
    //}

 ********************/

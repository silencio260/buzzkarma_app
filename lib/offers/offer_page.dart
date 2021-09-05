import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:genrevibes/offers/offer_wall.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar,
      body: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
            labelColor: ktabLabelColor,
            indicatorColor: ktabIndicatorColor,
            background: Container(
              color: ktabBackgroundColor,
            )),
        tabBarViewProperties: TabBarViewProperties(),
        tabs: [
          Text('Highest Paying'),
          Text('App Offers'),
          Text('Surveys '),
//          Text('Top Picks'),
//          Text('OTHER'),
        ],
        views: [
          OfferWall(category: 'Highest'),
          OfferWall(category: 'App'),
          OfferWall(category: 'Survey'),
//          OfferWall(category: 'Sites'),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}

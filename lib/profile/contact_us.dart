import 'package:flutter/material.dart';
import 'package:genrevibes/constants/constants.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: Text(
                'BuzzKarma is a lifestyle and entertainment app that aims to keep '
                'users engaged with more news by providing a fun and interactive way '
                'to consume mordern media. ',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Contact Us via Email at: \nbuzzkarma11@gmail.com '
                '\nAnd Phone Number at:  \n+234701326928',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

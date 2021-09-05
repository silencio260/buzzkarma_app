import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';

TextStyle textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20);

Widget PaypalGiveaway() {
  return GiveAwayCard(
      image: 'images/paypalGiveaway.jpg',
      title: 'Win \$1000 PayPal GiftCard',
      subtitle: 'Get a chance to win \$1000 worth of paypal giftcard',
      url: 'https://grabclix.com/paypalgiveaway');
}

Widget DogeCoinGiveaway() {
  return GiveAwayCard(
      image: 'images/dogecoin.jpg',
      title: 'Win 10,000 Doge Coins.',
      subtitle: 'Get a chance to win 10,000 Doge Coins.',
      url: 'https://clintonfolders.com/dogecoingiveaway');
}

Widget TronGiveaway() {
  return GiveAwayCard(
      image: 'images/tron.png',
      title: 'Win 50,000 TRX',
      subtitle: 'Get a chance to win 50,000 TRX',
      url: 'https://discofoxfiles.com/trx');
}

Widget AlienWareOffer() {
  return GiveAwayCard(
      image: 'images/alienware.jpg',
      title: 'Win a free Gaming Laptop',
      subtitle: 'Stand a chance to win a free 2020 Alienware laptop',
      url: 'https://xmlgrab.com/alienwaregiveaway');
}

Widget MacBookOffer() {
  return GiveAwayCard(
      image: 'images/macbook.jpg',
      title: 'Free M1 MacBook Pro',
      subtitle: 'Stand a chance to win a free 2021 M1 MacBook Pro with 20+ hours battery life',
      url: 'https://gogetfiles.co/m1macbookgiveaway');
}

Widget GiveAwayCard({String image, String title, String subtitle, String url}) {
  launchURL() async => await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  return GestureDetector(
    onTap: () => launchURL(),
    child: Card(
//    margin: EdgeInsets.only(top: 5),
      child: GFListTile(
//    padding: EdgeInsets.all(0.0),
        avatar: GFAvatar(
          backgroundImage: AssetImage(image),
          size: 50, //GFSize.LARGE,
          shape: GFAvatarShape.square,
        ),

        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
//    icon: Q,
//      icon: Icon(Icons.favorite)
      ),
    ),
  );
}

//Widget PaypalGiveaway() {
//  return GFCard(
////    color: Colors.white,
//    boxFit: BoxFit.cover,
//    imageOverlay: AssetImage('images/paypalGiveaway.png'),
//    title: GFListTile(
//      title: Text(
//        'Card Title',
//        style: textStyle,
//      ),
//    ),
//    content: Text(
//      "GFCards has three types of cards i.e, basic, with avataras and with overlay image",
//      style: textStyle,
//    ),
//    buttonBar: GFButtonBar(
////      alignment: WrapAlignment.center,
//      children: <Widget>[
//        GFButton(
//          onPressed: () {},
//          text: 'View',
//        )
//      ],
//    ),
//  );
//}

import 'package:flutter/material.dart';
import 'package:genrevibes/models/offer.dart';
import 'package:genrevibes/services/offer_services.dart';
import 'package:genrevibes/offers/giveaway.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:get/get.dart';

///
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:genrevibes/offerwalls/pollfish.dart';
import 'package:genrevibes/offerwalls/tapjoy.dart';

class OfferWall extends StatefulWidget {
  final String category;

  OfferWall({this.category = 'App'});

  @override
  _OfferWallState createState() => _OfferWallState();
}

class _OfferWallState extends State<OfferWall> {
  var userController = Get.put(UserController());
  bool _loading = true;
  var offerList;
  String userId;

  void getOffers() async {
    OfferApi offer = OfferApi();
    await offer.getOffers(widget.category);
    offerList = offer.offers;
    userId = userController.user.value.id;
    setState(() {
      _loading = false;
    });
  }

  Widget TopOffer() {
    if (widget.category == 'App') {
      return DogeCoinGiveaway();
    } else if (widget.category == 'Highest') {
      return AlienWareOffer();
    } else {
      return Container();
    }
  }

  Widget AddedOffers() {
    if (widget.category == 'App') {
      return InkWell(
        onTap: () {
          TapjoyLite tap = TapjoyLite();
          tap.Execute();
//                        pushNewScreen(
//                          context,
//                          screen: TapJoy(),
//                          withNavBar: false, // OPTIONAL VALUE. True by default.
//                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
//                        )
        },
        child: OfferCard(
          theIcon: Icons.mic, //offerList[index].urlToImage,
          theText: 'TapJoy',
          subtitle: 'earn free points for playing games',
          isNetworkImg: false,
          localImg: AssetImage('images/tapjoy.png'),
          //image: offerList[1].urlToImage,
        ),
      );
    } else if (widget.category == 'Survey') {
      return InkWell(
        onTap: () => {
          pushNewScreen(
            context,
            screen: PollFish(),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          )
        },
        child: OfferCard(
          theIcon: Icons.mic, //offerList[index].urlToImage,
          theText: 'PollFish',
          subtitle: 'earn free points for survey',
          isNetworkImg: false,
          localImg: AssetImage('images/pollfish.jpg'),
          //image: offerList[0].urlToImage,
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    _loading = true;
    // TODO: implement initState
    super.initState();

    getOffers();
//    print("----D------>" + offerList);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
//                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    TopOffer(),

                    AddedOffers(),

                    /// News Article
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: ListView.builder(
                        itemCount: offerList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => _launchUrl(context, offerList[index].offerUrl, userId),
                            child: OfferCard(
                              theIcon: Icons.mic, //offerList[index].urlToImage,
                              theText: offerList[index].title,
                              subtitle: offerList[index].description,
                              image: offerList[index].urlToImage,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class OfferCard extends StatelessWidget {
  // default constructor
  OfferCard({
    this.theIcon,
    this.theText,
    this.subtitle,
    this.image,
    this.localImg,
    this.isNetworkImg = true,
  });

  // init variables
  final IconData theIcon;
  final String theText;
  final String subtitle;
  final String image;
  final bool isNetworkImg;
  final ImageProvider localImg;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(1.0),
      child: new Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: Image(
                  image: isNetworkImg ? NetworkImage(image) : localImg,
                  width: 70,
                  height: 201,
                ),
                //new Icon(theIcon, size: 40.0, color: Colors.grey),
                title: new Text(
                  theText,
                  style: new TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(subtitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOffers extends StatelessWidget {
  // default constructor
  CustomOffers({this.theIcon, this.theText, this.subtitle});

  // init variables
  final IconData theIcon;
  final String theText;
  final String subtitle;
  var userId = Get.put(UserController()).user.value.id;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(1.0),
      child: new Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
//                onTap: () =>,
                child: new ListTile(
                  leading: new Icon(theIcon, size: 40.0, color: Colors.grey),
                  title: new Text(
                    theText,
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Text(subtitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _launchUrl(BuildContext context, String offerUrl, String userId) async {
  try {
    FlutterWebBrowser.openWebPage(
      url: offerUrl, //+ userId, *** Already implemented on another page
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: Colors.deepPurple,
        secondaryToolbarColor: Colors.green,
        navigationBarColor: Colors.amber,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.green,
        preferredControlTintColor: Colors.amber,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      children: <Widget>[
//        new OfferCard(
//          theIcon: Icons.headset,
//          theText: "Headset",
//          subtitle: 'Music by Julie Gable. Lyrics by Sidney Stein.',
//        ),
//        new OfferCard(
//          theIcon: Icons.mic,
//          theText: "Mic",
//          subtitle: 'Music by Julie Gable. Lyrics by Sidney Stein.',
//        ),
//        new OfferCard(
//          theIcon: Icons.speaker,
//          theText: "Speaker",
//          subtitle: 'Music by Julie Gable. Lyrics by Sidney Stein.',
//        ),
//      ],
//    );

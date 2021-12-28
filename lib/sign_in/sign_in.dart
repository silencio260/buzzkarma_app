import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:genrevibes/main.dart';
import 'package:genrevibes/services/detect_proxy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'email_auth/email_login.dart';

/////////////
import 'package:genrevibes/offerwalls/tapjoy.dart';
import 'package:genrevibes/offerwalls/pollfish.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
//  final userController = Get.put(UserController());

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
//      'https://www.googleapis.com/auth/contacts.readonly', //auth/drive
    ],
  );

  bool isProxy = false;

  int retryCounter = 0;

  Future<http.Response> AuthenticateUser({
    String name,
    String email,
    String image,
//    String authMethod,
    String country,
    String id,
    String authProvider,
    String proxy,
    String ioscode,
  }) {
    print('===============inside auth method');
    print(proxy);

    return http.post(
      kuserAuth,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': email,
        'image': image,
        'authProivderId': id,
        'password': id,
        'authMethod': authProvider,
        'country': country,
        'countryCode': ioscode,
        'flagged': isProxy,
      }),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      isProxy = false;
      var userData = await detectProxy();
      if (userData['proxy'] == 'yes' && retryCounter >= 5) {
        setState(() {
          isProxy = true;
          retryCounter += 1;
        });
        return;
      }

      var user = await _googleSignIn.signIn();
      print(user);
      var token = await AuthenticateUser(
        name: user.displayName,
        email: user.email,
        id: user.id,
        image: user.photoUrl,
        authProvider: 'google',
        proxy: userData['proxy'],
        country: userData['country'],
        ioscode: userData['ioscode'],
      );
      var decoded = jsonDecode(token.body);
//      token = token['token'];
      print(decoded['token']);

      storeAuthToken(decoded['token']);
      print('}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');

      pushNewScreen(
        context,
        screen: MyHomePage(doneAuth: true),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } catch (error) {
      print('}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');
      print(error);
    }
  }

  void storeAuthToken(String token) {
    bool isExpired = Jwt.isExpired(token);
    Box<String> authBox;
    String userId;
    authBox = Hive.box<String>('auth');
    var user = Get.put(UserController());

    authBox.put('token', token);
    token = authBox.get('token');
    print(Jwt.parseJwt(token));
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    print(payload['user']['id']);
    userId = payload['user']['id'];
    authBox.put('id', userId);
    var fake_id = token = authBox.get('id');
    print(fake_id);
    user.onTest();
    print(token);
    print(userId);
    print('}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');

    setState(() {
      kshowLoginPage = false;
      print(kshowLoginPage);
    });
  }

  void handleFacebook(Map userData, String _proxy) async {
    var name = userData['name'];
    var id = userData['id'];
    var email = userData['email'];
    var image = userData['picture']['data']['url'];
    print(name);
    print(email);
    print(id);
    print(image);

    var response = await AuthenticateUser(
      name: name,
      email: email,
      id: id,
      image: image,
      authProvider: 'facebook',
      proxy: _proxy,
      country: userData['country'],
      ioscode: userData['ioscode'],
    );
    var data = jsonDecode(response.body);

    String token = data['token'];

    storeAuthToken(token);
  }

  Future<void> _facebookAuth(BuildContext context) async {
    try {
      isProxy = false;
      var userData = await detectProxy();
      if (userData['proxy'] == 'yes' && retryCounter >= 5) {
        setState(() {
          isProxy = true;
          retryCounter += 1;
        });
        return;
      }

      final AccessToken accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken != null) {
        print('ALREADY LOGGED IN');
        final userData = await FacebookAuth.instance.getUserData();

        handleFacebook(userData, userData['proxy']);
      } else {
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: [
            'public_profile',
            'email',
          ],
          loginBehavior: LoginBehavior.webOnly,
        ); // by default we request the email and the public profile
        if (result.status == LoginStatus.success) {
          // you are logged
          final AccessToken accessToken = result.accessToken;
          final userData = await FacebookAuth.instance.getUserData();

          handleFacebook(userData, userData['proxy']);
        }
      }

      print('00000000000000000000000000000000000000000');
      print('facebook navigation');
      pushNewScreen(
        context,
        screen: MyHomePage(doneAuth: true),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
      print('00000000000000000000000000000000000000000');
    } catch (error) {
      print('}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');
      print(error);
    }
  }

  Widget showToast() {
    print('00000000000000000000000000000');
    print(isProxy);
    if (isProxy == true) {
      print('will show toast here');
      Fluttertoast.showToast(
        msg: 'Please Turn off Your Vpn',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return Container();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    if
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showToast(),
              SignInButton(
//                shape: ShapeBorder,
//                btnColor: Colors.white,
//                btnTextColor: Colors.black,
                buttonType: ButtonType.facebook,
                onPressed: () => _facebookAuth(context),
              ),
              SignInButton(
                buttonType: ButtonType.google,
                onPressed: () => _handleGoogleSignIn(context),
              ),
              SignInButton(
                btnColor: Colors.grey,
                buttonType: ButtonType.mail,
                onPressed: () => pushNewScreen(
                  context,
                  screen: LoginPage(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

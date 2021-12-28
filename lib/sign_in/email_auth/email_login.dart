import 'package:flutter/material.dart';
import 'FormValidator.dart';
import 'LoginRequestData.dart';
import 'package:genrevibes/services/detect_proxy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:genrevibes/sign_in/sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:get/get.dart';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:genrevibes/main.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  LoginRequestData _loginData = LoginRequestData();
  bool _obscureText = true;

  ///*************************
  bool isProxy = false;

  int retryCounter = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(20.0),
            child: Center(
              child: new Form(
                key: _key,
                autovalidate: _validate,
                child: _getFormUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFormUI() {
    return new Column(
      children: <Widget>[
        showToast(),
        Icon(
          Icons.person,
          color: Colors.lightBlue,
          size: 100.0,
        ),
        new SizedBox(height: 50.0),
        new TextFormField(
          keyboardType: TextInputType.name,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Username',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: FormValidator().validateName,
          onSaved: (String value) {
            _loginData.name = value;
          },
        ),
        new SizedBox(height: 20.0),
        new TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: FormValidator().validateEmail,
          onSaved: (String value) {
            _loginData.email = value;
          },
        ),
        new SizedBox(height: 20.0),
        new TextFormField(
            autofocus: false,
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel: _obscureText ? 'show password' : 'hide password',
                ),
              ),
            ),
            validator: FormValidator().validatePassword,
            onSaved: (String value) {
              _loginData.password = value;
            }),
        new SizedBox(height: 15.0),
        new Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: _sendToServer,
            padding: EdgeInsets.all(12),
            color: Colors.lightBlueAccent,
            child: Text('Sign up / Log In', style: TextStyle(color: Colors.white)),
          ),
        ),
        /*
        new FlatButton(
          child: Text(
            'Forgot password?',
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: _showForgotPasswordDialog,
        ),
        new FlatButton(
          onPressed: _sendToRegisterPage,
          child: Text('Not a member? Sign up now', style: TextStyle(color: Colors.black54)),
        ),
    */
      ],
    );
  }

  Future<void> _sendToServer() async {
    if (_key.currentState.validate()) {
      /// No any error in validation
      _key.currentState.save();
      print("Name ${_loginData.name}");
      print("Email ${_loginData.email}");
      print("Password ${_loginData.password}");
      //**************************************

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

        var token = await AuthenticateUser(
          name: _loginData.name,
          email: _loginData.email,
          //password: _loginData.password,
          id: _loginData.password,
          image: "https://i.imgur.com/tdi3NGa.png",
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
    } else {
      ///validation error
      setState(() {
        _validate = true;
      });
    }
  }

  ///***************************************************
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
      //Uri.parse('http://192.168.43.49:5000/api/user/auth'),
      kuserAuth,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Charset': 'utf-8',
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

  /*
  _sendToRegisterPage() {
    ///Go to register page
  }

  Future<Null> _showForgotPasswordDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: const Text('Please enter your eEmail'),
            contentPadding: EdgeInsets.all(5.0),
            content: new TextField(
              decoration: new InputDecoration(hintText: "Email"),
              onChanged: (String value) {
                _loginData.email = value;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok"),
                onPressed: () async {
                  _loginData.email = "";
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

   */
}

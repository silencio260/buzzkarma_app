import 'package:flutter/material.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

EnerReferralCode(context, token) {
  var referralController = TextEditingController();
  Map<String, String> headers;

  Future<dynamic> saveReferral() async {
    var body = jsonEncode(<String, String>{
      "referralCode": referralController.text.trim().toLowerCase(),
    });

    print('=============================');
    print(body);
    print(referralController.text);

    headers = {'x-auth-token': token, 'Content-Type': 'application/json; charset=UTF-8'};
    await http.post(kpostReferralCode, headers: headers, body: body);
    Navigator.of(context, rootNavigator: true).pop();
  }

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter your friend\'s refferal code and earn 2000 points',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal),
          ),
          content: TextField(
            controller: referralController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(hintText: "Enter here..."),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Later'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Submit'),
              onPressed: () {
                saveReferral();
              },
            )
          ],
        );
      });
}

/*Alert(
      context: context,
      title: "LOGIN",
      content: Column(
        children: <Widget>[
          TextField(
            controller: referralController,
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'Username',
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () => {saveReferral()},
          child: Text(
            "LOGIN",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();

*/

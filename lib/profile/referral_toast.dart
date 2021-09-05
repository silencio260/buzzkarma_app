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
      "referralCode": referralController.text.trim(),
    });

    print('=============================');
    print(body);
    print(referralController.text);

    headers = {'x-auth-token': token, 'Content-Type': 'application/json; charset=UTF-8'};
    await http.post(kpostReferralCode, headers: headers, body: body);
    Navigator.of(context, rootNavigator: true).pop();
  }

  Alert(
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
}

/*
 Alert(
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

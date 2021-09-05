import 'package:flutter/material.dart';
import 'package:genrevibes/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:hive/hive.dart';

final userController = Get.put(UserController());

class Rewards {
  Box<String> tokenBox = Hive.box<String>('auth');
//  var UserId = tokenBox.get('token');

  dynamic RewardsApi(Uri url) async {
    var token = tokenBox.get('token');
    var userId = tokenBox.get('token');
    Map<String, String> headers = {"x-auth-token": token};
    var response = await http.get(url, headers: headers);
    var resJson = await jsonDecode(response.body);

    return userController.parseUserJson(resJson);
  }
}

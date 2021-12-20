import 'package:genrevibes/constants/constants.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:genrevibes/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  var user = User().obs;
  var id;
  var token;

  @override
  void onInit() {
    super.onInit();
    getFromHive();
//    defaultUser();
    fetchUser();
  }

  void onTest() {
//    print('--------------vvvvvvvvvvv');
    getFromHive();
    fetchUser();
  }

  String getFromHive() {
    var authBox = Hive.box<String>('auth');
    String UserId = authBox.get('id');
    id = UserId;
    token = authBox.get('token');
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555');
    print(UserId);
    kheaders["x-auth-token"] = token;
    return id;
  }

  void fetchUser() async {
    print('--------------vv=========vvvv');

    Map<String, String> headers = {"x-auth-token": token};
    var response = await http.get(kgetUser, headers: headers);
    var resJson = await jsonDecode(response.body);
    print('---------++++++++++_--------------');
    parseUserJson(resJson);
  }

//  Future<dynamic> saveReferral(String referralCode) async {
//    Map<String, String> headers;
//    headers = {"referralCode": referralCode};
//    await http.post(kpostReferralCode, headers: headers);
//  }

  void parseUserJson(dynamic userJson) {
    print('===============in parser');
    var userObj = userJson['user'];
    var email = userObj['email'];
    var name = userObj['name'];
    var points = userObj['points'];
    var referralCode = userObj['referralCode'];
    var allTimePoints = userObj['allTimePoints'];
    var activityHistory = userObj['activityHistory'];
    var playStoreReview = userObj['playStoreReview'];
    var country = userObj['country'];
    var referrals = userObj['referrals'];
    var countyCode = userObj['countyCode'];

    print(userObj);
    print('middle of parser');
    user.value = User(
      email: email,
      name: name,
      id: id,
      points: points,
      country: country,
      countyCode: countyCode,
      referralCode: referralCode,
      activityHistory: activityHistory,
      allTimepoints: allTimePoints,
      referrals: referrals,
      playStoreReview: playStoreReview,
    );
    print('===============out of parser');
    print(referrals);
    print(user.value.email);
    update();
  }

  void defaultUser() {
    user.value = User(
      email: 'Something@gmail.com',
      name: 'Silencio ',
      id: id,
      points: 2000,
      referralCode: 'SVRC134',
      activityHistory: [],
      allTimepoints: 5000,
    );
  }
}

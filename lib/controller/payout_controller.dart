import 'package:genrevibes/constants/constants.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:genrevibes/models/payout_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class PayoutController extends GetxController {
  var payouts = List<Payout>().obs;
//  var id;
  var token;
  Map<String, String> headers = {"x-auth-token": ''};

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
    token = authBox.get('token');
    headers["x-auth-token"] = token;
    return token;
  }

  void fetchUser() async {
    var response = await http.get(kgetPayouts, headers: headers);
    var resJson = await jsonDecode(response.body);
    print('---------++++++++++_--------------');
    parsePayoutsJson(resJson);
  }

//  Future<dynamic> saveReferral(String referralCode) async {
//    Map<String, String> headers;
//    headers = {"referralCode": referralCode};
//    await http.post(kpostReferralCode, headers: headers);
//  }

  void parsePayoutsJson(dynamic payoutsJson) {
    print('===============in parser');
    List parseArr = List<Payout>();
    Payout pay;
    var payoutsObj = payoutsJson['payouts'];
    print(payoutsObj);
    for (Map payout in payoutsObj) {
      print('-------------------- checking i');
      print(DateTime.now());
      print(DateTime.parse(payout['date']));
      var amount = payout['usd'];
      var points = payout['amount'];
      var status = payout['status'];
      var id = payout['_id'];
      var approved = payout['approved'];
      var rejected = payout['rejected'];
      var date = DateTime.parse(payout['date']);

      pay = Payout(
        amount: amount,
        points: points,
        status: status,
        id: id,
        approved: approved,
        rejected: rejected,
        date: date,
      );

//      parseArr.add(pay);
      payouts.add(pay);
    }
    payouts = RxList<Payout>(payouts.reversed.toList());

//    payouts.value = parseArr;
    print('7777777777777777777777');
    print(payouts.value[0]);
  }

//  void defaultUser() {
//    user.value = User(
//      email: 'Something@gmail.com',
//      name: 'Silencio ',
//      id: id,
//      points: 2000,
//      referralCode: 'SVRC134',
//      activityHistory: [],
//      allTimepoints: 5000,
//    );
//  }
}

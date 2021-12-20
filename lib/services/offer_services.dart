import 'package:http/http.dart' as http;
import 'package:genrevibes/models/offer.dart';
import 'package:genrevibes/constants/constants.dart';
import 'dart:convert';
import 'package:genrevibes/controller/user_controller.dart';
import 'package:get/get.dart';

class OfferApi {
  final userController = Get.put(UserController());
  String userId;
  List<Offer> offers = [];

  Future<void> getOffers(String category, {bool customoffer = false}) async {
    //****category might be used to fetch offers based on different tabs in the future****//

    userId = userController.user.value.id;

    String url = kserverUrl + kofferCategory.path + category;

    if (customoffer == true) {
      url = kserverUrl + '/' + kcustomoffer.path;
    }
    print(url);
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    print('====================trying');
    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonData["offers"].forEach((element) {
        Offer offer = Offer(
          title: element['name'],
          description: element['description'],
          urlToImage: element['image'],
          offerUrl: element["link"] + userId,
          ranking: element['ranking'],
          disabled: element['disabled'],
        );
        print('====================made');
        if (offer.disabled != true) {
          offers.add(offer);
        }
      });
      print(offers[0].offerUrl);
      offers.sort((a, b) {
        return a.ranking.compareTo(b.ranking);
      });
      print("----D------>" + offers[0].title);
    }
  }
}

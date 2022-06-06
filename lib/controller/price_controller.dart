import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:take_home_project/model/weight.dart';
import 'package:take_home_project/network/api.dart';

class PriceController extends GetxController {
  var isLoadingPrice = true.obs;
  var weights = <Weight>[].obs;

  // fetch price
  Future fetchPrice() async {
    try {
      isLoadingPrice(true);
      weights.clear();
      var response = await Api.fetchPrice();
      var jsonResponse = json.decode(response);
      var data = jsonResponse['prices'];
      weights.add(Weight.fromJson(data['ounce']));
      weights.add(Weight.fromJson(data['gram']));
      weights.add(Weight.fromJson(data['hundred_gram']));
      weights.add(Weight.fromJson(data['thousand_gram']));
    } finally {
      isLoadingPrice(false);
    }
  }
}

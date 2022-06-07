import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:take_home_project/model/data.dart';
import 'package:take_home_project/model/weight.dart';
import 'package:take_home_project/network/api.dart';

class DataController extends GetxController {
  var isLoadingPrice = true.obs;
  var weights = <Weight>[].obs;
  var slots = <Data>[].obs;

  // fetch price and appointment slots
  Future fetchData() async {
    try {
      isLoadingPrice(true);
      weights.clear();
      var responsePrice = await Api.fetchPrice(); // fetch price
      var jsonResponse = json.decode(responsePrice);
      var data = jsonResponse['prices'];
      weights.add(Weight.fromJson(data['ounce']));
      weights.add(Weight.fromJson(data['gram']));
      weights.add(Weight.fromJson(data['hundred_gram']));
      weights.add(Weight.fromJson(data['thousand_gram']));

      slots.clear();
      var responseSlot = await Api.fetchSlot(); // fetch appointment slots
      List<Data> results = [];
      results.addAll(List<Data>.from(
          json.decode(responseSlot).map((slot) => Data.fromJson(slot))));
      slots.assignAll(results);
    } finally {
      isLoadingPrice(false);
    }
  }
}

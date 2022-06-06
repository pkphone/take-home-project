import 'package:http/http.dart' as http;

class Api {
  static var client = http.Client();

  static Future<dynamic> fetchPrice() async {
    var response = await client.get(Uri.parse(
        'https://a69648a5-f361-43d0-a18c-5e0c6942687b.mock.pstmn.io/home/getPrices'));
    return response.body;
  }

  static Future<dynamic> fetchSlot() async {
    var response = await client.get(Uri.parse(
        'https://a69648a5-f361-43d0-a18c-5e0c6942687b.mock.pstmn.io/appointments/getSlots?date=2022-06-15'));
    return response.body;
  }
}

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

abstract class ApiClientData {
  static const apiUrl = 'https://eightballapi.com/api';
}

class ApiClient {
  Future<String?> getRandomReading() async {
    final url = Uri.parse(ApiClientData.apiUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      final text = jsonResponse["reading"];
      return text;
    } else {
      print(response.statusCode);
    }
    return "";
  }
}

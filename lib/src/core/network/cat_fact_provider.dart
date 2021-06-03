import 'dart:convert';

import 'package:http/http.dart' as http;

class CatFactProvider {
  static final String factUrl = 'https://catfact.ninja/fact?max_length=140';

  static Future<String> getCatFact() async {
    String responseBody = '';
    String fact = '';

    // Catch any error from http request
    try {
      responseBody = await getCatFactFromAPI();
      fact = Fact.fromHttpResponse(responseBody).toString();
    } catch (e) {
      fact = 'Cat fact not found (Check your cat internet)';
    }
    return fact;
  }

  static Future<String> getCatFactFromAPI() async =>
      (await http.get(Uri.parse(factUrl))).body;
}

class Fact {
  late String fact;

  Fact.fromHttpResponse(String response) {
    var fact = json.decode(response);
    this.fact = fact["fact"];
  }

  @override
  String toString() => fact;
}

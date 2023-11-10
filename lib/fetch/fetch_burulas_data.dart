import 'dart:convert';

import 'package:fetchingburulasapi/models/otobus_guzergah.dart';
import 'package:http/http.dart' as http;

Future<List<T>> fetchBurulasData<T>(String api, Map<String, dynamic> reqBody, T Function(Map<String, dynamic> data) callback) async {
  final response = await http.post(
      Uri.parse('https://bursakartapi.abys-web.com/$api'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(reqBody));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body)["result"].cast<Map<String, dynamic>>();

    return parsed.map<T>((json) {
      return callback(json);
    }).toList();
  } else {
    throw Exception('Failed to load');
  }
}

Future<List<OtobusGuzergah>> fetchAllBuses() async {
  final r = await http.get(Uri.parse('https://petekapi.burulas.com.tr/burulasweb/otobus/hatlar'),headers: {'Content-Type': 'application/json; charset=UTF-8'});
  if (r.statusCode == 200) {
    final parsed = json.decode(r.body).cast<Map<String, dynamic>>();
    return parsed.map<OtobusGuzergah>((json) => OtobusGuzergah.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load');
  }
}
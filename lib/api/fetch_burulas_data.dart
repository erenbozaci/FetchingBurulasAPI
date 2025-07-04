import 'dart:convert';
import 'dart:io';

import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}

Future<List<T>> fetchBurulasData<T>(String api, Map<String, dynamic> reqBody, T Function(Map<String, dynamic> data) callback) async {
  try {
    HttpOverrides.global = MyHttpOverrides();

    final response = await http.post(
        Uri.parse('https://bursakartapi.abys-web.com/$api'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Origin": "https://www.bursakart.com.tr"
        },
        body: jsonEncode(reqBody));

    if (response.statusCode != 200) throw Exception('Failed to load $api, status code: ${response.statusCode}');

    final burulasJson = json.decode(response.body);
    if (!burulasJson.containsKey('result')) throw Exception('Failed to load $api, result not found');

    final parsed = burulasJson["result"].cast<Map<String, dynamic>>();
    return parsed.map<T>((json) => callback(json)).toList();
  } catch (e) {
    throw Exception('Failed to load $api: $e');
  }
}

Future<List<BusRoute>> fetchAllBuses() async {
  final r = await http.get(Uri.parse('https://petekapi.burulas.com.tr/burulasweb/otobus/hatlar'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'});
  if (r.statusCode == 200) {
    final parsed = json.decode(r.body).cast<Map<String, dynamic>>();
    return parsed.map<BusRoute>((json) => BusRoute.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load all buses');
  }
}
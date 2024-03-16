import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartenergy_app/api/api_cfg.dart';

Future<List<dynamic>> getDispositivos(String customerId) async {
  final url = '${Config.apiUrl}/customer/$customerId/devices?pageSize=10&page=0';
  final headers = {
    'accept': 'application/json',
    'X-Authorization': 'Bearer ${Config.token}'
  };

  final response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    final dynamic jsonResponse = json.decode(response.body);
    return jsonResponse['data']; // Retorna a lista de dispositivos
  } else {
    throw Exception('Failed to load devices');
  }
}

void main() async {
  try {
    String customerId = 'c85e4c80-d9e7-11ee-a2dd-dda04d5a084f';
    List<dynamic> dispositivos = await getDispositivos(customerId);
    print(dispositivos);
  } catch (e) {
    print(e);
  }
}

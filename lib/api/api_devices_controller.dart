import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartenergy_app/api/api_cfg.dart';


void createDevice(String cusomerId) async{
  

}

Future<List<dynamic>> getDispositivos(String customerId) async {
  final url = '${Config.apiUrl}/customer/$customerId/devices?pageSize=20&page=0';
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
    String customerId = '57a85cc0-e639-11ee-bf71-bd1e2ee8c819';
    List<dynamic> dispositivos = await getDispositivos(customerId);
    print(dispositivos);
  } catch (e) {
    print(e);
  }
}

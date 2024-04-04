import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:smartenergy_app/services/tbclient_service.dart';

void fetchData() async {
  ThingsBoardService thingsBoardService = ThingsBoardService();
  await Future.delayed(Duration(seconds: 5)); // Espera por 5 segundos

  print(thingsBoardService.tbClient.isAuthenticated());
  String? token =  thingsBoardService.tbClient.getJwtToken();
  var url = Uri.parse('https://thingsboard.cloud:443/api/customer/57a85cc0-e639-11ee-bf71-bd1e2ee8c819/devices?pageSize=20&page=0');
  var headers = {
    'accept': 'application/json',
    'X-Authorization': 'Bearer $token'
  };

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var devices = jsonResponse['data'];
    for (var device in devices) {
      var id = device['id']['id'];
      var description = device['additionalInfo']['description'];
      var mac = device['additionalInfo']['mac'];
      var serialKey = device['additionalInfo']['serialKey'];
      print('Device ID: $id, Description: $description, MAC: $mac, Serial Key: $serialKey');
    }
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}



void main(List<String> args) {
  fetchData();

}
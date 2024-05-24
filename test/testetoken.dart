import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

const thingsBoardApiEndpoint = 'https://thingsboard.cloud';

Future<dynamic> getAllCustomers(String token) async {
  final String url = '${Config.apiUrl}/customers?pageSize=1000&page=0';
  final Map<String, String> headers = {
    'accept': 'application/json',
    'X-Authorization': 'Bearer $token'
  };

  final uri = Uri.parse(url);
  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    print('Requisição bem-sucedida!');
    final data = json.decode(response.body);
    return data;
  } else {
    print('Erro ao fazer a solicitação. Código de status: ${response.statusCode}');
    return null;
  }
}

Future<void> verifyToken(ThingsboardClient tbClient) async {
  if (!tbClient.isJwtTokenValid()) {
    print("Token não é válido!");
    try {
      await tbClient.refreshJwtToken();
      print("Token foi renovado com sucesso.");
      print("Novo token: ${tbClient.getJwtToken()}");
    } catch (e) {
      print("Erro ao renovar o token: $e");
    }
  } else {
    print("Token é válido! ${tbClient.getJwtToken()}");
  }
}

void main(List<String> args) async {
  var tbClient = ThingsboardClient(thingsBoardApiEndpoint);
  await tbClient.login(LoginRequest('smartenergy.039@gmail.com', 'smartenergy2024'));
  print(tbClient.isAuthenticated());

  //Timer.periodic(Duration(minutes: 2), (Timer t) async {
   // await verifyToken(tbClient);
 // });

  // Verifica o token imediatamente na inicialização
  //await verifyToken(tbClient);
}

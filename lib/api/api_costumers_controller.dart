import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartenergy_app/api/api_cfg.dart';

Future<int> criarCustomer({
  required String login,
  required String senha,
  required String email,
  required String telefone,
  required String cep,
  required String estado,
  required String cidade,
  required String endereco,
  required String complemento,
}) async {
  final url = Uri.parse('${Config.apiUrl}/customer');

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization': 'Bearer ${Config.token}',
  };

  final ownerId = {
    "id": "13645f00-d68a-11ee-a550-01ba59c8406b", //id do owner(conta principal)
    "entityType": "DEVICE"
  };

  final body = json.encode({
    "title": login,
    "ownerId": ownerId,
    "country": "BR",
    "state": estado,
    "city": cidade,
    "address": endereco,
    "address2": complemento,
    "zip": cep,
    "phone": '+55$telefone',
    "email": email,
    "additionalInfo": {
      "password": senha
    }
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Usuário cadastrado com sucesso!');
      return 200;
    }

    if(response.statusCode == 400){
      print('Usuário já cadastrado!');
      return 400;
    }

    if(response.statusCode == 403){
      print('Usuário já cadastrado!');
      return 403;
    }

    else {
      print('Erro ao cadastrar usuário. Código de status: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao realizar a requisição: $e');
  }
  return 0;
}

Future<dynamic> getAllCustomers() async {
  final String url = '${Config.apiUrl}/customers?pageSize=1000&page=0';
  final Map<String, String> headers = {
    'accept': 'application/json',
    'X-Authorization':
        'Bearer ${Config.token}'
  };

  final uri = Uri.parse(url);
  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    print('Requisição bem-sucedida!');
    final data = json.decode(response.body);
    return data;
  } else {
    print('Erro ao fazer a solicitação. Código de status: ${response.statusCode}');
    return null; // Retorna null em caso de erro
  }
}

dynamic verifyLoginAndPassword(String login, String senha) async {
  dynamic jsonData = await getAllCustomers();
  final data = jsonData['data'];
  print(data);

  for (var customer in data) {
    final title = customer['title'];
    final password = customer['additionalInfo']['password'];
    
    // Verifica se o login e a senha correspondem
    if (title == login && password == senha) {
      print(customer);
      return customer; // Retorna true se corresponderem
    }
  }
  // Retorna false se nenhum login e senha correspondente for encontrado
  return null;
}
import 'dart:convert';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/api/api_costumers_controller.dart';
import 'package:smartenergy_app/services/Customer_info.dart';


  Future<bool>  adicionarTelefone1(String telefone1) async {
  String url = 'https://thingsboard.cloud:443/api/customer';
  String token = Config.token;
  String tenantId = "b2a57df0-04d5-11ef-ac64-c1f214c97728";
  String? customer_id = CustomerInfo.idCustomer;
  late String login;
  late String senha;
  late String email;
  late String telefone;
  late String cep;
  late String estado;
  late String cidade;
  late String endereco;
  late String complemento;
  late String telefone2;
  dynamic customer = await getCustomer();

  Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization':'Bearer $token',
  };

  login = customer['title'];
  senha = customer['additionalInfo']['password'];
  email = customer['email'];
  cep = customer["zip"];
  estado = customer["state"];
  cidade = customer["city"];
  complemento = customer["address2"];
  endereco = customer["address"];
  telefone = customer["phone"];
  telefone2 = customer['additionalInfo']['telefone2'];
  if(telefone1.trim() == telefone2 || telefone1.trim() == telefone){
    return false;
  }
  

  Map<String, dynamic> body = {
    "id": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "title": login,
    "tenantId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "customerId": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "ownerId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "country": "BR",
    "state": estado,
    "city":  cidade,
    "address": endereco,
    "address2": complemento,
    "zip": cep,
    "phone": telefone,
    "email": email,
    "name": login,
    "additionalInfo": {
    "password": senha, "telefone1": telefone1, "telefone2":telefone2 
    },
  };

  String jsonBody = jsonEncode(body);

  http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return true;
  
}
Future<bool> adicionarTelefone2(String telefone2) async {
  String url = 'https://thingsboard.cloud:443/api/customer';
  String token = Config.token;
  //var tbClient;
  String tenantId = "b2a57df0-04d5-11ef-ac64-c1f214c97728";
  String? customer_id = CustomerInfo.idCustomer;
  late String login;
  late String senha;
  late String email;
  late String telefone;
  late String cep;
  late String estado;
  late String cidade;
  late String endereco;
  late String complemento;
  late String telefone1;
  dynamic customer = await getCustomer();

  Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization':'Bearer $token',
  };

  login = customer['title'];
  senha = customer['additionalInfo']['password'];
  email = customer['email'];
  cep = customer["zip"];
  estado = customer["state"];
  cidade = customer["city"];
  complemento = customer["address2"];
  endereco = customer["address"];
  telefone = customer["phone"];
  telefone1 = customer['additionalInfo']['telefone1'];
  if(telefone2.trim() == telefone1 || telefone2.trim() == telefone){
    return false;
  }


  Map<String, dynamic> body = {
    "id": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "title": login,
    "tenantId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "customerId": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "ownerId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "country": "BR",
    "state": estado,
    "city":  cidade,
    "address": endereco,
    "address2": complemento,
    "zip": cep,
    "phone": telefone,
    "email": email,
    "name": login,
    "additionalInfo": {
    "password": senha, "telefone1": telefone1, "telefone2":telefone2 
    },
  };

  String jsonBody = jsonEncode(body);
  http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return true;
}

Future<dynamic> getCustomer() async {
  // URL da API e token de autorização
  String url =
      'https://thingsboard.cloud/api/customer/a12bc7b0-04d9-11ef-bef7-5131a0fcf1e6';
 
  String token = Config.token;
  // Cabeçalhos da requisição
  Map<String, String> headers = {
    'accept': 'application/json',
    'X-Authorization': 'Bearer $token',
  };

  // Realizando a requisição GET
  var response = await http.get(Uri.parse(url), headers: headers);

  // Verificando se a requisição foi bem-sucedida
  if (response.statusCode == 200) {
    // Decodificando a resposta JSON
    final data = json.decode(response.body);
    return data;
  } else {
    print('Erro: ${response.statusCode}');
  }
}
Future<bool> editarTelefonePrincipa(String telefone3) async {
  String url = 'https://thingsboard.cloud:443/api/customer';
  String token = Config.token;
  //var tbClient;
  String tenantId = "b2a57df0-04d5-11ef-ac64-c1f214c97728";
  String? customer_id = CustomerInfo.idCustomer;
  late String login;
  late String senha;
  late String email;
  late String telefone;
  late String cep;
  late String estado;
  late String cidade;
  late String endereco;
  late String complemento;
  late String telefone1;
  late String telefone2;
  dynamic customer = await getCustomer();

  Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization':'Bearer $token',
  };

  login = customer['title'];
  senha = customer['additionalInfo']['password'];
  email = customer['email'];
  cep = customer["zip"];
  estado = customer["state"];
  cidade = customer["city"];
  complemento = customer["address2"];
  endereco = customer["address"];
  telefone = telefone3;
  telefone1 = customer['additionalInfo']['telefone1'];
  telefone2 = customer['additionalInfo']['telefone2'];
  


  Map<String, dynamic> body = {
    "id": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "title": login,
    "tenantId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "customerId": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "ownerId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "country": "BR",
    "state": estado,
    "city":  cidade,
    "address": endereco,
    "address2": complemento,
    "zip": cep,
    "phone": telefone,
    "email": email,
    "name": login,
    "additionalInfo": {
    "password": senha, "telefone1": telefone1, "telefone2":telefone2 
    },
  };

  String jsonBody = jsonEncode(body);
  http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return true;
}

Future<bool> editarEmail(String email2) async {
  String url = 'https://thingsboard.cloud:443/api/customer';
  String token = Config.token;
 
  String tenantId = "b2a57df0-04d5-11ef-ac64-c1f214c97728";
  String? customer_id = CustomerInfo.idCustomer;
  late String login;
  late String senha;
  late String email;
  late String telefone;
  late String cep;
  late String estado;
  late String cidade;
  late String endereco;
  late String complemento;
  late String telefone1;
  late String telefone2;
  
  
  dynamic customer = await getCustomer();
  bool result = await verificarEmail(email2);
  if(result){
    return false;
  }

  Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization':'Bearer $token',
  };

  login = customer['title'];
  senha = customer['additionalInfo']['password'];
  email = email2;
  cep = customer["zip"];
  estado = customer["state"];
  cidade = customer["city"];
  complemento = customer["address2"];
  endereco = customer["address"];
  telefone =  customer["phone"];
  telefone1 = customer['additionalInfo']['telefone1'];
  telefone2 = customer['additionalInfo']['telefone2'];
  


  Map<String, dynamic> body = {
    "id": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "title": login,
    "tenantId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "customerId": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "ownerId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "country": "BR",
    "state": estado,
    "city":  cidade,
    "address": endereco,
    "address2": complemento,
    "zip": cep,
    "phone": telefone,
    "email": email,
    "name": login,
    "additionalInfo": {
    "password": senha, "telefone1": telefone1, "telefone2":telefone2 
    },
  };

  String jsonBody = jsonEncode(body);
  http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return true;
}

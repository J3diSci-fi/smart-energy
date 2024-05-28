import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/services/Customer_info.dart';

Future<int> criarCustomer(
    {required String login,
    required String senha,
    required String email,
    required String telefone,
    required String cep,
    required String estado,
    required String cidade,
    required String endereco,
    required String complemento,
    required String id_owner}) async {
  final url = Uri.parse('${Config.apiUrl}/customer');

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization': 'Bearer ${Config.token}',
  };

  

  final body = json.encode({
    "title": login.toLowerCase(),
    "tenantId": {"id": id_owner, "entityType": "TENANT"},
    "parentCustomerId": {"id": id_owner, "entityType": "CUSTOMER"},
    "customerId": {"id": id_owner, "entityType": "CUSTOMER"},
    "ownerId": id_owner,
    "country": "BR",
    "state": estado,
    "city": cidade,
    "address": endereco,
    "address2": complemento,
    "zip": cep,
    "phone": "+55" + telefone.replaceAll(RegExp(r'[()\-\s]'), ''),
    "email": email.toLowerCase(),
    "additionalInfo": {
      "description": "",
      "password": senha.toLowerCase(),
      "telefone1": "",
      "telefone2": ""
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

    if (response.statusCode == 400) {
      print('Usuário já cadastrado!');
      return 400;
    }

    if (response.statusCode == 403) {
      print('Usuário já cadastrado!');
      return 403;
    } else {
      print(
          'Erro ao cadastrar usuário. Código de status: ${response.statusCode}');
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
    'X-Authorization': 'Bearer ${Config.token}'
  };

  final uri = Uri.parse(url);
  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    print('Requisição bem-sucedida!');
    final data = json.decode(response.body);
    return data;
  } else {
    print(
        'Erro ao fazer a solicitação. Código de status: ${response.statusCode}');
    return null; // Retorna null em caso de erro
  }
}

// se der erro quando tu digitar um usuario e senha que n existem, é pq tem customer criados manualmente no thingboard sem os parametros [passowrd] aí quando tenta acessar dar erro
dynamic verifyLoginAndPassword(String login, String senha) async {
  dynamic jsonData = await getAllCustomers();
  final data = jsonData['data'];

  for (var customer in data) {
    final title = customer['title'];
    final password = customer['additionalInfo']['password'];
    
    // Verifica se o login e a senha correspondem
    if (title == login.toLowerCase() && password == senha.toLowerCase()) {
      return customer;
    }
  }
  return null;
}

Future<Map<String, String>> retornarLoginSenha(String email) async {
  dynamic jsonData = await getAllCustomers();
  final data = jsonData['data'];

  for (var customer in data) {
    final emaill = customer['email'];

    if (emaill == email.toLowerCase()) {
      final login = customer['title'];
      final senha = customer['additionalInfo']['password'];

      return {'login': login, 'senha': senha};
    }
  }

  return {}; // Retorna null se o email não for encontrado
}

// enviar email para o cliente
Future<bool> sendEmail(String client_email, String login, String senha) async {
  final service_id = "service_h9kuzxt";
  final templateId = "template_2sftte6";
  final userId = "P9ZkyGOdmNuwxNjqR";
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'service_id': service_id,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_email': client_email,
        'client_email': client_email,
        "message": "Seu login é: $login e sua senha é: $senha",
      }
    }),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> verificarEmail(String email) async {
  dynamic jsonData = await getAllCustomers();
  final data = jsonData['data'];

  for (var customer in data) {
    final emaill = customer['email'];

    // Verifica se o email já existe;
    if (emaill == email.toLowerCase()) {
      return true;
    }
  }
  return false;
}

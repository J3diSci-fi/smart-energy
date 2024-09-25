import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> salvar_telefones_aws(String key, String telefones) async {
  final url = Uri.https(
    '3txbq7vkri.execute-api.us-east-1.amazonaws.com',
    '/staging/getpdf',
    {'Customer_id': '"$key"', 'informacoes': '"$telefones"'},
  );
  final response = await http.post(url);

  // Verifique o status da resposta
  if (response.statusCode == 200) {
    print('salvar telefones: Requisição bem-sucedida');
    // A resposta pode ser acessada por response.body
    print(response.body);
  } else {
    print('salvar telefones:Falha na requisição: ${response.statusCode}');
    print('salvar telefones:Detalhes do erro: ${response.body}');
  }
}

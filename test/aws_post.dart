import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> salvar_telefones_aws(String id, String telefones) async {
  final url = Uri.https(
    '3txbq7vkri.execute-api.us-east-1.amazonaws.com',
    '/staging/getpdf',
    {'Customer_id': '"$id"', 'informacoes': '"$telefones"'},
  );
  final response = await http.post(url);

  // Verifique o status da resposta
  if (response.statusCode == 200) {
    print('Requisição bem-sucedida');
    // A resposta pode ser acessada por response.body
    print(response.body);
  } else {
    print('Falha na requisição: ${response.statusCode}');
    print('Detalhes do erro: ${response.body}');
  }
}


void main() async {
  String conteudo = "fala";
  List<int> numeros = [1, 2, 3, 4, 5];

  for (var numero in numeros) {
    await salvar_telefones_aws(numero.toString(), conteudo);
  }
}

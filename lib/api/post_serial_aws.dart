import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> atualizar_status_serial(String serial, String status) async {
  var url = Uri.parse('https://nv9lgffrmk.execute-api.us-east-1.amazonaws.com/stage/cadastrar_serial');
  var params = {'Serial_key': '$serial', 'status': '$status'};
  var uri = Uri.https(url.authority, url.path, params);
  var response = await http.post(uri);

  
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print("atualizar status: Requisição bem-sucedida!");
    print("atualizar status:Resposta: $data");

    var bodyData = json.decode(data['body']);
    print(bodyData);
    
  } else {
    print("atualizar status: Erro na requisição: ${response.body}");
  }
}

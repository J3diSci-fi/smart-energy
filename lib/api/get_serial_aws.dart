import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchData(String serial) async {

  var url = Uri.parse('https://nv9lgffrmk.execute-api.us-east-1.amazonaws.com/stage/buscar_serial');
  var params = {'Serial_key': '$serial'};
  var uri = Uri.https(url.authority, url.path, params);
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print("Requisição bem-sucedida!");
    print("Resposta: $data");

    var bodyData = json.decode(data['body']);
    return bodyData;
    
  } else {
    print("Erro na requisição: ${response.body}");
    return {};
  }
}

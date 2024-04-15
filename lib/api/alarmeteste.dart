import 'package:http/http.dart' as http;
import 'dart:convert';
void fetchData() async {
  // URL da API ThingsBoard

  var url = Uri.parse('https://thingsboard.cloud:443/api/alarm/CUSTOMER/737c0f20-ef01-11ee-90b7-13997ac71b7a?pageSize=20&page=0');
  var headers = {
      'accept': 'application/json',
      'X-Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJub3JpZXRlY2FydmFsaG8xMkBnbWFpbC5jb20iLCJ1c2VySWQiOiJjYmM5OWJkMC1lZjAwLTExZWUtOTBiNy0xMzk5N2FjNzFiN2EiLCJzY29wZXMiOlsiVEVOQU5UX0FETUlOIl0sInNlc3Npb25JZCI6IjQyY2I1NzMwLTZmOTAtNDE0MS04OWIyLTVmNmQ3ZDg1ZmU4NyIsImlzcyI6InRoaW5nc2JvYXJkLmNsb3VkIiwiaWF0IjoxNzEzMTQyNjIyLCJleHAiOjE3MTMxNzE0MjIsImZpcnN0TmFtZSI6Ikx1aXoiLCJsYXN0TmFtZSI6IkNhcnZhbGhvIiwiZW5hYmxlZCI6dHJ1ZSwiaXNQdWJsaWMiOmZhbHNlLCJpc0JpbGxpbmdTZXJ2aWNlIjpmYWxzZSwicHJpdmFjeVBvbGljeUFjY2VwdGVkIjp0cnVlLCJ0ZXJtc09mVXNlQWNjZXB0ZWQiOnRydWUsInRlbmFudElkIjoiY2FhMjBiYzAtZWYwMC0xMWVlLTkwYjctMTM5OTdhYzcxYjdhIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.Ht38M86z6jSPGLrH71m-Z9d_2dMaT0E2VO16zQ8fKmR65lm2UvAQoqZ21kwO7v4iDNRZSg9zsbabSWticK27YA',
  };
 
  // Cabeçalhos da requisição
  

  // Fazendo a requisição GET
  var response = await http.get(url, headers: headers);

  // Verifica o código de status da resposta
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var alarmes = jsonResponse['data'];
    for (var alarme in alarmes) {
      // Extrai as informações desejadas de cada alarme
      var id = alarme['id']['id'];
      var createdTime = alarme['createdTime'];
      var details = alarme['details'];
      var status = alarme['status'];
      var originatorName = alarme['originatorName'];

      // Imprime as informações
      print('ID do Alarme: $id');
      print('Data de Criação: $createdTime');
      print('Detalhes: $details');
      print('Status: $status');
      print('Nome do Originador: $originatorName');
    }
    
  } else {
    // Caso ocorra um erro na requisição
    print('Erro: ${response.statusCode}');
  }
}


void main(List<String> args) {

    fetchData();

}
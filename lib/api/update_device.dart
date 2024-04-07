
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String url = 'https://thingsboard.cloud:443/api/device';
  String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJub3JpZXRlY2FydmFsaG8xMkBnbWFpbC5jb20iLCJ1c2VySWQiOiJjYmM5OWJkMC1lZjAwLTExZWUtOTBiNy0xMzk5N2FjNzFiN2EiLCJzY29wZXMiOlsiVEVOQU5UX0FETUlOIl0sInNlc3Npb25JZCI6ImI0MTZkNTZlLTZhMjItNDk4MC04MGRiLTc1NjgwN2Q0YWYwNiIsImlzcyI6InRoaW5nc2JvYXJkLmNsb3VkIiwiaWF0IjoxNzEyNDQzNTIwLCJleHAiOjE3MTI0NzIzMjAsImZpcnN0TmFtZSI6Ikx1aXoiLCJsYXN0TmFtZSI6IkNhcnZhbGhvIiwiZW5hYmxlZCI6dHJ1ZSwiaXNQdWJsaWMiOmZhbHNlLCJpc0JpbGxpbmdTZXJ2aWNlIjpmYWxzZSwicHJpdmFjeVBvbGljeUFjY2VwdGVkIjp0cnVlLCJ0ZXJtc09mVXNlQWNjZXB0ZWQiOnRydWUsInRlbmFudElkIjoiY2FhMjBiYzAtZWYwMC0xMWVlLTkwYjctMTM5OTdhYzcxYjdhIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.3Fh7X7WY2nwVEWAD0spGNNbAYFylmRVwV2HnuUnjWQQMKSGRi_svb9MHzgC5MjUuT-hf2EG8gHeb1odYqlvRGQ';

  Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization': 'Bearer $token',
  };

  Map<String, dynamic> body = {
    "id": {
      "id": "3c145760-f3aa-11ee-ae87-79b197dbfe12",
      "entityType": "DEVICE"
    },
    "tenantId": {
      "id": "cbc99bd0-ef00-11ee-90b7-13997ac71b7a",
      "entityType": "TENANT"
    },
    "customerId": {
      "id": "737c0f20-ef01-11ee-90b7-13997ac71b7a",
      "entityType": "CUSTOMER"
    },
    "ownerId": {
      "id": "737c0f20-ef01-11ee-90b7-13997ac71b7a",
      "entityType": "CUSTOMER"
    },
    "name": "Fazenda da Filipe2",
    "type": "default",
    "label": "null",
    "deviceProfileId": {
      "id": "caa39260-ef00-11ee-90b7-13997ac71b7a",
      "entityType": "DEVICE_PROFILE"
    },
    "deviceData": {
      "configuration": {"type": "DEFAULT"},
      "transportConfiguration": {"type": "DEFAULT"}
    },
    "additionalInfo": {
      "description": "dispositivo na minha fazenda ",
      "mac": "391931",
      "serialKey": "3812381",
      "data": "06-04-2024"
    }
  };

  String jsonBody = jsonEncode(body);

  http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}
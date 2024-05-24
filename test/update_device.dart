
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String url = 'https://thingsboard.cloud:443/api/device';
  String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzbWFydGVuZXJneS4wMzNAZ21haWwuY29tIiwidXNlcklkIjoiYjJhNTdkZjAtMDRkNS0xMWVmLWFjNjQtYzFmMjE0Yzk3NzI4Iiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJzZXNzaW9uSWQiOiIyM2IxMjNjNS0yNGU1LTQ5ODQtOGJmZS1jMTYwYzczMGFlZjkiLCJpc3MiOiJ0aGluZ3Nib2FyZC5jbG91ZCIsImlhdCI6MTcxNTY0Mzg1MiwiZXhwIjoxNzE1NjcyNjUyLCJmaXJzdE5hbWUiOiJTbWFydEVuZXJneSIsImxhc3ROYW1lIjoiU21hcnRFbmVyZ3kiLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsImlzQmlsbGluZ1NlcnZpY2UiOmZhbHNlLCJwcml2YWN5UG9saWN5QWNjZXB0ZWQiOnRydWUsInRlcm1zT2ZVc2VBY2NlcHRlZCI6dHJ1ZSwidGVuYW50SWQiOiJiMTlkZDFmMC0wNGQ1LTExZWYtYWM2NC1jMWYyMTRjOTc3MjgiLCJjdXN0b21lcklkIjoiMTM4MTQwMDAtMWRkMi0xMWIyLTgwODAtODA4MDgwODA4MDgwIn0.LYsLGMQKcWZU1CupWMmmoG_BTWQQUUiFxFNL0NCsP2eHH0f-fsevI-QLWBLxrMahFNnRqbzfF9SnW3HZGOGH_w';

  Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization': 'Bearer $token',
  };

  Map<String, dynamic> body = {
    "id": {
      "id": "a92ab620-1171-11ef-ac64-c1f214c97728",
      "entityType": "DEVICE"
    },
    "tenantId": {
      "id": "b2a57df0-04d5-11ef-ac64-c1f214c97728",
      "entityType": "TENANT"
    },
    "customerId": {
      "id": "9943e910-10be-11ef-bf1e-eb47e687e405",
      "entityType": "CUSTOMER"
    },
    "ownerId": {
      "id": "9943e910-10be-11ef-bf1e-eb47e687e405",
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
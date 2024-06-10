import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartenergy_app/logic/audio/soundManager.dart';
import 'package:flutter/material.dart';
Future<void> setOwnerDevice(String id) async {
  final url = Uri.parse('https://thingsboard.cloud/api/owner/CUSTOMER/9943e910-10be-11ef-bf1e-eb47e687e405/DEVICE/$id');
  final headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
    'X-Authorization':'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzbWFydGVuZXJneS4wMzNAZ21haWwuY29tIiwidXNlcklkIjoiYjJhNTdkZjAtMDRkNS0xMWVmLWFjNjQtYzFmMjE0Yzk3NzI4Iiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJzZXNzaW9uSWQiOiIyM2IxMjNjNS0yNGU1LTQ5ODQtOGJmZS1jMTYwYzczMGFlZjkiLCJpc3MiOiJ0aGluZ3Nib2FyZC5jbG91ZCIsImlhdCI6MTcxNTY4OTQwMCwiZXhwIjoxNzE1NzE4MjAwLCJmaXJzdE5hbWUiOiJTbWFydEVuZXJneSIsImxhc3ROYW1lIjoiU21hcnRFbmVyZ3kiLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsImlzQmlsbGluZ1NlcnZpY2UiOmZhbHNlLCJwcml2YWN5UG9saWN5QWNjZXB0ZWQiOnRydWUsInRlcm1zT2ZVc2VBY2NlcHRlZCI6dHJ1ZSwidGVuYW50SWQiOiJiMTlkZDFmMC0wNGQ1LTExZWYtYWM2NC1jMWYyMTRjOTc3MjgiLCJjdXN0b21lcklkIjoiMTM4MTQwMDAtMWRkMi0xMWIyLTgwODAtODA4MDgwODA4MDgwIn0.0mwJuEEINtv0LPW7TyU-iPGJwafGMh1AsTFgENVahd7FscuX7Uh5PXV_dtWA8zCemO8fNkHSZg6Gn81GZowbrw'
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Requisição bem-sucedida!');
    } else {
      print('Erro ao fazer a requisição. Código de status: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao realizar a requisição: $e');
  }
}

Future<String> cadastrarDevice(String nome, String serial_key, String descricao,String data) async {
  final url = Uri.parse('https://thingsboard.cloud/api/device-with-credentials');
  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzbWFydGVuZXJneS4wMzNAZ21haWwuY29tIiwidXNlcklkIjoiYjJhNTdkZjAtMDRkNS0xMWVmLWFjNjQtYzFmMjE0Yzk3NzI4Iiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJzZXNzaW9uSWQiOiIyM2IxMjNjNS0yNGU1LTQ5ODQtOGJmZS1jMTYwYzczMGFlZjkiLCJpc3MiOiJ0aGluZ3Nib2FyZC5jbG91ZCIsImlhdCI6MTcxNTY4OTQwMCwiZXhwIjoxNzE1NzE4MjAwLCJmaXJzdE5hbWUiOiJTbWFydEVuZXJneSIsImxhc3ROYW1lIjoiU21hcnRFbmVyZ3kiLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsImlzQmlsbGluZ1NlcnZpY2UiOmZhbHNlLCJwcml2YWN5UG9saWN5QWNjZXB0ZWQiOnRydWUsInRlcm1zT2ZVc2VBY2NlcHRlZCI6dHJ1ZSwidGVuYW50SWQiOiJiMTlkZDFmMC0wNGQ1LTExZWYtYWM2NC1jMWYyMTRjOTc3MjgiLCJjdXN0b21lcklkIjoiMTM4MTQwMDAtMWRkMi0xMWIyLTgwODAtODA4MDgwODA4MDgwIn0.0mwJuEEINtv0LPW7TyU-iPGJwafGMh1AsTFgENVahd7FscuX7Uh5PXV_dtWA8zCemO8fNkHSZg6Gn81GZowbrw'
  };
  final body = jsonEncode({
    "device": {
      "tenantId": {
        "id": "b2a57df0-04d5-11ef-ac64-c1f214c97728",
        "entityType": "TENANT"
      },
      "ownerId": {
        "id": "9943e910-10be-11ef-bf1e-eb47e687e405",
        "entityType": "CUSTOMER"
      },
      "name": nome,
      "type": "default",
      "label": "SmartEnergy",
      "deviceData": {
        "configuration": {"type": "DEFAULT"},
        "transportConfiguration": {"type": "DEFAULT"}
      },
      "firmwareId": null,
      "softwareId": null,
      "additionalInfo": {
        "description": descricao,
        "serialKey": serial_key,
        "data": data
      }
    },
    "credentials": {
      "credentialsType": "MQTT_BASIC",
      "credentialsValue": "{\"clientId\":\"$serial_key\",\"userName\":\"$serial_key\",\"password\":\"$serial_key\"}"
    }
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Dispositivo cadastrado com sucesso!');
      final jsondata = json.decode(response.body);
      String device_id = jsondata["id"]["id"];
      setOwnerDevice(device_id);
      return device_id;
      

    } else {
      print('Erro ao cadastrar dispositivo. Código de status: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao realizar a requisição: $e');
  }
  return "erro";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SoundManager sound = SoundManager();
  //sound.playSong(); 
  
}

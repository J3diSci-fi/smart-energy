import 'dart:convert';
import 'package:smartenergy_app/api/utils.dart';
import 'package:web_socket_channel/io.dart';

String getFromEighthDigit(String serial) {
  if (serial.length <= 8) {
    return serial; // Caso a string tenha menos ou igual a 7 dígitos, retorna ela mesma
  }
  return serial.substring(8); // Retorna a partir do 8º dígito
}
void main() {
  final token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZW5hbnRAdGhpbmdzYm9hcmQub3JnIiwidXNlcklkIjoiZjhjYzQ0ZDAtMzk3OC0xMWVmLWIzYWYtNmQ3ZTc3ZTNkYTM3Iiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJzZXNzaW9uSWQiOiJjNTNhOGI5OS0zZDBhLTQ5M2EtOWJmMS0yNjA3MDJiNzQwOTEiLCJleHAiOjI3OTM3ODAxOTUsImlzcyI6InRoaW5nc2JvYXJkLmlvIiwiaWF0IjoxNzIwMDM4MzcyLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsInRlbmFudElkIjoiYzdkYjQ2ZjAtMzk3OC0xMWVmLWIzYWYtNmQ3ZTc3ZTNkYTM3IiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.Yw8VwsHc6w5PDX6NcxKZwAf_Un112fC_YdVrAyJSLov0C_8LVtpVy5vG3-vRk4xo1Y997yDjyc2LRYAQL0pzsA";
  final entityId = "c5b67c50-75eb-11ef-b3af-6d7e77e3da37";
  final channel = IOWebSocketChannel.connect('ws://backend.smartenergy.smartrural.com.br/api/ws');
  String serial = "2024-0917-AAA1";
  serial = formatSerialKey(serial);
  String serial2 = convertLettersToNumbers(serial);
  serial2 = getFromEighthDigit(serial2);
  print("cmdid: ${serial2}");
  if (entityId == "") {
    print("Invalid device id!");
    channel.sink.close();
    return;
  }

  if (token == "YOUR_JWT_TOKEN") {
    print("Invalid JWT token!");
    channel.sink.close();
    return;
  }

  channel.stream.listen((message) {
    print("Message is received: $message");
    print(serial2);
   
  });
  
  channel.sink.add(jsonEncode({
    "authCmd": {
      "cmdId": 1,
      "token": token,
    },
    "cmds": [
      {
        "entityType": "DEVICE",
        "entityId": entityId,
        "scope": "LATEST_TELEMETRY",
        "cmdId": 012,
        "type": "TIMESERIES"
        
      }
    ]
  }));
    
  print("Message is sent");
}

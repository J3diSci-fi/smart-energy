import 'dart:convert';
import 'package:web_socket_channel/io.dart';

void main() {
  final token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJub3JpZXRlY2FydmFsaG8xMkBnbWFpbC5jb20iLCJ1c2VySWQiOiJjYmM5OWJkMC1lZjAwLTExZWUtOTBiNy0xMzk5N2FjNzFiN2EiLCJzY29wZXMiOlsiVEVOQU5UX0FETUlOIl0sInNlc3Npb25JZCI6IjQyY2I1NzMwLTZmOTAtNDE0MS04OWIyLTVmNmQ3ZDg1ZmU4NyIsImlzcyI6InRoaW5nc2JvYXJkLmNsb3VkIiwiaWF0IjoxNzEzMDE3OTYzLCJleHAiOjE3MTMwNDY3NjMsImZpcnN0TmFtZSI6Ikx1aXoiLCJsYXN0TmFtZSI6IkNhcnZhbGhvIiwiZW5hYmxlZCI6dHJ1ZSwiaXNQdWJsaWMiOmZhbHNlLCJpc0JpbGxpbmdTZXJ2aWNlIjpmYWxzZSwicHJpdmFjeVBvbGljeUFjY2VwdGVkIjp0cnVlLCJ0ZXJtc09mVXNlQWNjZXB0ZWQiOnRydWUsInRlbmFudElkIjoiY2FhMjBiYzAtZWYwMC0xMWVlLTkwYjctMTM5OTdhYzcxYjdhIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.Y6rF6FU2saoDtaHS8FdYscavHWYptF9zxXQcykDrnA-BTYXNa12XQv9MGn6DTgQUP9nvFkStQy9BcIHsjpXEGA";
  final entityId = "928701f0-f6bc-11ee-ad9b-d5803676b938";
  final channel = IOWebSocketChannel.connect('ws://thingsboard.cloud/api/ws');

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
    var jsonResponse = jsonDecode(message);
    var deviceEntityId = jsonResponse['deviceId']; // ou outra chave que identifique o dispositivo
    print("Message is received from device: $deviceEntityId");
  });
  
  channel.sink.add(jsonEncode({
    "authCmd": {
      "cmdId": 0,
      "token": token,
    },
    "cmds": [
      {
        "entityType": "DEVICE",
        "entityId": entityId,
        "scope": "LATEST_TELEMETRY",
        "cmdId": 10,
        "type": "TIMESERIES",
        "keys": "energia",
      }
    ]
  }));
    //PASSO O SERIAL KEY
    channel.sink.add(jsonEncode({
    "authCmd": {
      "cmdId": 0,
      "token": token,
    },
    "cmds": [
      {
        "entityType": "DEVICE",
        "entityId": "c921a7b0-f6df-11ee-ad9b-d5803676b938",
        "scope": "LATEST_TELEMETRY",
        "cmdId": 20,
        "type": "TIMESERIES",
        "keys": "energia",
      }
    ]
  }));
  

  print("Message is sent");
}

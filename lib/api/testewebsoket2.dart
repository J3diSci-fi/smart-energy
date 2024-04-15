import 'dart:convert';
import 'package:web_socket_channel/io.dart';

void main() {
  final token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJub3JpZXRlY2FydmFsaG8xMkBnbWFpbC5jb20iLCJ1c2VySWQiOiJjYmM5OWJkMC1lZjAwLTExZWUtOTBiNy0xMzk5N2FjNzFiN2EiLCJzY29wZXMiOlsiVEVOQU5UX0FETUlOIl0sInNlc3Npb25JZCI6ImUxZThjNWQzLTdlNTMtNDRlYi05NmI1LTZlZThhMGUzZTQ5OCIsImlzcyI6InRoaW5nc2JvYXJkLmNsb3VkIiwiaWF0IjoxNzEyNzQ5NTIxLCJleHAiOjE3MTI3NzgzMjEsImZpcnN0TmFtZSI6Ikx1aXoiLCJsYXN0TmFtZSI6IkNhcnZhbGhvIiwiZW5hYmxlZCI6dHJ1ZSwiaXNQdWJsaWMiOmZhbHNlLCJpc0JpbGxpbmdTZXJ2aWNlIjpmYWxzZSwicHJpdmFjeVBvbGljeUFjY2VwdGVkIjp0cnVlLCJ0ZXJtc09mVXNlQWNjZXB0ZWQiOnRydWUsInRlbmFudElkIjoiY2FhMjBiYzAtZWYwMC0xMWVlLTkwYjctMTM5OTdhYzcxYjdhIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.Gykd7uETNKTfZNF5S_CtbIQHeboINfvwvZrJkpz_onKQdz4FyOndrHplHqunta6gTA-TAGmybtd67JELrtEqtQ";
  final devices = {
    "device1_id": "c921a7b0-f6df-11ee-ad9b-d5803676b938",
    "device2_id": "928701f0-f6bc-11ee-ad9b-d5803676b938"
  };
  final deviceUrl = 'ws://thingsboard.cloud/api/ws';

  final channels = devices.map((deviceId, _) {
    final channel = IOWebSocketChannel.connect(deviceUrl);
    channel.stream.listen((message) {
      print("Message from $deviceId: $message");
    });
    return MapEntry(deviceId, channel);
  });

  channels.forEach((deviceId, channel) {
    channel.sink.add(jsonEncode({
      "authCmd": {
        "cmdId": 0,
        "token": token,
      },
      "cmds": [
        {
          "entityType": "DEVICE",
          "entityId": deviceId,
          "scope": "LATEST_TELEMETRY",
          "cmdId": 10,
          "type": "TIMESERIES",
        }
      ]
    }));
  });

  // You can add more devices and channels as needed
}

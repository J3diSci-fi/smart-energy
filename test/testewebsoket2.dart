import 'dart:convert';
import 'package:web_socket_channel/io.dart';

void main() {
  final token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZW5hbnRAdGhpbmdzYm9hcmQub3JnIiwidXNlcklkIjoiZjhjYzQ0ZDAtMzk3OC0xMWVmLWIzYWYtNmQ3ZTc3ZTNkYTM3Iiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJzZXNzaW9uSWQiOiJjNTNhOGI5OS0zZDBhLTQ5M2EtOWJmMS0yNjA3MDJiNzQwOTEiLCJleHAiOjI3OTM3ODAxOTUsImlzcyI6InRoaW5nc2JvYXJkLmlvIiwiaWF0IjoxNzIwMDM4MzcyLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsInRlbmFudElkIjoiYzdkYjQ2ZjAtMzk3OC0xMWVmLWIzYWYtNmQ3ZTc3ZTNkYTM3IiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.Yw8VwsHc6w5PDX6NcxKZwAf_Un112fC_YdVrAyJSLov0C_8LVtpVy5vG3-vRk4xo1Y997yDjyc2LRYAQL0pzsA";
  final devices = {
    "device1_id": "c4ae95d0-3c9e-11ef-b3af-6d7e77e3da37"
  };
  final deviceUrl = 'ws://backend.smartenergy.smartrural.com.br/api/ws';

  final channels = devices.map((deviceId, _) {
    final channel = IOWebSocketChannel.connect(deviceUrl);
    channel.stream.listen((message) {
      print("Message from $deviceId: $message");
    });
    return MapEntry(deviceId, channel);
  });

  channels.forEach((deviceId, channel) {
    print("executou");
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

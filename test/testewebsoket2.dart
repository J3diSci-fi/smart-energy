import 'dart:convert';
import 'package:web_socket_channel/io.dart';

void main() {
  final token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0ZXNtYXJ0c21hcnQzMjlAZ21haWwuY29tIiwidXNlcklkIjoiNDViMDUyYzAtMTk1Ni0xMWVmLWEwM2QtMTczNWNhZDQzZTg3Iiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJzZXNzaW9uSWQiOiIyMWZjYmY1Mi05ZGI2LTRlY2ItYmZhMy0yOTY4NGExZGJkZDgiLCJpc3MiOiJ0aGluZ3Nib2FyZC5jbG91ZCIsImlhdCI6MTcxNzE1NjU5OSwiZXhwIjoxNzE3MTg1Mzk5LCJmaXJzdE5hbWUiOiJ0ZXN0ZXNtYXJ0IiwibGFzdE5hbWUiOiJzbWFydCIsImVuYWJsZWQiOnRydWUsImlzUHVibGljIjpmYWxzZSwiaXNCaWxsaW5nU2VydmljZSI6ZmFsc2UsInByaXZhY3lQb2xpY3lBY2NlcHRlZCI6dHJ1ZSwidGVybXNPZlVzZUFjY2VwdGVkIjp0cnVlLCJ0ZW5hbnRJZCI6IjQ0NzAwYTkwLTE5NTYtMTFlZi1hMDNkLTE3MzVjYWQ0M2U4NyIsImN1c3RvbWVySWQiOiIxMzgxNDAwMC0xZGQyLTExYjItODA4MC04MDgwODA4MDgwODAifQ.A15_VK3_VCN_JLJX30soJF8B_NgRnUxq2HArwNYZgar6uYSEKW5A-yqtGeyjy60vWxrZV5gtJ-cxcb3l_-Q4XA";
  final devices = {
    "device1_id": "320",
    "device2_id": "320"
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
    print("executou");
    channel.sink.add(jsonEncode({
      "authCmd": {
        "cmdId": 0,
        "token": token,
      },
      "cmds": [
        {
          "entityType": "DEVICE",
          "entityId": 320,
          "scope": "LATEST_TELEMETRY",
          "cmdId": 10,
          "type": "TIMESERIES",
        }
      ]
    }));
  });

  // You can add more devices and channels as needed
}

import 'dart:convert';
import 'package:web_socket_channel/io.dart';

void main() {
  final token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzbWFydGVuZXJneS4wMzNAZ21haWwuY29tIiwidXNlcklkIjoiYjJhNTdkZjAtMDRkNS0xMWVmLWFjNjQtYzFmMjE0Yzk3NzI4Iiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJzZXNzaW9uSWQiOiIyM2IxMjNjNS0yNGU1LTQ5ODQtOGJmZS1jMTYwYzczMGFlZjkiLCJpc3MiOiJ0aGluZ3Nib2FyZC5jbG91ZCIsImlhdCI6MTcxNDY1NDA1NCwiZXhwIjoxNzE0NjgyODU0LCJmaXJzdE5hbWUiOiJTbWFydEVuZXJneSIsImxhc3ROYW1lIjoiU21hcnRFbmVyZ3kiLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsImlzQmlsbGluZ1NlcnZpY2UiOmZhbHNlLCJwcml2YWN5UG9saWN5QWNjZXB0ZWQiOnRydWUsInRlcm1zT2ZVc2VBY2NlcHRlZCI6dHJ1ZSwidGVuYW50SWQiOiJiMTlkZDFmMC0wNGQ1LTExZWYtYWM2NC1jMWYyMTRjOTc3MjgiLCJjdXN0b21lcklkIjoiMTM4MTQwMDAtMWRkMi0xMWIyLTgwODAtODA4MDgwODA4MDgwIn0.kVeuePTwaUT5XtPdRqa1Knzb-B1TXFZK-yLD7vuGweQ9f-l1MmPlZwclU403n2czvW_F4bgMoIGMOS3A1wILCA";
  final entityId = "10afef00-06fe-11ef-ac64-c1f214c97728";
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
    "scope": "LATEST_TELEMETRY ",
    "cmdId": 500,
    "type": "TIMESERIES",
    "keys": "numero, energia,saldo"
    
  }
  ]
  }));
    

  print("Message is sent");
}

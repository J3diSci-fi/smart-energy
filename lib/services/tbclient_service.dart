import 'package:http/http.dart' as http;
import 'package:smartenergy_app/api/api_cfg.dart';
import 'dart:convert';
import 'package:smartenergy_app/services/Customer_info.dart';
import 'package:smartenergy_app/services/tbStorage.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

const thingsBoardApiEndpoint = 'https://thingsboard.cloud';

class ThingsBoardService {
  var tbClient = ThingsboardClient(thingsBoardApiEndpoint);
  TbSecureStorage tbSecureStorage = TbSecureStorage();
  bool _isLoggedIn = false;

  ThingsBoardService();

  Future<void> initialize() async {
    await _login();  // Aguarda o login ser concluído
  }

  Future<void> _login() async {
    await tbClient.login(LoginRequest('testesmartsmart329@gmail.com', 'sistema1999'));
    _isLoggedIn = true;
  }

  Future<bool> isLoggedIn() async {
    return _isLoggedIn;
  }

  String? getToken() {
    return tbClient.getJwtToken();
  }

  Future<void> renewTokenIfNeeded() async {
    if (!tbClient.isJwtTokenValid()) {
        // Se o token de acesso estiver expirado, renovamos usando o refresh token
        await tbClient.refreshJwtToken();
        Config.token = getToken()!;
        
    }
    
}
  String getIdTenant() {
    return tbClient.getAuthUser()!.tenantId;
  }

  void editarDevice(String nome, String id_device, String descricao, String serial, String data) async {
    await renewTokenIfNeeded();
    String url = 'https://thingsboard.cloud:443/api/device';
    String token = Config.token;
    String tenantId = tbClient.getAuthUser()!.tenantId;
    String? customer_id = CustomerInfo.idCustomer;

    Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Authorization': 'Bearer $token',
    };

    Map<String, dynamic> body = {
      "id": {"id": id_device, "entityType": "DEVICE"},
      "tenantId": {"id": tenantId, "entityType": "TENANT"},
      "customerId": {"id": customer_id, "entityType": "CUSTOMER"},
      "ownerId": {"id": customer_id, "entityType": "CUSTOMER"},
      "name": nome,
      "type": "default",
      "label": "SmartEnergy",
      "deviceData": {
        "configuration": {"type": "DEFAULT"},
        "transportConfiguration": {"type": "DEFAULT"}
      },
      "additionalInfo": {
        "description": descricao,
        "serialKey": serial,
        "data": data
      }
    };

    String jsonBody = jsonEncode(body);

    http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<bool> verificar_serialKey(String serial) async {
    await renewTokenIfNeeded();
    final String url = '${Config.apiUrl}/user/devices?pageSize=1000&page=0';
    final Map<String, String> headers = {
      'accept': 'application/json',
      'X-Authorization': 'Bearer ${Config.token}'
    };
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      print('Requisição bem-sucedida!');
      final data = json.decode(response.body);
      final devices = data['data'];

      // Verifica se a lista de dispositivos está vazia
      if (devices.isEmpty) {
        return false;
      }

      for (var device in devices) {
        if (device.containsKey('additionalInfo') &&
            device['additionalInfo'] is Map &&
            device['additionalInfo'].containsKey('serialKey')) {
          final serialKey = device['additionalInfo']['serialKey'];
          print("Serial Key: $serialKey, Serial: $serial");

          if (serialKey.trim() == serial.trim()) {
            return true;
          }
        }
      }
      return false; // Retorna false se não encontrar o serialKey
    } else {
      print(
          'Erro ao fazer a solicitação. Código de status: ${response.statusCode}');
      return false; // Retorna false em caso de erro
    }
  }

  Future<String> cadastrarDevice(String nome, String descricao, String serial_key, String data) async {
    await renewTokenIfNeeded();
    final url = Uri.parse('https://thingsboard.cloud/api/device-with-credentials');
    String token = Config.token;
    String tenantId = tbClient.getAuthUser()!.tenantId;
    String? customer_id = CustomerInfo.idCustomer;
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "device": {
        "tenantId": {"id": tenantId, "entityType": "TENANT"},
        "customerId": {
          "id": customer_id,
          "entityType": "CUSTOMER"
        },
        "ownerId": {"id": customer_id, "entityType": "CUSTOMER"},
        "name": nome,
        "type": "default",
        "label": "SmartEnergy",
        "deviceData": {
          "configuration": {"type": "DEFAULT"},
          "transportConfiguration": {"type": "DEFAULT"}
        },
        "additionalInfo": {
          "description": descricao,
          "serialKey": serial_key,
          "data": data
        }
      },
      "credentials": {
        "credentialsType": "MQTT_BASIC",
        "credentialsValue":
            "{\"clientId\":\"$serial_key\",\"userName\":\"$serial_key\",\"password\":\"$serial_key\"}"
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
        //setOwnerDevice(device_id);
        return device_id;
      } else {
        print(
            'Erro ao cadastrar dispositivo. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao realizar a requisição: $e');
    }
    return "erro";
  }
}

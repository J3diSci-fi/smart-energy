import 'package:http/http.dart' as http;
import 'package:smartenergy_app/api/api_cfg.dart';
import 'dart:convert';
import 'package:smartenergy_app/services/Customer_info.dart';
import 'package:smartenergy_app/services/tbStorage.dart';

class ThingsBoardService {
  static TbSecureStorage tbSecureStorage = TbSecureStorage();

  ThingsBoardService();

  void editarDevice(String nome, String id_device, String descricao,
      String serial, String data) async {
    String url = '${Config.apiUrl}/device';
    String token = Config.token;
    String? customer_id = CustomerInfo.idCustomer;

    Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Authorization': 'Bearer $token',
    };

    Map<String, dynamic> body = {
      "id": {"id": id_device, "entityType": "DEVICE"},
      "customerId": {"id": customer_id, "entityType": "CUSTOMER"},
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

    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: jsonBody);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> deleteDevice(String id) async {
    final String url = '${Config.apiUrl}/device/$id';
    final Map<String, String> headers = {
      'accept': 'application/json',
      'X-Authorization': 'Bearer ${Config.token}'
    };
    final uri = Uri.parse(url);
    final response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      print('Deletado com sucesso');
    } else {
      print("erro ao deletar");
    }
  }

  Future<void> unassigndevice(String deviceId) async {
    final url = Uri.parse('${Config.apiUrl}/customer/device/$deviceId');

    final response = await http.delete(
      url,
      headers: {
        'accept': 'application/json',
        'X-Authorization': 'Bearer ${Config.token}',
      },
    );

    if (response.statusCode == 200) {
      print('Dispositivo removido com sucesso!');
    } else {
      print('Falha ao remover dispositivo: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<String> cadastrarDevice(
      String nome, String descricao, String serial_key, String data) async {
    final url = Uri.parse('${Config.apiUrl}/device-with-credentials');
    String token = Config.token;
    String tenantId = Config.tenantId;
    String? customer_id = CustomerInfo.idCustomer;
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "device": {
        "tenantId": {"id": tenantId, "entityType": "TENANT"},
        "customerId": {"id": customer_id, "entityType": "CUSTOMER"},
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

  Future<String?> existeDevice(String serialKey) async {
  final url = Uri.parse('${Config.apiUrl}/tenant/devices?pageSize=1000&page=0');
  final headers = {
    'accept': 'application/json',
    'X-Authorization': 'Bearer ${Config.token}',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Verifica se data['data'] é null
      if (data['data'] == null) {
        print('existe device: Nenhum dispositivo encontrado.');
        return null;
      }

      for (var device in data['data']) {
        if (device['additionalInfo']['serialKey'].contains(serialKey)) {
          return device['id']['id'];
        }
      }
    } else {
      print('existe device: Erro na requisição. Código de status: ${response.statusCode}');
    }
  } catch (e) {
    print('existe device: Erro ao realizar a requisição: $e');
  }

  return null; // Retorna null se não encontrar o dispositivo
}
}
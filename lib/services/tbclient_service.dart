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
  
  ThingsBoardService() {
      _login();
 
  }
  Future<void> _login() async {
    await tbClient.login(LoginRequest('norietecarvalho12@gmail.com', 'sistema1999'));
    _isLoggedIn = true;
    
  }

  Future<bool> isLoggedIn() async {
    return _isLoggedIn;
  }
  ThingsboardClient  getTbClient(){
    return tbClient;
  }
  
  String? getToken(){
    return tbClient.getJwtToken();
  }

  void editarDevice(String nome, String id_device, String descricao, String serial, String data) async {
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
    "id": {
      "id": id_device,
      "entityType": "DEVICE"
    },
    "tenantId": {
      "id": tenantId,
      "entityType": "TENANT"
    },
    "customerId": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
    "ownerId": {
      "id": customer_id,
      "entityType": "CUSTOMER"
    },
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
Future<bool> verificar_serialKey(String serial) async{
  final String url = '${Config.apiUrl}/user/devices?pageSize=1000&page=0';
  final Map<String, String> headers = {
    'accept': 'application/json',
    'X-Authorization':
        'Bearer ${Config.token}'
  };
  final uri = Uri.parse(url);
  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    print('Requisição bem-sucedida!');
    final data = json.decode(response.body);
    final dados = data['data'];
    
    for (var devices in dados) {
      final serial_Key = devices['additionalInfo']['serialKey'];
      print("Printando o serial_key: $serial_Key , printando o serial: $serial");
      if(serial_Key.trim() == serial.trim()){
        return true;
      }
    }
    return false;
  } else {
    print('Erro ao fazer a solicitação. Código de status: ${response.statusCode}');
    return false; // Retorna null em caso de erro
  }
}

  Future<String> adicionarDevice(String nome, String descricao, String serialKey, String data) async{
    var device = Device(nome,'default');
    device.additionalInfo = {'description': descricao, 'serialKey': serialKey, 'data': data};
    String? id = CustomerInfo.idCustomer;
    print("Printando o id do customer que foi associado ao device:$id");
    EntityId customerId = CustomerId(id ?? 'default_value');
    device.setOwnerId(customerId);
    Device savedDevice = await tbClient.getDeviceService().saveDevice(device);
  
  // Convertendo o ID do dispositivo para uma string
    String deviceId = savedDevice.id?.id ?? 'N/A';
    return deviceId;
    
  }


  
}
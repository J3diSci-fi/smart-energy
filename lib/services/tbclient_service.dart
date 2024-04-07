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

  void editarDevice(String nome, String id_device, String descricao, String mac, String serial, String data) async {
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
      "mac": mac,
      "serialKey": serial,
      "data": data
    }
  };

  String jsonBody = jsonEncode(body);

  http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  
  }

  Future<String> adicionarDevice(String nome, String descricao, String mac, String serialKey, String data) async{
    var device = Device(nome,'default');
    device.additionalInfo = {'description': descricao,'mac': mac, 'serialKey': serialKey, 'data': data};
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
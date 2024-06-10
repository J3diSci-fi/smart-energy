
import 'package:thingsboard_pe_client/thingsboard_client.dart';
//import 'package:thingsboard_pe_client/thingsboard_client.dart';

const thingsBoardApiEndpoint = 'https://thingsboard.cloud';

void main(List<String> args) async {
  var tbClient = ThingsboardClient(thingsBoardApiEndpoint);
  await tbClient.login(LoginRequest('smartenergy.033@gmail.com', 'smartenergy1999'));
  print(tbClient.isAuthenticated());

  var device1 = Device("feio2",'default');
  device1.additionalInfo = {'description': 'My test device!'};
  EntityId customerId = CustomerId("9943e910-10be-11ef-bf1e-eb47e687e405");
  //device1.setOwnerId(customerId);
  var savedDevice = await tbClient.getDeviceService().saveDevice(device1);
  String deviceId = savedDevice.id?.id ?? 'N/A';
  print(deviceId);
  await tbClient.getDeviceService().assignDeviceToTenant("9943e910-10be-11ef-bf1e-eb47e687e405", deviceId);
 
    

  //String groupId = '20b0f800-f1fe-11ee-b150-512e216ea414'; // Substitua pelo ID do grupo desejado
  //tbClient.getAlarmService().getAlarmInfo(alarmId)
  // Criar um cliente com o grupo correto
  //CustomerImpl newCustomer = CustomerImpl('New Customer', groupId);

  // Salvar o novo cliente
  //tbClient.getCustomerService().saveCustomer(newCustomer);
}

class CustomerImpl extends Customer {
  String title;
  String groupId;

  CustomerImpl(this.title, this.groupId) : super('');

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['title'] = title;
    json['groupId'] = groupId;
    return json;
  }
}

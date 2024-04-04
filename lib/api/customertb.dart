import 'package:thingsboard_pe_client/thingsboard_client.dart';

const thingsBoardApiEndpoint = 'https://thingsboard.cloud';

void main(List<String> args) async {
  var tbClient = ThingsboardClient(thingsBoardApiEndpoint);
  await tbClient.login(LoginRequest('norietecarvalho12@gmail.com', 'sistema1999'));
  print(tbClient.isAuthenticated());

  String groupId = '20b0f800-f1fe-11ee-b150-512e216ea414'; // Substitua pelo ID do grupo desejado
  //tbClient.getAlarmService().getAlarmInfo(alarmId)
  // Criar um cliente com o grupo correto
  CustomerImpl newCustomer = CustomerImpl('New Customer', groupId);

  // Salvar o novo cliente
  tbClient.getCustomerService().saveCustomer(newCustomer);
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

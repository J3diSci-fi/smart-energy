import 'package:thingsboard_pe_client/thingsboard_client.dart';
const thingsBoardApiEndpoint = 'https://thingsboard.cloud';
void main(List<String> args) async {
  try {
    // Create instance of ThingsBoard API Client
    var tbClient = ThingsboardClient(thingsBoardApiEndpoint);

    // Perform login with default Tenant Administrator credentials
    await tbClient.login(LoginRequest('norietecarvalho12@gmail.com', 'sistema1999'));
    print(tbClient.getJwtToken());
    print('isAuthenticated=${tbClient.isAuthenticated()}');

    //Customer? customer = await tbClient.getCustomerService().getCustomer("57a85cc0-e639-11ee-bf71-bd1e2ee8c819");
   // print(customer?.getEntityType());
    
    
    //Device? device = await tbClient.getDeviceService().getDevice("5d4ca6d0-ee46-11ee-ad30-b74a0679875d");
    //print(device?.id);
    //print(device?.additionalInfo);
    //device?.customerId = customer?.id;
    //await tbClient.getDeviceService().saveDevice(device!, accessToken: tbClient.getJwtToken());
    
    //var device1 = Device("luizinho",'default');
   // device1.additionalInfo = {'description': 'My test device!'};
    //EntityId customerId = CustomerId("57a85cc0-e639-11ee-bf71-bd1e2ee8c819");
    //device1.setOwnerId(customerId);
    //var savedDevice = await tbClient.getDeviceService().saveDevice(device1);
    //device1.setOwnerId(customerId);
   // print(device1.getId());
    



    // Finally perform logout to clear credentials
    //await tbClient.logout();
  } catch (e, s) {
    print('Error: $e');
    print('Stack: $s');
  }
  
}
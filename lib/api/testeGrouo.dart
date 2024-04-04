import 'package:thingsboard_pe_client/thingsboard_client.dart';
import 'dart:convert';

const thingsBoardApiEndpoint = 'https://thingsboard.cloud';

void main(List<String> args) async {
  var tbClient = ThingsboardClient(thingsBoardApiEndpoint);
  await tbClient.login(LoginRequest('norietecarvalho12@gmail.com', 'sistema1999'));
  print(tbClient.isAuthenticated());

  //EntityGroup entityGroup = EntityGroup("SmartEnergy1", EntityType.CUSTOMER);
  //tbClient.getEntityGroupService().saveEntityGroup(entityGroup);
  //entityGroup.setId(EntityGroupId("10-10"));
  //print(entityGroup.getId());
 // print(entityGroup.name);
  //print(entityGroup.id);
 // print(entityGroup.ownerId);
  //print(tbClient.getEntityGroupService().getEntityGroup("10-10"));
  Customer newCustomer = Customer('New Customer');
 //newCustomer.setOwnerId(EntityId(EntityType.ENTITY_GROUP, groupId));

  // Salvar o novo cliente
  
  //tbClient.getCustomerService.;


  
  
 


  String customerId = '737c0f20-ef01-11ee-90b7-13997ac71b7a'; // Substitua 'id_do_customer' pelo ID real do customer
  String groupId = '45697f00-f1f4-11ee-88df-b960303de751'; // Substitua 'id_do_grupo' pelo ID real do grupo

 // EntityGroupService entityGroupService = EntityGroupService(tbClient);

  // Adicione o customer ao grupo
  //await entityGroupService.addEntitiesToEntityGroup(groupId, [customerId]);

}




import 'package:smartenergy_app/api/api_cfg.dart';

import 'package:thingsboard_pe_client/thingsboard_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

const thingsBoardApiEndpoint = 'https://demo.thingsboard.io';

Future<dynamic> getAllCustomers(String token) async {
  final String url = '${Config.apiUrl}/customers?pageSize=1000&page=0';
  final Map<String, String> headers = {
    'accept': 'application/json',
    'X-Authorization': 'Bearer ${token}'
  };

  final uri = Uri.parse(url);
  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    print('Requisição bem-sucedida!');
    final data = json.decode(response.body);
    return data;
  } else {
    print(
        'Erro ao fazer a solicitação. Código de status: ${response.statusCode}');
    return null; // Retorna null em caso de erro
  }
}

Future<void> verifyToken(ThingsboardClient tbClient) async {
  if (!tbClient.isJwtTokenValid()) {
    var teste = tbClient.isJwtTokenValid();
    print("Token não é valido: $teste");
    await getAllCustomers(tbClient.getRefreshToken().toString());
    var token = tbClient.getJwtToken();
    print("Token depois do refresh: $token ");
  }
  else{
     var teste2 = tbClient.isJwtTokenValid();
    print("Token é valido! $teste2");
  }
}
void main(List<String> args) async {
  //String token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJub3JpZXRlY2FydmFsaG8xMkBnbWFpbC5jb20iLCJ1c2VySWQiOiJjYmM5OWJkMC1lZjAwLTExZWUtOTBiNy0xMzk5N2FjNzFiN2EiLCJzY29wZXMiOlsiVEVOQU5UX0FETUlOIl0sInNlc3Npb25JZCI6IjNkMTk2NGMwLTI1NzItNDMzOS04Mjc0LWIyZDEyYTQ0NmRiNSIsImlzcyI6InRoaW5nc2JvYXJkLmNsb3VkIiwiaWF0IjoxNzEyNDQwODczLCJleHAiOjE3MTI0Njk2NzMsImZpcnN0TmFtZSI6Ikx1aXoiLCJsYXN0TmFtZSI6IkNhcnZhbGhvIiwiZW5hYmxlZCI6dHJ1ZSwiaXNQdWJsaWMiOmZhbHNlLCJpc0JpbGxpbmdTZXJ2aWNlIjpmYWxzZSwicHJpdmFjeVBvbGljeUFjY2VwdGVkIjp0cnVlLCJ0ZXJtc09mVXNlQWNjZXB0ZWQiOnRydWUsInRlbmFudElkIjoiY2FhMjBiYzAtZWYwMC0xMWVlLTkwYjctMTM5OTdhYzcxYjdhIiwiY3VzdG9tZXJJZCI6IjEzODE0MDAwLTFkZDItMTFiMi04MDgwLTgwODA4MDgwODA4MCJ9.xAYZTFxMScQ5MsaPnAB9FbmSCB1o2daMRZggo_p8m2Ub2CQSSc3qrXIs-w04G1tDLaNRQiumvwPI-OvxX0Z3yg";
  var tbClient = ThingsboardClient(thingsBoardApiEndpoint);
  await tbClient.login(LoginRequest('smartenergy.039@gmail.com', 'smartenergy2024'));
  print(tbClient.isAuthenticated());
  print(tbClient.getJwtToken());
  //tbClient.refreshJwtToken();
  //print(tbClient.getAuthUser()!.tenantId);
  //print(tbClient.isJwtTokenValid());

 // print(tbClient.getJwtToken());
  //print(tbClient.refreshJwtToken());

 // print(tbClient.getJwtToken());

  //Timer.periodic(Duration(milliseconds: 300000), (Timer t) async {
   // await verifyToken(tbClient);
 //});
 // verifyToken(tbClient);
 // print(tbClient.getRefreshToken());
  //print(tbClient.getJwtToken());
 

  //EntityGroup entityGroup = EntityGroup("SmartEnergy1", EntityType.CUSTOMER);
  //tbClient.getEntityGroupService().saveEntityGroup(entityGroup);
  //entityGroup.setId(EntityGroupId("10-10"));
  //print(entityGroup.getId());
 // print(entityGroup.name);
  //print(entityGroup.id);
 // print(entityGroup.ownerId);
  //print(tbClient.getEntityGroupService().getEntityGroup("10-10"));
 // Customer newCustomer = Customer('New Customer');
 //newCustomer.setOwnerId(EntityId(EntityType.ENTITY_GROUP, groupId));

  // Salvar o novo cliente
  
  //tbClient.getCustomerService.;


  
  
 


  //String customerId = '737c0f20-ef01-11ee-90b7-13997ac71b7a'; // Substitua 'id_do_customer' pelo ID real do customer
  //String groupId = '45697f00-f1f4-11ee-88df-b960303de751'; // Substitua 'id_do_grupo' pelo ID real do grupo

 // EntityGroupService entityGroupService = EntityGroupService(tbClient);

  // Adicione o customer ao grupo
  //await entityGroupService.addEntitiesToEntityGroup(groupId, [customerId]);

}




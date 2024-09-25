
//import 'package:thingsboard_pe_client/thingsboard_client.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
main() async {
    try {
      final thingsBoardApiEndpoint = 'https://backend.smartenergy.smartrural.com.br';
      var tbClient = ThingsboardClient(thingsBoardApiEndpoint);
      await tbClient.login(LoginRequest('tenant@thingsboard.org', 'dSyHKH3rsxnzUm^gR@1o'));

      print('isAuthenticated=${tbClient.isAuthenticated()}');

      print('authUser: ${tbClient.getAuthUser()}');

     // var currentUserDetails = await tbClient.getUserService().getUser();
     // print('currentUserDetails: $currentUserDetails');

     // await tbClient.logout();

    } catch (e, s) {
        print('Error: $e');
        print('Stack: $s');
    }
}
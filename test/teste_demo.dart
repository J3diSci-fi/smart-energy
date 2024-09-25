
//import 'package:thingsboard_pe_client/thingsboard_client.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
main() async {
    try {
      var tbClient = ThingsboardClient('https://demo.thingsboard.io');
      await tbClient.login(LoginRequest('smartenergy.039@gmail.com', 'smartenergy2024'));

      print('isAuthenticated=${tbClient.isAuthenticated()}');

      print('authUser: ${tbClient.getAuthUser()}');

      var currentUserDetails = await tbClient.getUserService().getUser();
      print('currentUserDetails: $currentUserDetails');

      await tbClient.logout();

    } catch (e, s) {
        print('Error: $e');
        print('Stack: $s');
    }
}
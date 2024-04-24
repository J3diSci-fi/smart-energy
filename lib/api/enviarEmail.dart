import 'dart:convert';

import 'package:http/http.dart' as http;

Future <bool> sendEmail(String client_email, String login, String senha) async{
  final service_id = "service_h9kuzxt";
  final templateId = "template_2sftte6";
  final userId = "P9ZkyGOdmNuwxNjqR";
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  final response = await http.post(
  url,
  headers: {
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'service_id':service_id,
    'template_id': templateId,
    'user_id': userId,
    'template_params': {
        'user_email': client_email,
        'client_email':client_email,
        "message": "Seu login é: $login e sua senha é: $senha",
       
    }
  
  }),
  );
  if(response.statusCode == 200){
    return true;
  }
  else{
    return false;
  }
}



void main(List<String> args) {
 
  
}
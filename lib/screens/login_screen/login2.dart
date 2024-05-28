import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/api/api_costumers_controller.dart';
import 'package:smartenergy_app/api/firebase_api.dart';
import 'package:smartenergy_app/screens/login_screen/cadastro2.dart';
import 'package:smartenergy_app/screens/recuperarsenha/recuperarsenha.dart';
import 'package:smartenergy_app/services/Customer_info.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';

class Login2 extends StatefulWidget {
  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    ThingsBoardService thingsBoardService = Provider.of<ThingsBoardService>(context);
    Config.token = thingsBoardService.getToken()!;
    FirebaseApi firebaseApi = Provider.of<FirebaseApi>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
    },
    child: Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            top: -200, // Ajuste aqui para a posição vertical da imagem
            child: Image.asset(
              'assets/welcome.png',
              fit: BoxFit.none,
            ),
          ),
          Align(
            alignment: Alignment
                .topCenter, // Ajuste aqui para alinhar o conteúdo ao topo
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Color(0xFF1976D2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                          labelText: "Usuário",
                          enabledBorder: InputBorder.none,
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText, // Oculta ou mostra a senha
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.vpn_key,
                            color: Color(0xFF1976D2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                          labelText: "Senha",
                          enabledBorder: InputBorder.none,
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecuperarSenha()),
                            ); // Navegar para a tela de cadastro
                          },
                          child: Text(
                            "Esqueceu sua Senha?",
                            style: TextStyle(
                              color: Color(0xFF1976D2),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 30),
                      width: MediaQuery.of(context).size.width * 2,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            if (_usernameController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              await thingsBoardService.renewTokenIfNeeded();
                              dynamic customer = await verifyLoginAndPassword(
                                _usernameController.text,
                                _passwordController.text,
                              );
                              if (customer != null) {
                                var user = customer['id']['id'];
                                var telefone = customer['phone'];
                                var email = customer['email'];
                                var nome = customer['title'];
                                var telefone1 = customer['additionalInfo']['telefone1'];
                                var telefone2 = customer['additionalInfo']['telefone2'];
                                CustomerInfo.idCustomer = user;
                                thingsBoardService.tbSecureStorage
                                    .setItem("login", _usernameController.text);
                                thingsBoardService.tbSecureStorage
                                    .setItem("senha", _passwordController.text);
                                thingsBoardService.tbSecureStorage
                                    .setItem("id_customer", user);
                                thingsBoardService.tbSecureStorage
                                    .setItem("telefone", telefone);
                                thingsBoardService.tbSecureStorage
                                    .setItem("telefone1", telefone1);
                                thingsBoardService.tbSecureStorage
                                    .setItem("telefone2", telefone2);
                                thingsBoardService.tbSecureStorage
                                    .setItem("email", email);
                                thingsBoardService.tbSecureStorage
                                    .setItem("nome", nome);
                                firebaseApi.subscribeCustomerIdTopic(user);
                                Navigator.pushNamed(context, '/profile');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Usuario Inválido!')));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Por favor, preencha todos os campos.')));
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.amber,
                          child: Center(
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Não tem uma conta?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CadastroScreen2()),
                            ); // Navegar para a tela de cadastro
                          },
                          child: Text(
                            "Criar",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64B5F6),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
   );
  }
}

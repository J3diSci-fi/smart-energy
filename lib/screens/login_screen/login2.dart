import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                height: 340, // Ajuste a altura conforme necessário
               
              ),
            ),
          ),
          Align(
            alignment: Alignment.center, // Centralizar o conteúdo
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 220), // Ajuste a margem superior conforme necessário
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
                    SizedBox(height: 20), // Espaçamento entre os campos
                    Container(
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
                              _obscureText ? Icons.visibility : Icons.visibility_off,
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
                        margin: EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecuperarSenha()),
                            );
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
                      margin: EdgeInsets.only(top: 20, bottom: 30),
                      width: double.infinity,
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
                            if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                              dynamic customer = await verifyLoginAndPassword(
                                _usernameController.text,
                                _passwordController.text,
                              );
                              if (customer != null) {
                                var user = customer['id']['id'];
                                CustomerInfo.idCustomer = user;
                                ThingsBoardService.tbSecureStorage.setItem("login", _usernameController.text);
                                ThingsBoardService.tbSecureStorage.setItem("senha", _passwordController.text);
                                ThingsBoardService.tbSecureStorage.setItem("id_customer", user);
                                
                                firebaseApi.subscribeCustomerIdTopic(user);
                                Navigator.pushNamed(context, '/profile');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário Inválido!')));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, preencha todos os campos.')));
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
                              MaterialPageRoute(builder: (context) => CadastroScreen2()),
                            );
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
    )
  );
  }
}
   
 
import 'package:flutter/material.dart';
import 'package:smartenergy_app/api/api_costumers_controller.dart';
import 'package:smartenergy_app/api/api_devices_controller.dart';
import 'package:smartenergy_app/screens/login_screen/cadastro.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 75),
                  // Adiciona a imagem acima do campo de usuário
                  Image.asset(
                    'assets/login/camarao.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      dynamic user = await verifyLoginAndPassword(
                        _usernameController.text,
                        _passwordController.text,
                      );
                      if (user != null) {
                        Navigator.pushNamed(context, '/profile');
                        print(user);
                        List<dynamic> dispositivos = await getDispositivos(user);
                        for (var dispositivo in dispositivos) {
                          final id = dispositivo['id']['id'];
                          final name = dispositivo['name'];
                          final label = dispositivo['label'];

                          print('ID: $id, Name: $name, Label: $label');
                        }
                      }else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Usuário inválido'),
                          ),
                        );
                      }
                    },
                    child: Text('Entrar'),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroScreen()), // Navega para a tela de cadastro
                  );//Navegar para a tela de cadastro
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Cadastrar-se',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

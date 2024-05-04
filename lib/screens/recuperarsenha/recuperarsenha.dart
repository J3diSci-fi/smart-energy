import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartenergy_app/api/api_costumers_controller.dart';

class RecuperarSenha extends StatefulWidget {
  @override
  _RecuperarSenha createState() => _RecuperarSenha();
}

class _RecuperarSenha extends State<RecuperarSenha> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
        backgroundColor: Color(0xFFEEEEEE),
      ),
      backgroundColor: Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Email",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
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
                      if (_validateFields()) {
                        _cadastrar(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Por favor, preencha todos os campos!')));
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.amber,
                    child: Center(
                      child: Text(
                        "Confirmar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fechar a tela de cadastro
                },
                child: Text('Fechar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    return _emailController.text.isNotEmpty;
  }

  void _cadastrar(BuildContext context) async {
    final String email = _emailController.text;
    bool emailExiste = await verificarEmail(email);
    if (emailExiste) {
      final Map<String, String> dados = await retornarLoginSenha(email);
      if (dados.isNotEmpty) {
        final String? login = dados['login'];
        final String? senha = dados['senha'];

        bool requesicao = await sendEmail(email, login!, senha!);
        if (requesicao) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sucesso!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(height: 8),
                  Text('Verifique seu email para mais informações!'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao enviar email!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email não encontrado!')),
      );
    }
  }
}

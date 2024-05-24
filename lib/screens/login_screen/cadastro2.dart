import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/api/api_costumers_controller.dart';
import 'package:smartenergy_app/services/tbclient_service.dart'; // Para usar TextInputType.numberWithOptions

class CadastroScreen2 extends StatefulWidget {
  @override
  _CadastroScreen2 createState() => _CadastroScreen2();
}

class _CadastroScreen2 extends State<CadastroScreen2> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
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
                  controller: _loginController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Login",
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
                  controller: _senhaController,
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
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _confirmaSenhaController,
                  obscureText: _obscureText2, // Oculta ou mostra a senha
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.vpn_key,
                      color: Color(0xFF1976D2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Confirmar Senha",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "E-mail",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.phone,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Telefone",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _cepController,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.location_on,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Cep",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _estadoController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.flag,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Estado",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _cidadeController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.location_city,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Cidade",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _enderecoController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.home,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Endereço",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _complementoController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.note,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Complemento",
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
                                Text('Por favor, preencha todos os campos.')));
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
    return _loginController.text.isNotEmpty &&
        _senhaController.text.isNotEmpty &&
        _confirmaSenhaController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _telefoneController.text.isNotEmpty &&
        _estadoController.text.isNotEmpty &&
        _cidadeController.text.isNotEmpty &&
        _enderecoController.text.isNotEmpty &&
        _cepController.text.isNotEmpty;
  }

  void _cadastrar(BuildContext context) async {
    ThingsBoardService thingsBoardService = Provider.of<ThingsBoardService>(context, listen: false);
    await thingsBoardService.renewTokenIfNeeded();
    final String email = _emailController.text;
    bool emailExiste = await verificarEmail(email);
    
    if (!emailExiste) {
      try {
        final int statusCode = await criarCustomer(
          login: _loginController.text,
          senha: _senhaController.text,
          email: _emailController.text,
          telefone: _telefoneController.text,
          cep: _cepController.text,
          estado: _estadoController.text,
          cidade: _cidadeController.text,
          endereco: _enderecoController.text,
          complemento: _complementoController.text,
          id_owner: thingsBoardService.getIdTenant()
         
        );

        if (statusCode == 200) {
          // Exibir AlertDialog com sucesso
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sucesso'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 40),
                  SizedBox(height: 8),
                  Text('$email\nCadastrado com sucesso!'),
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
        } else if (statusCode == 403 || statusCode == 400) {
          // Exibir Snackbar com a mensagem de usuário já cadastrado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuário já cadastrado (login em uso)!')),
          );
        }
      } catch (e) {
        print('Erro ao realizar a requisição: $e');
        // Exibir AlertDialog com erro
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 40),
                SizedBox(height: 8),
                Text('Erro ao cadastrar usuário!'),
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
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Email já cadastrado. Por favor, tente com um email diferente!')),
      );
    }
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = _formatTelefone(newValue.text);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatTelefone(String text) {
    final numbers = text.replaceAll(
        RegExp(r'\D'), ''); // Remove todos os caracteres não numéricos
    final length = numbers.length;
    if (length <= 2) {
      return '($numbers'; // Adiciona o '(' após os dois primeiros dígitos
    } else if (length <= 6) {
      return '(${numbers.substring(0, 2)})${numbers.substring(2)}'; // Adiciona o ')' após os dois dígitos seguintes
    } else if (length <= 11) {
      return '(${numbers.substring(0, 2)})${numbers.substring(2, 7)}-${numbers.substring(7, 11)}'; // Adiciona o '-' após o sexto dígito
    } else {
      return '(${numbers.substring(0, 2)})${numbers.substring(2, 7)}-${numbers.substring(7, 11)}'; // Mantém apenas os primeiros 11 dígitos
    }
  }
}

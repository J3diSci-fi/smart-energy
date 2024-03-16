import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartenergy_app/api/api_costumers_controller.dart'; // Para usar TextInputType.numberWithOptions

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CadastroScreen(),
    );
  }
}

class CadastroScreen extends StatelessWidget {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _loginController,
                decoration: InputDecoration(labelText: 'Login'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _confirmaSenhaController,
                decoration: InputDecoration(labelText: 'Confirme a Senha'),
                obscureText: true,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _cepController,
                decoration: InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _cidadeController,
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _complementoController,
                decoration: InputDecoration(labelText: 'Complemento (Opcional)'),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_validateFields()) {
                    // Todos os campos estão preenchidos, fazer o cadastro
                    _cadastrar(context);
                  } else {
                    // Exibir mensagem de erro
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, preencha todos os campos.')));
                  }
                },
                child: Text('Confirmar'),
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
  final String email = _emailController.text;

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
              Text('$email\nCadastrado com sucesso.'),
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
        SnackBar(content: Text('Usuário já cadastrado (login em uso).')),
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
            Text('Erro ao cadastrar usuário.'),
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
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = _formatTelefone(newValue.text);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatTelefone(String text) {
    final numbers = text.replaceAll(RegExp(r'\D'), ''); // Remove todos os caracteres não numéricos
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

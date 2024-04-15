import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  String? nome;
  String? telefone;
  String? email;
  bool isLoading = true; // Flag para controle de carregamento

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      var thingsBoardService = Provider.of<ThingsBoardService>(context, listen: false);
      var loadedNome = await thingsBoardService.tbSecureStorage.getItem("nome");
      var loadedTelefone = await thingsBoardService.tbSecureStorage.getItem("telefone");
      var loadedEmail = await thingsBoardService.tbSecureStorage.getItem("email");
  
      setState(() {
        nome = loadedNome;
        telefone = loadedTelefone;
        email = loadedEmail;
        isLoading = false;
       
      });
    } catch (e) {  // Atualizar o estado para refletir que o carregamento termin
      // Adicionar tratamento de erro aqui
      print('Erro ao carregar dados: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  if (isLoading) {
    // Mostra uma tela de carregamento enquanto os dados não estão prontos
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFFEEEEEE),
      title: Text('Configurações'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
    ),
    backgroundColor: Color(0xFFEEEEEE),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Implemente a lógica para selecionar uma nova imagem de perfil
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEEEEEE),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      email!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Informações Pessoais',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 18, 20, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Color(0xFF1976D2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEEEEEE)),
                  ),
                  labelText: nome,
                  enabledBorder: InputBorder.none,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 20, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.email,
                    color: Color(0xFF1976D2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEEEEEE)),
                  ),
                  labelText: email,
                  enabledBorder: InputBorder.none,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 20, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.phone_android,
                    color: Color(0xFF1976D2),
                  ),
                  labelText: telefone,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // Se desejar adicionar a possibilidade de adicionar múltiplos telefones, pode-se adicionar mais campos aqui
          ],
        ),
      ),
    ),
  );
  }
}
import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          'assets/images/profile.png'), // Altere o caminho da imagem conforme necessário
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome do Usuário',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'email@example.com',
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
                margin: EdgeInsets.fromLTRB(20, 18, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Color(0xFF1976D2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    labelText: "Nome",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
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
                margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.phone_android,
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
              // Se desejar adicionar a possibilidade de adicionar múltiplos telefones, pode-se adicionar mais campos aqui

              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.key_outlined,
                      color: Color(0xFF1976D2),
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
                margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
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
                    onTap: () async {},
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
            ],
          ),
        ),
      ),
    );
  }
}

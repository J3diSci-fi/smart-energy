import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
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
                      backgroundImage: AssetImage('assets/images/profile_image.jpg'), // Altere o caminho da imagem conforme necessário
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
              SizedBox(height: 10),
              Text('Nome:'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Digite seu nome',
                ),
              ),
              SizedBox(height: 10),
              Text('E-mail:'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Digite seu e-mail',
                ),
              ),
              SizedBox(height: 10),
              Text('Telefone(s):'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Digite seu telefone',
                ),
              ),
              // Se desejar adicionar a possibilidade de adicionar múltiplos telefones, pode-se adicionar mais campos aqui
              SizedBox(height: 20),
              Text('Senha:'),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Digite sua senha',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implemente a lógica para salvar as alterações
                },
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

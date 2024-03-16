import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe a biblioteca intl
import 'package:smartenergy_app/screens/login_screen/login.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, String>> _deviceList = []; // Lista para armazenar os dispositivos adicionados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.red, // Define o background vermelho
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3), // Define o efeito de sombra
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0), // Adiciona padding
          alignment: Alignment.center, // Alinha o conteúdo ao centro
          child: Text(
            'Smart Energy',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Define a cor do texto como branco
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _deviceList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildDeviceItem(_deviceList[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeviceDialog(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Desconectar',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // Sair para a tela de login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else if (index == 1) {
            // Ir para a tela de configurações
            Navigator.pushNamed(context, '/configs');
          }
        },
      ),
    );
  }

  Widget _buildDeviceItem(Map<String, String> device) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Altera a posição da sombra
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            // Placeholder para a imagem do dispositivo
            backgroundColor: Colors.grey,
            
          ),
          title: Text(device['name'] ?? ''), // Exemplo de texto do dispositivo
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(device['description'] ?? ''), // Descrição do dispositivo
              Text('Criado em: ${_formatDate(DateTime.now())}'), // Data de criação do dispositivo formatada
            ],
          ),
          trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green, // Status do dispositivo (pode ser dinâmico)
            ),
          ),
          onTap: () {
            // Implemente a ação ao clicar em um dispositivo
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Método para formatar a data
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _showAddDeviceDialog(BuildContext context) {
    String _newDeviceName = ''; // Variável para armazenar o nome do novo dispositivo
    String _newDeviceDescription = ''; // Variável para armazenar a descrição do novo dispositivo
    String _newDeviceMac = ''; // Variável para armazenar o MAC do novo dispositivo
    String _newDeviceSerial = ''; // Variável para armazenar o Serial Key do novo dispositivo

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicionar Dispositivo"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    _newDeviceName = value; // Atualizar o nome do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome do Dispositivo',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _newDeviceDescription = value; // Atualizar a descrição do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _newDeviceMac = value; // Atualizar o MAC do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'MAC',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _newDeviceSerial = value; // Atualizar o Serial Key do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'Serial Key',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // Adicionar lógica para adicionar dispositivo
                if (_newDeviceName.isNotEmpty) {
                  setState(() {
                    _deviceList.add({
                      'name': _newDeviceName,
                      'description': _newDeviceDescription,
                      'mac': _newDeviceMac,
                      'serial': _newDeviceSerial,
                    }); // Adicionar o novo dispositivo à lista
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

  // Função para atualizar a lista de dispositivos
  void updateDeviceList(List<dynamic> dispositivos) {
    setState(() {
      // Limpa a lista atual de dispositivos
      _deviceList.clear();
      // Adiciona os dispositivos recebidos à lista
      for (var dispositivo in dispositivos) {
        final name = dispositivo['name'];
        final label = dispositivo['label'];
        _deviceList.add({
          'name': name,
          'description': label,
          'mac':'Dude',
          'serial':'dude'
        });
      }
    });
  }
}
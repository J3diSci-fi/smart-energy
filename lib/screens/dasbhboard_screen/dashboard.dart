import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe a biblioteca intl
import 'package:provider/provider.dart';
import 'package:smartenergy_app/Widget/customerTopBar.dart';
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/screens/login_screen/login2.dart';
import 'package:smartenergy_app/services/Customer_info.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:badges/badges.dart' as badges;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, String>> _deviceList = []; // Lista para armazenar os dispositivos adicionados
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    if (CustomerInfo.idCustomer == null || Config.token.isEmpty) {
      loadCustomerInfo();
    } else {
      adicionarDeviceLista();
    }
  }

  void loadCustomerInfo() async {
    ThingsBoardService thingsBoardService = Provider.of<ThingsBoardService>(context, listen: false);
    String? token = thingsBoardService.getToken();
    String? idCustomer = await thingsBoardService.tbSecureStorage.getItem("id_customer");
    
    if (idCustomer != null && token != null) {
      CustomerInfo.idCustomer = idCustomer;
      Config.token = token;
      adicionarDeviceLista();
    }
    else{
      print("id_Customr $idCustomer, token: $token");
    }
  }

  @override
  Widget build(BuildContext context) {
    ThingsBoardService thingsBoardService = Provider.of<ThingsBoardService>(context);

    //setToken(thingsBoardService);
    return Scaffold(
      backgroundColor: Colors.white,
       appBar:  CustomAppBar(
        logoOffset : 0,
      ),
      body: ListView.builder(
        itemCount: _deviceList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildDeviceItem(_deviceList[index],thingsBoardService);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeviceDialog(context, thingsBoardService);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.white,
        color:   Color(0xFF1976D2),// Cor dos ícones quando não selecionados
        buttonBackgroundColor: Colors.grey, // Cor do botão selecionado
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
          Icon(Icons.logout_outlined, color: Colors.white),
          badges.Badge(
            badgeContent: Text(
              notificationCount.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            updateNotificationCount();
          }
          if (index == 2) {
            thingsBoardService.tbSecureStorage.deleteItem("login");
            thingsBoardService.tbSecureStorage.deleteItem("senha");
            thingsBoardService.tbSecureStorage.deleteItem("id_customer");
            // Sair para a tela de login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login2()),
            );
          } else if (index == 1) {
            // Ir para a tela de configurações
            Navigator.pushNamed(context, '/configs').then((result) {
              if (result != null && result is bool && result) {
                _bottomNavigationKey.currentState
                    ?.setPage(0); // Define o índice selecionado como 0 (home)
              }
            });
          } else if (index == 3) {
            resetNotificationCount();
            Navigator.pushNamed(context, '/notificacoes').then((result) {
              if (result != null && result is bool && result) {
                _bottomNavigationKey.currentState
                    ?.setPage(0); // Define o índice selecionado como 0 (home)
              }
            });
          }
        },
      ),
    );
  }

  void updateNotificationCount() {
    setState(() {
      notificationCount = notificationCount + 1;
    });
  }

  void resetNotificationCount() {
    setState(() {
      notificationCount = 0;
    });
  }

  Widget _buildDeviceItem(Map<String, String> device, ThingsBoardService thingsBoardService) {
  String data = device['data']!;
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
          backgroundImage: AssetImage('assets/images/fazenda.png'),
          backgroundColor: Colors.grey,
          radius: 25.0,
        ),
        title: Text(device['name'] ?? ''), // Exemplo de texto do dispositivo
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device['description'] ?? ''), // Descrição do dispositivo
            Text("Criado em: $data"), // Data de criação do dispositivo formatada
            SizedBox(height: 10), // Espaço entre os textos e os ícones
          ],
        ),
        
        trailing: Container(
          alignment: Alignment.centerRight, // Alinha o conteúdo à direita
          width: 30, // Largura do container
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz), // sugestões de icones guys: Icons.settings, Icons.menu,arrow_drop_down, expand_more,more_horiz
            onSelected: (String value) {
              if (value == 'editar') {
                // Implemente a lógica para editar o dispositivo
              } else if (value == 'deletar') {
                _deleteDevice(device,  thingsBoardService);
                
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'deletar',
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Deletar'),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/dispositivo'); // Implemente a lógica para abrir detalhes do dispositivo
        },
      ),
    ),
  );
}

void _deleteDevice(Map<String, String> device,ThingsBoardService thingsBoardService) {
  setState(() {
    _deviceList.remove(device);
  });

  thingsBoardService.tbClient.getDeviceService().deleteDevice(device['id']!);
}

void _editDevice(Map<String, String> device) {
  // Implemente a lógica para editar o dispositivo
}
String _formatDate(DateTime date) {
    // Método para formatar a data
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _showAddDeviceDialog(BuildContext context, ThingsBoardService thingsBoardService) {
    String _newDeviceName =
        ''; // Variável para armazenar o nome do novo dispositivo
    String _newDeviceDescription =
        ''; // Variável para armazenar a descrição do novo dispositivo
    String _newDeviceMac =
        ''; // Variável para armazenar o MAC do novo dispositivo
    String _newDeviceSerial =
        ''; // Variável para armazenar o Serial Key do novo dispositivo

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
                    _newDeviceName =
                        value; // Atualizar o nome do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome do Dispositivo',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _newDeviceDescription =
                        value; // Atualizar a descrição do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _newDeviceMac =
                        value; // Atualizar o MAC do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'MAC',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _newDeviceSerial =
                        value; // Atualizar o Serial Key do dispositivo conforme o usuário digita
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
              onPressed: () async {
                if (_newDeviceName.isNotEmpty &&
                    _newDeviceDescription.isNotEmpty &&
                    _newDeviceMac.isNotEmpty &&
                    _newDeviceSerial.isNotEmpty) {
                  String data = _formatDate(DateTime.now());
                  String deviceId = await thingsBoardService.adicionarDevice(_newDeviceName, _newDeviceDescription, _newDeviceMac, _newDeviceSerial, data);
                  setState(() {
                    _deviceList.add({
                      'name': _newDeviceName,
                      'description': _newDeviceDescription,
                      'mac': _newDeviceMac,
                      'serial': _newDeviceSerial,
                      'id':deviceId,
                      'data': data,
                    });
                  });
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Aviso"),
                        content: Text("Por favor, preencha todos os campos!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

  void adicionarDeviceLista() async {
    String? id_customer = CustomerInfo.idCustomer;
    print("Printando o id do customer pra saber se tá vazio: $id_customer");
    String token = Config.token;
    var url = Uri.parse(
        'https://thingsboard.cloud:443/api/customer/$id_customer/devices?pageSize=20&page=0');
    var headers = {
      'accept': 'application/json',
      'X-Authorization': 'Bearer $token',
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var devices = jsonResponse['data'];
      for (var device in devices) {
        var name = device['name'];
        var id = device['id']['id'];
        var description = device['additionalInfo']['description'];
        var mac = device['additionalInfo']['mac'];
        var serialKey = device['additionalInfo']['serialKey'];
        var data = device['additionalInfo']['data'];
        setState(() {
          // se eu criar o device pelo site  sem passar mac, serialKey, vai dar error aqui, pq vai passar ocmo null por isso que deve-se ser criado pelo app que n da erro
          _deviceList.add({
            'name': name,
            'description': description,
            'mac': mac,
            'serial': serialKey,
            'id': id,
            'data': data,
          });
        });
        print("Requesição dos devices do cliente deu certo");
        print(
            'Device ID: $id, Description: $description, MAC: $mac, Serial Key: $serialKey');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void adicionarDeviceForaDoDialog() {
    // metodo pra adicionar na lista os que já existem
    String newName = 'filipe';
    String newDescription = 'hahahaha';
    String newMac = '00000-9999';
    String newSerial = '1291313';

    setState(() {
      _deviceList.add({
        'name': newName,
        'description': newDescription,
        'mac': newMac,
        'serial': newSerial,
      });
    });
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
          'mac': 'Dude',
          'serial': 'dude'
        });
      }
    });
  }
}

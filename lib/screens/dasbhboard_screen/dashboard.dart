import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/Widget/customerTopBar.dart';
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/api/aws_api.dart';
import 'package:smartenergy_app/api/firebase_api.dart';
import 'package:smartenergy_app/screens/infoScreen/infoScreen.dart';
import 'package:smartenergy_app/screens/login_screen/login2.dart';
import 'package:smartenergy_app/services/Customer_info.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:web_socket_channel/io.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final channel = IOWebSocketChannel.connect('ws://thingsboard.cloud/api/ws');

  List<Map<String, String>> _deviceList = [];
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
    ThingsBoardService thingsBoardService =  Provider.of<ThingsBoardService>(context, listen: false);
    String? token = thingsBoardService.getToken();
    String? idCustomer = await thingsBoardService.tbSecureStorage.getItem("id_customer");

    if (idCustomer != null && token != null) {
      CustomerInfo.idCustomer = idCustomer;
      Config.token = token;
      adicionarDeviceLista();
    } else {
      print("id_Customr $idCustomer, token: $token");
    }
  }

  @override
  Widget build(BuildContext context) {
    ThingsBoardService thingsBoardService = Provider.of<ThingsBoardService>(context);
    FirebaseApi firebaseApi = Provider.of<FirebaseApi>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        logoOffset: 0,
      ),
      body: ListView.builder(
        itemCount: _deviceList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildDeviceItem(_deviceList[index], thingsBoardService);
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
        color: Color(0xFF1976D2), // Cor dos ícones quando não selecionados
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
          Icon(Icons.notifications, color: Colors.white),
          //badges.Badge(
          // badgeContent: Text(
          // notificationCount.toString(),
          // style: TextStyle(color: Colors.white),
          //),
          //child: Icon(
          //  Icons.notifications,
          // color: Colors.white,
          //),
          //),
        ],
        onTap: (index) async {
          if (index == 0) {
            // updateNotificationCount();
          }
          if (index == 2) {
            thingsBoardService.tbSecureStorage.deleteItem("login");
            thingsBoardService.tbSecureStorage.deleteItem("senha");
            thingsBoardService.tbSecureStorage.deleteItem("id_customer");
            thingsBoardService.tbSecureStorage.deleteItem("telefone");
            thingsBoardService.tbSecureStorage.deleteItem("telefone1");
            thingsBoardService.tbSecureStorage.deleteItem("telefone2");
            thingsBoardService.tbSecureStorage.deleteItem("email");
            thingsBoardService.tbSecureStorage.deleteItem("nome");
            firebaseApi
                .unsubscribeFromTopic(CustomerInfo.idCustomer.toString());
            channel.sink.close();
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
            //resetNotificationCount();
            await thingsBoardService.renewTokenIfNeeded();
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

  Widget _buildDeviceItem(
      Map<String, String> device, ThingsBoardService thingsBoardService) {
    String? data = device['data'];
    String? cor = device['color'];

    // Definindo uma cor padrão
    Color color = Colors.green;
    IconData icon =
        Icons.check_circle; // Ícone padrão para indicar energia disponível

    // Verificando se a cor é nula ou não
    if (cor != null) {
      // Convertendo para minúsculo e removendo espaços em branco
      cor = cor.toLowerCase().trim();

      // Verificando se a cor é 'verde' ou 'vermelho'
      if (cor == "verde") {
        color = Colors.green;
        icon = Icons.check_circle; // Ícone para energia disponível
      } else if (cor == "vermelho") {
        color = Colors.red;
        icon = Icons.error; // Ícone para falta de energia
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
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
          leading: Icon(
            icon,
            color: color,
            size: 50,
          ),

          title: Text(device['name'] ?? ''), // Exemplo de texto do dispositivo
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(device['description'] ?? ''), // Descrição do dispositivo
              Text(
                  "Criado em: $data"), // Data de criação do dispositivo formatada
              SizedBox(height: 10), // Espaço entre os textos e os ícones
            ],
          ),

          trailing: Container(
            alignment: Alignment.centerRight, // Alinha o conteúdo à direita
            width: 30, // Largura do container
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz),
              onSelected: (String value) {
                if (value == 'editar') {
                  _showAddDeviceDialogEdit(context, thingsBoardService, device);
                } else if (value == 'deletar') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Deletar"),
                        content: Text("Deseja deletar este dispositivo?"),
                        actions: [
                          TextButton(
                            child: Text("Cancelar"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Confirmar"),
                            onPressed: () {
                              _deleteDevice(device, thingsBoardService);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoScreen(device: device),
              ),
            );
          },
        ),
      ),
    );
  }

  void leitura() {
    channel.stream.listen((message) {
      var jsonResponse = jsonDecode(message);
      var subscriptionId = jsonResponse['subscriptionId'];

      String serial = subscriptionId.toString();

      // Iterar sobre a lista de dispositivos para encontrar o dispositivo correspondente
      for (var device in _deviceList) {
        var deviceSerial = device['serial'];
        if (deviceSerial == serial) {
          var data = jsonResponse['data'];
          if (data != null && data.containsKey('energia')) {
            var energiaData = data['energia'][0][1];

            if (energiaData.trim() == "true" && device['color'] != "verde") {
              setState(() {
                device['color'] = "verde";
              });
            } else if (energiaData == "false" && device['color'] != "vermelho") {
              setState(() {
                device['color'] = "vermelho";
              }); // Atualizar para verde
            }

            break;
          } else {
            print("Não conem a chave energia");
          }
        }
      }
      
    });
  }

  void _deleteDevice(Map<String, String> device, ThingsBoardService thingsBoardService) async{
    await thingsBoardService.renewTokenIfNeeded();
    await salvar_telefones_aws(device['serial']!, "");
    setState(() {
      _deviceList.remove(device);
    });

    thingsBoardService.tbClient.getDeviceService().deleteDevice(device['id']!);
  }
  
  String _formatDate(DateTime date) {
    // Método para formatar a data
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _showAddDeviceDialogEdit(BuildContext context,ThingsBoardService thingsBoardService, Map<String, String> device) {
    TextEditingController _nameController = TextEditingController(text: device['name']);
    TextEditingController _descriptionController = TextEditingController(text: device['description']);
    String serial = device['serial']!;
    device['serial'];
    String id_device = device['id']!;
    String data = device['data']!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alterar Dispositivo"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  onChanged: (value) {
                    // Atualizar o nome do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome do Dispositivo',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  onChanged: (value) {
                    // Atualizar a descrição do dispositivo conforme o usuário digita
                  },
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                  ),
                ),
                SizedBox(height: 10),

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
                String _newDeviceName = _nameController.text;
                String _newDeviceDescription = _descriptionController.text;
                
                if (_newDeviceName.isNotEmpty && _newDeviceDescription.isNotEmpty) {
                  
                  String deviceNameWithSerial = '$_newDeviceName - $serial';
                  thingsBoardService.editarDevice(deviceNameWithSerial, id_device, _newDeviceDescription, serial!, data);
                  setState(() {
                    device['name'] = _newDeviceName;
                    device['description'] = _newDeviceDescription;
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
              child: Text("Alterar"),
            ),
          ],
        );
      },
    );
  }

  void _showAddDeviceDialog(
      BuildContext context, ThingsBoardService thingsBoardService) {
    String _newDeviceName = ''; // Variável para armazenar o nome do novo dispositivo
    String _newDeviceDescription = ''; // Variável para armazenar a descrição do novo dispositivo 
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
                    _newDeviceSerial.isNotEmpty) {
                  String deviceNameWithSerial = '$_newDeviceName - $_newDeviceSerial';
                  String data = _formatDate(DateTime.now());
                  bool valorr = await thingsBoardService.verificar_serialKey(_newDeviceSerial.toLowerCase());
                  if (!valorr) {
                    var telefone = await thingsBoardService.tbSecureStorage.getItem("telefone");
                    var telefone1 = await thingsBoardService.tbSecureStorage.getItem("telefone1");
                    var telefone2 = await thingsBoardService.tbSecureStorage.getItem("telefone2");
                    String telefones = '$telefone,$telefone1,$telefone2';
                    salvar_telefones_aws(_newDeviceSerial, telefones);
                    String deviceId = await thingsBoardService.cadastrarDevice(
                        deviceNameWithSerial,
                        _newDeviceDescription,
                        _newDeviceSerial.toLowerCase(),
                        data);
                    setState(() {
                      _deviceList.add({
                        'name': _newDeviceName,
                        'description': _newDeviceDescription,
                        'serial': _newDeviceSerial,
                        'id': deviceId,
                        'data': data,
                        'color': "verde",
                      });
                    });
                    subscribeDivece(deviceId, _newDeviceSerial);
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Aviso"),
                          content: Text("Dispositivo Já cadastrado!"),
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

  void adicionarwebsocket() {

    for (var device in _deviceList) {
      var serial = device['serial'];
      var id = device['id'];
      channel.sink.add(jsonEncode({
        "authCmd": {
          "cmdId": 0,
          "token": Config.token,
        },
        "cmds": [
          {
            "entityType": "DEVICE",
            "entityId": id,
            "scope": "LATEST_TELEMETRY",
            "cmdId": serial,
            "type": "TIMESERIES",
          }
        ]
      }));
    }
  }

  void adicionarDeviceLista() async {
    ThingsBoardService thingsBoardService =  Provider.of<ThingsBoardService>(context, listen: false);
    await thingsBoardService.renewTokenIfNeeded();
    String? id_customer = CustomerInfo.idCustomer;
    String token = Config.token;
    var url = Uri.parse(
        'https://thingsboard.cloud:443/api/customer/$id_customer/devices?pageSize=100&page=0');
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
        var serialKey = device['additionalInfo']['serialKey'];
        var data = device['additionalInfo']['data'];
        String novoNome = name.split("-")[0];
        setState(() {
          _deviceList.add({
            'name': novoNome,
            'description': description,
            'serial': serialKey,
            'id': id,
            'data': data,
            'color': "verde",
          });
        });
      }
      adicionarwebsocket();
      leitura();
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void subscribeDivece(String id, String serial) {
    channel.sink.add(jsonEncode({
      "authCmd": {
        "cmdId": 0,
        "token": Config.token,
      },
      "cmds": [
        {
          "entityType": "DEVICE",
          "entityId": id,
          "scope": "LATEST_TELEMETRY",
          "cmdId": serial,
          "type": "TIMESERIES",
        }
      ]
    }));
  }

}

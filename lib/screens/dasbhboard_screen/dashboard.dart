import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/Widget/customerTopBar.dart';
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/api/aws_api.dart';
import 'package:smartenergy_app/api/get_serial_aws.dart';
import 'package:smartenergy_app/api/editarCustomer.dart';
import 'package:smartenergy_app/api/firebase_api.dart';
import 'package:smartenergy_app/api/post_serial_aws.dart';
import 'package:smartenergy_app/api/utils.dart';
import 'package:smartenergy_app/screens/infoScreen/infoScreen.dart';
import 'package:smartenergy_app/screens/login_screen/login2.dart';
import 'package:smartenergy_app/services/Customer_info.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final channel = IOWebSocketChannel.connect(
      'ws://backend.smartenergy.smartrural.com.br/api/ws');

  List<Map<String, String>> _deviceList = [];
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await loadCustomerInfo();
    if (CustomerInfo.idCustomer != null) {
        adicionarDeviceLista();   
    } else {
      print("idCustomer é nulo após o carregamento");
      //se for nullo eu limpo tudo e vou para a tela de login
    }
    alarme_status();
  }

  Future<void> loadCustomerInfo() async {
    String? idCustomer =
        await ThingsBoardService.tbSecureStorage.getItem("id_customer");
    CustomerInfo.idCustomer = idCustomer;
  }

  @override
  Widget build(BuildContext context) {
    ThingsBoardService thingsBoardService =
        Provider.of<ThingsBoardService>(context);
    FirebaseApi firebaseApi = Provider.of<FirebaseApi>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
              ThingsBoardService.tbSecureStorage.deleteItem("login");
              ThingsBoardService.tbSecureStorage.deleteItem("senha");
              ThingsBoardService.tbSecureStorage.deleteItem("id_customer");
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

              Navigator.pushNamed(context, '/notificacoes').then((result) {
                if (result != null && result is bool && result) {
                  _bottomNavigationKey.currentState
                      ?.setPage(0); // Define o índice selecionado como 0 (home)
                }
              });
            }
          },
        ),
      ),
    );
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
        deviceSerial =  formatSerialKey(deviceSerial!); //tirei os hifens
        deviceSerial =  getFromEighthDigit(deviceSerial); //peguei os 8 digitos
        deviceSerial = deviceSerial..replaceAll('0', 'C');
        deviceSerial =  convertLettersToNumbers(deviceSerial); // converti em numeros
        
        if (deviceSerial == serial) {
          var data = jsonResponse['data'];
          if (data != null && data.containsKey('energia')) {
            var energiaData = data['energia'][0][1];

            if (energiaData.trim() == "true" && device['color'] != "verde") {
              setState(() {
                device['color'] = "verde";
              });
            } else if (energiaData == "false" &&
                device['color'] != "vermelho") {
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

  void _deleteDevice(
      Map<String, String> device, ThingsBoardService thingsBoardService) async {
    await atualizar_status_serial(device['serial']!, "false");
    await salvar_telefones_aws(device['serial']!, "");
    setState(() {
      _deviceList.remove(device);
    });
    await thingsBoardService.unassigndevice(device['id']!);
    // await thingsBoardService.deleteDevice(device['id']!);
  }

  String _formatDate(DateTime date) {
    // Método para formatar a data
    return DateFormat('dd-MM-yyyy').format(date);
  }


  void _showAddDeviceDialogEdit(BuildContext context,
      ThingsBoardService thingsBoardService, Map<String, String> device) {
    TextEditingController _nameController =
        TextEditingController(text: device['name']);
    TextEditingController _descriptionController =
        TextEditingController(text: device['description']);
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

                if (_newDeviceName.isNotEmpty &&
                    _newDeviceDescription.isNotEmpty) {
                  String deviceNameWithSerial = '$_newDeviceName - $serial';
                  thingsBoardService.editarDevice(deviceNameWithSerial,
                      id_device, _newDeviceDescription, serial!, data);
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
  String _newDeviceName = '';
  String _newDeviceDescription = '';
  String _newDeviceSerial = '';

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
                  _newDeviceName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nome do Dispositivo',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  _newDeviceDescription = value;
                },
                decoration: InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  _newDeviceSerial = value;
                },
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  SerialKeyFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Serial Key',
                  hintText: 'xxxx-xxxx-xxxx',
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
                _newDeviceSerial = _newDeviceSerial.toUpperCase(); //colocando em caixa alta
      
                var result = await fetchData("$_newDeviceSerial");
                if (result.isNotEmpty) {
                  if (result['message'] == "existe") {
                    if (result['status'] == "false") {
                      await atualizar_status_serial(_newDeviceSerial, "true");

                      dynamic customer = await getCustomer();
                      var telefone = customer["phone"];
                      var telefone1 = customer['additionalInfo']['telefone1'];
                      var telefone2 = customer['additionalInfo']['telefone2'];
                      String telefones = '$telefone,$telefone1,$telefone2';
                      salvar_telefones_aws(_newDeviceSerial, telefones);

                      String? deviceId = await thingsBoardService.existeDevice(_newDeviceSerial);
                      if (deviceId != null) {
                        thingsBoardService.editarDevice(
                            deviceNameWithSerial,
                            deviceId,
                            _newDeviceDescription,
                            _newDeviceSerial,
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
                        //Aqui eu transformo tudo em número para subscrever no callback (cmdid) e tiro os hifens
                        subscribeDivece(deviceId, _newDeviceSerial);
                        Navigator.of(context).pop();
                      } else {
                        String deviceId =
                            await thingsBoardService.cadastrarDevice(
                                deviceNameWithSerial,
                                _newDeviceDescription,
                                _newDeviceSerial,
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
                        //Aqui eu transformo tudo em número para subscrever no callback (cmdid) e tiro os hifens
                        subscribeDivece(deviceId, _newDeviceSerial);
                        Navigator.of(context).pop();
                      }
                    } else if (result['status'] == "null") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Aviso"),
                            content: Text(
                                "Realize o pagamento do dispositivo para continuar utilizando nossos serviços!"),
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
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Aviso"),
                            content: Text(
                                "O código serial do dispositivo informado já está em uso!"),
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
                          content: Text("Código de serial inválido!"),
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
                        content: Text(
                            "Aconteceu um problema inesperado. Tente novamente mais tarde!"),
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
      //aqui eu tiro os hifens e transformo em números
      String serial2 = formatSerialKey(serial!); //tirei os hifens
      serial2 = getFromEighthDigit(serial2); // peguei 8 digitos
      serial2 = serial2..replaceAll('0', 'C');
      serial2 = convertLettersToNumbers(serial2); //converti em numero

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
            "cmdId": serial2,
            "type": "TIMESERIES",
          }
        ]
      }));
    }
  }

  void adicionarDeviceLista() async {
    String? id_customer = CustomerInfo.idCustomer;
    String token = Config.token;
    var url = Uri.parse(
        '${Config.apiUrl}/customer/$id_customer/devices?pageSize=100&page=0');
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
      subscribeDivece("301", "1011101");
      leitura();
    } else {
      print('Request failed with status: ${response.statusCode}');
      ThingsBoardService.tbSecureStorage.deleteItem("login");
      ThingsBoardService.tbSecureStorage.deleteItem("senha");
      ThingsBoardService.tbSecureStorage.deleteItem("id_customer");
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Login2()),);
      print(response.body);
      print(response.statusCode);
      print(response.request);
    }
  }

  void alarme_status() async {
    String? status = await ThingsBoardService.tbSecureStorage.getItem("status");
    if (status == null) {
      print("O status é nullo");
      await ThingsBoardService.tbSecureStorage.setItem("status", "true");
    } else {
      print("O status atual é {$status}");
    }
  }

  void subscribeDivece(String id, String serial) {
    String serial2 = formatSerialKey(serial); //tirei os hifens
    serial2 = getFromEighthDigit(serial2); // peguei 8 digitos
    serial2 = serial2..replaceAll('0', 'C');
    serial2 = convertLettersToNumbers(serial2);
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
          "cmdId": serial2,
          "type": "TIMESERIES",
        }
      ]
    }));
  }
}
class SerialKeyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String oldText = oldValue.text.replaceAll('-', '');
    String newText = newValue.text.replaceAll('-', '');

    // Verifica se o texto está sendo apagado
    if (newValue.text.length < oldValue.text.length) {
      // Se o texto está sendo apagado e o último caractere era um hífen, remova também o hífen
      if (oldText.length % 4 == 0 && newText.length > 0) {
        newText = newText.substring(0, newText.length - 1);
      }
    }

    // Reaplica a formatação com hífens
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      formattedText += newText[i];
      if ((i + 1) % 4 == 0 && i + 1 != newText.length) {
        formattedText += '-';
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
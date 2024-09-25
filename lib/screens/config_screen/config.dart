import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/api/aws_api.dart';
import 'package:smartenergy_app/api/editarCustomer.dart';
import 'package:smartenergy_app/api/firebase_api.dart';
import 'package:smartenergy_app/api/post_serial_aws.dart';
import 'package:smartenergy_app/logic/core/appcore.dart';
import 'package:smartenergy_app/screens/login_screen/login2.dart';
import 'package:smartenergy_app/services/Customer_info.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  String? nome;
  String? telefone;
  String? email;
  String? telefone1;
  String? telefone2;
  String? login;
  bool isLoading = true;
  List<Map<String, String>> _deviceList = [];
  late bool value;

  @override
  void initState() {
    super.initState();
    loadData();
    adicionarDeviceLista();
  }

  Future<void> loadData() async {
    try {
      bool status2 = false;
      String? status =
          await ThingsBoardService.tbSecureStorage.getItem("status");
      if (status == "true") {
        status2 = true;
      }
      dynamic customer = await getCustomer();
      var loadedNome = customer['state'];
      var loadedTelefone = customer["phone"];
      var loadedEmail = customer['email'];
      var loadlogin = customer['title'];
      var loadedTelefone1 = customer['additionalInfo']['telefone1'];
      var loadedTelefone2 = customer['additionalInfo']['telefone2'];

      setState(() {
        nome = loadedNome;
        telefone = loadedTelefone;
        telefone1 = loadedTelefone1;
        telefone2 = loadedTelefone2;
        email = loadedEmail;
        login = loadlogin;
        value = status2;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }
  Future<void> deleteCustomer(String customerId) async {
    final url = Uri.parse('${Config.apiUrl}/customer/$customerId');

    final response = await http.delete(
      url,
      headers: {
        'accept': '*/*',
        'X-Authorization': 'Bearer ${Config.token}',
      },
    );

    if (response.statusCode == 200) {
      print('Cliente removido com sucesso!');
    } else {
      print('Falha ao remover cliente: ${response.statusCode}');
      print('Response body: ${response.body}');
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
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.asset(
            "assets/Lottie/Animation - 1712852951040.json",
            width: 150,
            height: 150,
            fit:
                BoxFit.cover, // ou BoxFit.fill, dependendo do que você preferir
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: Scaffold(
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
                buildNonEditableField(
                  labelText: 'Nome',
                  initialValue: login!,
                  icon: Icons.person,
                ),
                buildEditableField2(
                  labelText: 'E-mail',
                  initialValue: email!,
                  icon: Icons.email,
                ),
                buildEditableField(
                  labelText: 'Telefone',
                  initialValue: telefone!,
                  icon: Icons.phone_android,
                ),
                SizedBox(height: 20),
                Text(
                  'Números para receber alertas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildEditableFieldWithEditAndDelete(
                  labelText: 'Telefone 1',
                  initialValue: telefone1!,
                  icon: Icons.phone_android,
                  onEditPressed: () {
                    showEditTelefone1Dialog(telefone1!);
                  },
                  onDeletePressed: () {
                    showDeleteConfirmationDialog1('Telefone 1', telefone1!);
                  },
                ),
                buildEditableFieldWithEditAndDelete(
                  labelText: 'Telefone 2',
                  initialValue: telefone2!,
                  icon: Icons.phone_android,
                  onEditPressed: () {
                    showEditTelefone2Dialog(telefone2!);
                  },
                  onDeletePressed: () {
                    showDeleteConfirmationDialog2('Telefone 2', telefone2!);
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Alarme:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('ALARME: '),
                        Switch(
                          value: value,
                          onChanged: (newValue) {
                            setState(() {
                              value = newValue;
                            });

                            if (newValue) {
                              startAlarme();
                            } else {
                              stopSong();
                            }
                          },
                          activeTrackColor:
                              Color(0xFF1976D2), // Cor da trilha quando ligado
                          inactiveTrackColor: Color(0xFFEEEEEE),
                          inactiveThumbColor: const Color.fromARGB(
                              255, 7, 7, 7), // Cor da trilha quando desligado
                        ),
                        Text(value
                            ? 'ON'
                            : 'OFF'), // Texto dinâmico conforme o valor do Switch
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDeleteAccountConfirmationDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            249, 238, 238, 238), // Cor de fundo do botão
                        foregroundColor:
                            Color(0xFF1976D2), // Cor do texto no botão
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Borda arredondada
                        ),
                      ),
                      child: Text(
                        'Deletar Conta',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNonEditableField({
    required String labelText,
    required String initialValue,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                icon: Icon(
                  icon,
                  color: Color(0xFF1976D2),
                ),
                labelText: initialValue,
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableField({
    required String labelText,
    required String initialValue,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                icon: Icon(
                  icon,
                  color: Color(0xFF1976D2),
                ),
                labelText: initialValue,
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showEdittelefonePrincipal(initialValue);
            },
          ),
        ],
      ),
    );
  }

  Widget buildEditableField2({
    required String labelText,
    required String initialValue,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                icon: Icon(
                  icon,
                  color: Color(0xFF1976D2),
                ),
                labelText: initialValue,
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showEditEmail(initialValue);
            },
          ),
        ],
      ),
    );
  }

  void showDeleteAccountConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deletar Conta'),
          content: Text('Você tem certeza que deseja deletar sua conta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                ThingsBoardService.tbSecureStorage.deleteItem("login");
                ThingsBoardService.tbSecureStorage.deleteItem("senha");
                ThingsBoardService.tbSecureStorage.deleteItem("id_customer");

                for (final device in _deviceList) {
                  final String serial = device['serial'].toString();
                  await salvar_telefones_aws(serial, "");
                  await atualizar_status_serial(serial, "false");
                }
                FirebaseApi firebaseApi = Provider.of<FirebaseApi>(context, listen: false);
                firebaseApi.unsubscribeFromTopic(CustomerInfo.idCustomer.toString());
                await deleteCustomer(CustomerInfo.idCustomer.toString());
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Login2()),);
              },
              child: Text('Confirmar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget buildEditableFieldWithEditAndDelete({
    required String labelText,
    required String initialValue,
    required IconData icon,
    required VoidCallback onEditPressed,
    required VoidCallback onDeletePressed,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                icon: Icon(
                  icon,
                  color: Color(0xFF1976D2),
                ),
                labelText: initialValue,
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEditPressed,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDeletePressed,
          ),
        ],
      ),
    );
  }

  void stopSong() async {
    await ThingsBoardService.tbSecureStorage.setItem("status", "false");
    AppCore.soundManager.stop();
  }

  void startAlarme() async {
    await ThingsBoardService.tbSecureStorage.setItem("status", "true");
  }

  void showEditTelefone1Dialog(String initialValue) {
    MaskedTextController controller = MaskedTextController(
      mask: '+55(00)000000000',
      text: "",
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newValue = initialValue;
        return AlertDialog(
          title: Text('Editar Telefone 1'),
          content: TextField(
            controller: controller,
            onChanged: (value) {
              newValue = value;
            },
            decoration: InputDecoration(
              labelText: 'Telefone 1',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (newValue.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('O campo não pode ficar vazio'),
                    ),
                  );
                } else {
                  String numero = newValue.replaceAll(RegExp(r'[()]'), '');

                  bool result = await adicionarTelefone1(
                      numero.trim(), "adicionar", _deviceList);
                  if (result) {
                    // Atualize o estado dentro do setState após a lógica assíncrona
                    setState(() {
                      telefone1 = numero;
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Telefone já cadastrado'),
                      ),
                    );
                  }
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void showEditTelefone2Dialog(String initialValue) {
    MaskedTextController controller = MaskedTextController(
      mask: '+55(00)000000000',
      text: "",
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newValue = initialValue;
        return AlertDialog(
          title: Text('Editar Telefone 2'),
          content: TextField(
            controller: controller,
            onChanged: (value) {
              newValue = value;
            },
            decoration: InputDecoration(
              labelText: 'Telefone 2',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (newValue.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('O campo não pode ficar vazio'),
                    ),
                  );
                } else {
                  String numero = newValue.replaceAll(RegExp(r'[()]'), '');

                  bool result = await adicionarTelefone2(
                      numero.trim(), "adicionar", _deviceList);
                  if (result) {
                    // Atualize o estado dentro do setState após a lógica assíncrona
                    setState(() {
                      telefone2 = numero;
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Telefone já cadastrado'),
                      ),
                    );
                  }
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void showEditEmail(String initialValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newValue = initialValue;
        return AlertDialog(
          title: Text('Editar Email'),
          content: TextField(
            onChanged: (value) {
              newValue = value;
            },
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (newValue.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('O campo não pode ficar vazio'),
                    ),
                  );
                } else {
                  String email2 = newValue.toLowerCase();

                  bool result = await editarEmail(email2.trim());
                  if (result) {
                    // Atualize o estado dentro do setState após a lógica assíncrona
                    setState(() {
                      email = email2;
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email já existente!'),
                      ),
                    );
                  }
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void showEdittelefonePrincipal(String initialValue) {
    MaskedTextController controller = MaskedTextController(
      mask: '+55(00)000000000',
      text: "",
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newValue = initialValue;
        return AlertDialog(
          title: Text('Editar Telefone'),
          content: TextField(
            controller: controller,
            onChanged: (value) {
              newValue = value;
            },
            decoration: InputDecoration(
              labelText: 'Telefone',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (newValue.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('O campo não pode ficar vazio'),
                    ),
                  );
                } else {
                  String numero = newValue.replaceAll(RegExp(r'[()]'), '');

                  bool result =
                      await editarTelefonePrincipa(numero.trim(), _deviceList);
                  if (result) {
                    // Atualize o estado dentro do setState após a lógica assíncrona
                    setState(() {
                      telefone = numero;
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Telefone já cadastrado'),
                      ),
                    );
                  }
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog2(String labelText, String initialValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir $labelText'),
          content: Text('Tem certeza de que deseja excluir este número?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                bool result =
                    await adicionarTelefone2("", "deletar", _deviceList);
                if (result) {
                  // Atualize o estado dentro do setState após a lógica assíncrona
                  setState(() {
                    telefone2 = "";
                  });
                  Navigator.of(context).pop();
                } else {
                  print("ERRO!");
                }
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog1(String labelText, String initialValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir $labelText'),
          content: Text('Tem certeza de que deseja excluir este número?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                bool result =
                    await adicionarTelefone1("", "deletar", _deviceList);
                if (result) {
                  // Atualize o estado dentro do setState após a lógica assíncrona
                  setState(() {
                    telefone1 = "";
                  });
                  Navigator.of(context).pop();
                } else {
                  print("ERRO!");
                }
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}

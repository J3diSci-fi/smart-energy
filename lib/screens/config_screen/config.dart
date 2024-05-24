import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/api/editarCustomer.dart';
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
  bool isLoading = true; // Flag para controle de carregamento
  List<Map<String, String>> _deviceList = [];

  @override
  void initState() {
    super.initState();
    loadData();
    adicionarDeviceLista();
  }

  Future<void> loadData() async {
    try {
      var thingsBoardService =
          Provider.of<ThingsBoardService>(context, listen: false);
      var loadedNome = await thingsBoardService.tbSecureStorage.getItem("nome");
      var loadedTelefone =
          await thingsBoardService.tbSecureStorage.getItem("telefone");
      var loadedEmail =
          await thingsBoardService.tbSecureStorage.getItem("email");

      var loadedTelefone1 =
          await thingsBoardService.tbSecureStorage.getItem("telefone1");
      var loadedTelefone2 =
          await thingsBoardService.tbSecureStorage.getItem("telefone2");

      setState(() {
        nome = loadedNome;
        telefone = loadedTelefone;
        telefone1 = loadedTelefone1;
        telefone2 = loadedTelefone2;
        email = loadedEmail;

        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
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
      
    } else {
      print('Request failed with status: ${response.statusCode}');
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
              buildNonEditableField(
                labelText: 'Nome',
                initialValue: nome!,
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
                'Números para receber SMS',
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
            ],
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

  void showEditTelefone1Dialog(String initialValue) {
    MaskedTextController controller = MaskedTextController(
      mask: '+55(00)000000000',
      text: "",
    );
    final thingsBoardService = Provider.of<ThingsBoardService>(context, listen: false);
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
                  await thingsBoardService.renewTokenIfNeeded();
                  bool result = await adicionarTelefone1(numero.trim(), thingsBoardService.getIdTenant(),"adicionar", _deviceList);
                  if (result) {
                    // Atualize o estado dentro do setState após a lógica assíncrona
                    setState(() {
                      telefone1 = numero;
                    });

                    // Atualize os dados armazenados
                    await thingsBoardService.tbSecureStorage
                        .setItem("telefone1", numero);

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
    final thingsBoardService =
        Provider.of<ThingsBoardService>(context, listen: false);
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
                  await thingsBoardService.renewTokenIfNeeded();
                  bool result = await adicionarTelefone2(numero.trim(),thingsBoardService.getIdTenant(),"adicionar", _deviceList);
                  if (result) {
                    // Atualize o estado dentro do setState após a lógica assíncrona
                    setState(() {
                      telefone2 = numero;
                    });

                    // Atualize os dados armazenados
                    await thingsBoardService.tbSecureStorage
                        .setItem("telefone2", numero);

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

    final thingsBoardService = Provider.of<ThingsBoardService>(context, listen: false);
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
                  await thingsBoardService.renewTokenIfNeeded();
                  bool result = await editarEmail(email2.trim(), thingsBoardService.getIdTenant());
                  if (result) {
                    // Atualize o estado dentro do setState após a lógica assíncrona
                    setState(() {
                      email = email2;
                    });

                    // Atualize os dados armazenados
                    await thingsBoardService.tbSecureStorage
                        .setItem("email", email2);

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
    final thingsBoardService =
        Provider.of<ThingsBoardService>(context, listen: false);
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
                  thingsBoardService.renewTokenIfNeeded();
                  bool result = await editarTelefonePrincipa(numero.trim(), thingsBoardService.getIdTenant(), _deviceList);
                  if (result) {
                    // Atualize o estado dentro do setState após a lógica assíncrona
                    setState(() {
                      telefone = numero;
                    });

                    // Atualize os dados armazenados
                    await thingsBoardService.tbSecureStorage
                        .setItem("telefone", numero);

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
    final thingsBoardService =
        Provider.of<ThingsBoardService>(context, listen: false);
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
                await thingsBoardService.renewTokenIfNeeded();
                bool result = await adicionarTelefone2("",thingsBoardService.getIdTenant(),"deletar",_deviceList);
                if (result) {
                  // Atualize o estado dentro do setState após a lógica assíncrona
                  setState(() {
                    telefone2 = "";
                  });
                  await thingsBoardService.tbSecureStorage.setItem("telefone2", " ");
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
    final thingsBoardService =
        Provider.of<ThingsBoardService>(context, listen: false);
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
                await thingsBoardService.renewTokenIfNeeded();
                bool result = await adicionarTelefone1("",thingsBoardService.getIdTenant(),"deletar",_deviceList);
                if (result) {
                  // Atualize o estado dentro do setState após a lógica assíncrona
                  setState(() {
                    telefone1 = "";
                  });
                  await thingsBoardService.tbSecureStorage
                      .setItem("telefone1", "");

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

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smartenergy_app/api/api_cfg.dart';
import 'package:smartenergy_app/api/send_attributes.dart';
import 'package:smartenergy_app/api/utils.dart';
import 'package:smartenergy_app/screens/infoScreen/alarmeDeviceScreen.dart';
import 'package:smartenergy_app/screens/infoScreen/relatorioscreen.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class InfoScreen extends StatefulWidget {
  final Map<String, String> device;

  const InfoScreen({Key? key, required this.device}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final channel2 = IOWebSocketChannel.connect(
      'ws://backend.smartenergy.smartrural.com.br/api/ws');
  String energia = "";
  String numero = "";
  String saldo = "";
  bool isLoading =
      true; // Adicione uma variável para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    enviarDadosAoThingsboard(widget.device['serial']!);
    adicionarDevice();
    leitura();
  }

  @override
  void dispose() {
    channel2.sink.close();
    super.dispose();
  }

  void leitura() {
    try {
      channel2.stream.listen((message) {
        var jsonResponse = jsonDecode(message);
        if (jsonResponse == null || jsonResponse.isEmpty) {
          if (mounted) {
            setState(() {
              isLoading = false; // Impede que a tela trave
            });
          }
          return;
        } else {
          var data = jsonResponse['data'];

          if (data.isEmpty) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          } else if (data != null) {
            if (data.containsKey('energia') &&
                data.containsKey('saldo') &&
                data.containsKey('numero')) {
              var energiaData = data['energia'][0][1];
              var saldo_dv = data['saldo'][0][1];
              var numero_dv = data['numero'][0][1];

              if (energiaData == "true") {
                energiaData = "Energia ON";
              } else {
                energiaData = "Energia OFF";
              }

              if (energia != energiaData ||
                  saldo != saldo_dv ||
                  numero != numero_dv) {
                if (mounted) {
                  setState(() {
                    energia = energiaData;
                    saldo = saldo_dv;
                    numero = numero_dv;
                    isLoading = false;
                  });
                }
              } else {
                print(
                    "Os dados continuam os mesmos, sem atualizações por enquanto!");
              }
            }

            if (data.containsKey('energia')) {
              var energiaData = data['energia'][0][1];

              if (energiaData == "true") {
                energiaData = "Energia ON";
              } else {
                energiaData = "Energia OFF";
              }

              if (energia != energiaData) {
                setState(() {
                  energia = energiaData;
                });
              } else {
                print("A energia continua a mesma coisa, não atualizo a tela");
              }
            }

            if (data.containsKey('saldo')) {
              var saldo_dv = data['saldo'][0][1];

              if (saldo != saldo_dv) {
                setState(() {
                  saldo = saldo_dv;
                });
              } else {
                print("O saldo continua o mesmo, sem mudanças por enquanto!");
              }
            }

            if (data.containsKey('numero')) {
              var numero_dv = data['numero'][0][1];
              if (numero != numero_dv) {
                setState(() {
                  numero = numero_dv;
                });
              } else {
                print("O número permanece o mesmo, sem mudanças na tela");
              }
            }
          } else {
            print("Dados não são válidos.");
          }
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false; // Define como falso em caso de erro
        });
      }
    }
  }

  void adicionarDevice() {
    String id_device = widget.device['id']!;
    String serial = widget.device['serial']!;
    serial = formatSerialKey(serial!); //tirei os hifens
    serial = getFromEighthDigit(serial); // peguei 8 digitos
    serial = convertLettersToNumbers(serial); //converti em numeros
    channel2.sink.add(jsonEncode({
      "authCmd": {
        "cmdId": 0,
        "token": Config.token,
      },
      "cmds": [
        {
          "entityType": "DEVICE",
          "entityId": id_device,
          "scope": "LATEST_TELEMETRY",
          "cmdId": serial,
          "type": "TIMESERIES",
        }
      ]
    }));
  }

  @override
  Widget build(BuildContext context) {
    ThingsBoardService thingsBoardService =
        Provider.of<ThingsBoardService>(context);
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: isLoading
            ? SplashScreen() // Mostra o Splash Screen enquanto estiver carregando
            : Container(
                margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            channel2.sink.close();
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const SizedBox(height: 0),
                          Center(
                            child: Image.asset(
                              'assets/images/banner2.png',
                              scale: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              'SmartEnergy',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'SERVIÇOS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _cardMenu(
                                text: "Energia",
                                icon: 'assets/images/energy.png',
                                title: energia,
                              ),
                              _cardMenu(
                                onTap: () {},
                                text: "Número",
                                icon: 'assets/images/telefone.png',
                                title: numero,
                                //color: Colors.indigoAccent,
                                //fontColor: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _cardMenu(
                                text: "Saldo",
                                icon: 'assets/images/saldo.png',
                                title: saldo,
                              ),
                              
                              _cardMenu(
                                onTap: () {
                                  //Navigator.pushNamed(context, '/notificacoes');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeviceAlarme(
                                          device_id: widget.device['id']!,
                                          thingsBoardService:
                                              thingsBoardService),
                                    ),
                                  );
                                },
                                text: "Histórico",
                                icon: 'assets/images/documento (2).png',
                                title: 'Notificações',

                                //color: Colors.indigoAccent,
                                //fontColor: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //eu mudo aqui igual o style 
                            children: [
                              //card do relatorio
                              _cardMenu(
                                onTap: () {
                                  //Navigator.pushNamed(context, '/notificacoes');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RelatorioDevice(
                                          device_id: widget.device['id']!),
                                    ),
                                  );
                                },
                                text: "Relatório",
                                icon: 'assets/images/relatorio (1).png',
                                title: 'Energia',

                                //color: Colors.indigoAccent,
                                //fontColor: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class EmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // Widget vazio
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
              "assets/Lottie/Animation - 1712852951040.json",
              width: 180,
              height: 180,
            ),
          )
        ],
      ),
      splashIconSize: 180,
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      nextScreen: EmptyScreen(),
    );
  }
}

Widget _cardMenu({
  required String text,
  required String title,
  required String icon,
  VoidCallback? onTap,
  Color color = Colors.white,
  Color fontColor = Colors.grey,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10, // Reduzi o padding para caber o texto
      ),
      width: 156,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            text, // Adiciona o texto acima do ícone
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: fontColor,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(icon),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
          )
        ],
      ),
    ),
  );
}

import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<void> enviarDadosAoThingsboard(String serial) async {
  final String brokerMqtt = "backend.smartenergy.smartrural.com.br";
  final int portaMqtt = 1883;
  final String clientId = serial;
  final String mqttUsername = serial;
  final String mqttPassword = serial;

  // Criação do cliente MQTT
  final client = MqttServerClient(brokerMqtt, clientId);
  client.port = portaMqtt;
  client.keepAlivePeriod = 60;
  client.logging(on: false); // Desativa os logs
  client.onConnected = () => print("Conectado ao broker MQTT");
  client.onDisconnected = () => print("Desconectado do broker MQTT");

  // Configura as credenciais do MQTT
  client.setProtocolV311(); // Define a versão do protocolo MQTT
  client.connectionMessage = MqttConnectMessage()
      .withClientIdentifier(clientId)
      .authenticateAs(mqttUsername, mqttPassword)
      .startClean()
      .keepAliveFor(60);

  try {
    // Tenta a conexão com o broker MQTT
    await client.connect();
  } catch (e) {
    print('Erro na conexão ao broker MQTT: $e');
    client.disconnect();
    return;
  }

  // Verifica se está conectado com sucesso
  if (client.connectionStatus?.state == MqttConnectionState.connected) {
    print('Conectado ao broker com sucesso');
  } else {
    print('Falha na conexão: ${client.connectionStatus}');
    client.disconnect();
    return;
  }

  // Dados a serem enviados
  var dados = {
    "ativo": true,
  };

  // Serializa os dados em JSON
  String cargaUtil = jsonEncode(dados);

  // Publica os dados no tópico correto
  const String topico = "v1/devices/me/attributes"; // Tópico correto para enviar os atributos
  final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  builder.addString(cargaUtil);

  client.publishMessage(topico, MqttQos.atLeastOnce, builder.payload!);
  print('Dados enviados com sucesso: $cargaUtil');

  // Desconecta do broker MQTT após o envio
  client.disconnect();
}

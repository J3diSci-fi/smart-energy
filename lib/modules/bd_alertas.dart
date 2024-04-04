import 'package:smartenergy_app/modules/alertas.dart';

class BancoDados {
  static List<Alerta> alertas = [];

  static void adicionarAlerta(Alerta alerta) {
    alertas.add(alerta);
  }
}
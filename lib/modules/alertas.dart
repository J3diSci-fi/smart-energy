class Alerta {
  DateTime dataHora;
  String descricao;
  String macDispositivo;
  String idConfirmacao;

  Alerta({
    required this.dataHora,
    required this.descricao,
    required this.macDispositivo,
    required this.idConfirmacao,
  });

  void setIdConfirmacao(String id){
    this.idConfirmacao = id;
  }
}
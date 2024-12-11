import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:smartenergy_app/api/api_cfg.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle; // Import necessário

class RelatorioDevice extends StatefulWidget {
  final String device_id;

  RelatorioDevice({required this.device_id});

  @override
  _RelatorioDeviceState createState() => _RelatorioDeviceState();
}

class _RelatorioDeviceState extends State<RelatorioDevice> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1976D2),
              secondary: Color(0xFF64B5F6),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text(
          'Smart Energy Relatório',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade50,
        iconTheme: IconThemeData(color: Colors.indigo),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png', // Caminho para o logo
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Campo de Data Início
                    _buildDateField(
                      label: 'Data de Início',
                      hintText: _startDate == null
                          ? 'Selecione a data de início'
                          : DateFormat('dd/MM/yyyy').format(_startDate!),
                      icon: Icons.calendar_today,
                      onTap: () => _selectDate(context, true),
                    ),
                    SizedBox(height: 20),
                    // Campo de Data Fim
                    _buildDateField(
                      label: 'Data de Fim',
                      hintText: _endDate == null
                          ? 'Selecione a data de fim'
                          : DateFormat('dd/MM/yyyy').format(_endDate!),
                      icon: Icons.calendar_today,
                      onTap: () => _selectDate(context, false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            // Botão Gerar Relatório
            _buildGradientButton(
              text: 'Gerar Relatório do Dispositivo',
              onTap: () {
                _showLoadingDialog(context);
                _generateDeviceReport();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir campos de data
  Widget _buildDateField({
    required String label,
    required String hintText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF0F0F0), // Cor de fundo do campo de data
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF1976D2)),
            SizedBox(width: 10),
            Text(
              hintText,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir botões com gradiente
  Widget _buildGradientButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getAlarmeDevice() async {
  String id_device = widget.device_id;
  String token = Config.token;
  var url = Uri.parse(
      '${Config.apiUrl}/alarm/DEVICE/$id_device?pageSize=1000&page=0&sortProperty=createdTime&sortOrder=ASC');
  var headers = {
    'accept': 'application/json',
    'X-Authorization': 'Bearer $token',
  };

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var alarms = jsonResponse['data'];
    tz.initializeTimeZones();
    var localTimezone = tz.getLocation('America/Sao_Paulo');
    List<Map<String, dynamic>> filteredAlarms = [];
    for (var alarm in alarms) {
      var createdTimeMillis = alarm['createdTime'];
      var dateTime = tz.TZDateTime.fromMillisecondsSinceEpoch(
          localTimezone, createdTimeMillis);
      if (_startDate != null && _endDate != null) {
        if ((dateTime.isAfter(_startDate!) || dateTime.isAtSameMomentAs(_startDate!)) &&
            (dateTime.isBefore(_endDate!.add(Duration(days: 1))) || dateTime.isAtSameMomentAs(_endDate!))) {
          filteredAlarms.add(alarm);
        }
      }
    }
    print("Alarmes ${filteredAlarms}");
    _generatePDF(filteredAlarms, "Relatório do Dispositivo");
  } else {
    print('Erro: ${response.statusCode}');
  }
}

  void _generateDeviceReport() {
    getAlarmeDevice();
  }

  Future<void> _generatePDF(
    List<Map<String, dynamic>> alarms, String title) async {
  final pdf = pw.Document();
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
  );

  int energyOutages = 0;
  Duration totalOutageDuration = Duration();
  DateTime? lastOutageStart;

  for (var alarm in alarms) {
    print("Alarme: ${alarm['details']}");
    if (alarm['details'] == 'Faltou Energia!') {
      energyOutages++;
      lastOutageStart =
          DateTime.fromMillisecondsSinceEpoch(alarm['createdTime']);
    } else if (alarm['details'] == 'Energia Restaurada' &&
        lastOutageStart != null) {
      var outageEnd =
          DateTime.fromMillisecondsSinceEpoch(alarm['createdTime']);
      totalOutageDuration += outageEnd.difference(lastOutageStart);
      lastOutageStart = null;
    }
  }

  // Se a energia não tiver voltado, calcular o tempo até o momento atual
  if (lastOutageStart != null) {
    totalOutageDuration += DateTime.now().difference(lastOutageStart);
  }

  // Calcula o total de horas, minutos e segundos
  int totalHours = totalOutageDuration.inHours;
  int totalMinutes = totalOutageDuration.inMinutes % 60;
  int totalSeconds = totalOutageDuration.inSeconds % 60;

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Image(logoImage, height: 100),
            ),
            pw.SizedBox(height: 20),
            pw.Text(title,
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Quantidade de vezes que faltou energia: $energyOutages'),
            pw.Text(
                'Tempo total sem energia: $totalHours horas, $totalMinutes minutos e $totalSeconds segundos'),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );

  Navigator.of(context).pop(); // Fecha o diálogo de carregamento
}

  // Função para mostrar um diálogo de carregamento
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
          ),
        );
      },
    );
  }
}

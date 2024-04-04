import 'package:flutter/material.dart';

class InforScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
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
                      Navigator.of(context).pop(true); 
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
                          title: 'ON',
                        ),
                        _cardMenu(
                          onTap: () {
                            
                          },
                          text: "Número",
                          icon: 'assets/images/telefone.png',
                          title: '99565880',
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
                          title: '20',
                        ),
                        _cardMenu(
                          onTap: () {
                            Navigator.pushNamed(context, '/notificacoes');
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
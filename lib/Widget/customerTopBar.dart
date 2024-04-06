import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double logoOffset;

  CustomAppBar({Key? key, required this.logoOffset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "SMART ENERGY",
        style: TextStyle(
          color: Colors.white, // Cor do texto
          fontSize: 23.0, // Tamanho do texto
          fontWeight: FontWeight.bold, // Negrito
          fontStyle: FontStyle.normal, // Itálico
          letterSpacing: 1.0, // Espaçamento entre letras
        ),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFF1976D2),
      automaticallyImplyLeading: false, // Remove a seta de voltar
      actions: [
        Transform.translate(
          offset: Offset(-10.0, logoOffset - 5.0),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Image.asset("assets/images/smartEnegy.png"), // Substitua o ícone pelo logo
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<bool> confirmados = List.filled(5, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 8, 8),
      appBar: appBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          color: Colors.white, // Altera a cor de fundo do Card para verde
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: listView(),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        'Notificações',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  Widget listView() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (!confirmados[index]) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmar notificação'),
                  content: Text('Deseja confirmar a notificação?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          confirmados[index] = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Notificação confirmada por Jonas'),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text('Confirmar'),
                    ),
                  ],
                ),
              );
            }
          },
          child: confirmados[index]
              ? confirmedListViewItem(index)
              : unconfirmedListViewItem(index),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 8);
      },
      itemCount: 5,
    );
  }

  Widget confirmedListViewItem(int index) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: Icon(
              Icons.notifications,
              size: 25,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "25/03/2024 | 13:40:00 PM | Falta de energia | Fazenda da Bahia | Jonas",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget unconfirmedListViewItem(int index) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: Icon(
              Icons.notifications,
              size: 25,
              color: const Color.fromARGB(255, 189, 30, 30),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "25/03/2024 | 13:40:00 PM | Falta de energia | Fazenda da Bahia",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

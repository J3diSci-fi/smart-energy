import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TestPage(),
  ));
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Data> dataList = [
    Data(name: "Demo name", date: DateTime.now(), description: "Dummy long description",
        imageURL: 'https://m.files.bbci.co.uk/modules/bbc-morph-sport-seo-meta/1.20.8/images/bbc-sport-logo.png'),
    Data(name: "Demo name", date: DateTime.now(), description: "Dummy long description",
        imageURL: 'https://m.files.bbci.co.uk/modules/bbc-morph-sport-seo-meta/1.20.8/images/bbc-sport-logo.png'),
    Data(name: "Demo name", date: DateTime.now(), description: "Dummy long description",
        imageURL: 'https://m.files.bbci.co.uk/modules/bbc-morph-sport-seo-meta/1.20.8/images/bbc-sport-logo.png'),
    Data(name: "Demo name", date: DateTime.now(), description: "Dummy long description",
        imageURL: 'https://m.files.bbci.co.uk/modules/bbc-morph-sport-seo-meta/1.20.8/images/bbc-sport-logo.png'),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: dataList.map((data) {
            return Container(
              width: width,
              height: 80,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1.5, color: Colors.black))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(data.imageURL))),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(data.name),
                      Expanded(child: Text(data.description)),
                    ],
                  ),
                  Text(data.date.toString()),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Data {
  String name;
  String imageURL;
  String description;
  DateTime date;

  Data({required this.name, required this.imageURL, required this.date, required this.description});
}

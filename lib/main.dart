import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=629fdb24";

/*
theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      )),
));
 */

void main() async {
  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.green[900],
      primaryColor: Colors.green,
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshop) {
          switch (snapshop.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green[900],
                    fontSize: 30.0,
                  ),
                ),
              );
            default:
              if (snapshop.hasError) {
                return Center(
                  child: Text(
                    "OCORREU UM ERRO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 30.0,
                    ),
                  ),
                );
              }

              dolar = snapshop.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshop.data["results"]["currencies"]["EUR"]["buy"];

              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 150.0,
                      color: Colors.green[900],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Reais",
                        labelStyle: TextStyle(color: Colors.green[900], fontSize: 20.0),
                        border: OutlineInputBorder(),
                        prefixText: "R\$",
                      ),
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Dolares",
                        labelStyle: TextStyle(color: Colors.green[900], fontSize: 20.0),
                        border: OutlineInputBorder(),
                        prefixText: "US\$",
                      ),
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Euros",
                        labelStyle: TextStyle(color: Colors.green[900], fontSize: 20.0),
                        border: OutlineInputBorder(),
                        prefixText: "€",
                      ),
                    )
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

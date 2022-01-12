import 'dart:convert';
import 'dart:ui';

import 'package:conversor_moeda/util/api.dart';
import 'package:flutter/material.dart';
import 'controller/conversor.dart' as conversor;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moeda',
      theme: ThemeData.dark(),
      darkTheme: ThemeData(primaryColor: Colors.white, hintColor: Colors.amber),
      themeMode: ThemeMode.system,
      color: Colors.yellow,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: '\$ Conversor de Moeda \$'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controllerReal = TextEditingController();
  late TextEditingController _controllerUSD = TextEditingController();
  late TextEditingController _controllerEUR = TextEditingController();
  double dolar = 0.0;
  double euro = 0.0;
  Divider divider = const Divider(
    height: 20,
    color: Colors.transparent,
  );
  //var getData;

  void _clearAll() {
    _controllerReal.text = "";
    _controllerUSD.text = "";
    _controllerEUR.text = "";
  }

  _realChanged(String value) {
    if (value.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(value);
    _controllerUSD.text = (real / dolar).toStringAsFixed(2);
    _controllerEUR.text = (real / euro).toStringAsFixed(2);
  }

  _dolarChanged(String value) {
    if (value.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(value);
    _controllerReal.text = (dolar * this.dolar).toStringAsFixed(2);
    _controllerEUR.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  _euroChanged(String value) {
    if (value.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(value);
    _controllerReal.text = (euro * this.euro).toStringAsFixed(2);
    _controllerUSD.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  Future _getData() async {
    //return conversor.GetData();
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/db/finance.json");
    final jsonResult = json.decode(data);
    return jsonResult;
  }

  @override
  Widget build(BuildContext context) {
    _getData();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
            euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
            children = <Widget>[
              const Icon(
                Icons.monetization_on,
                color: Colors.amber,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'USD: ${dolar.toStringAsPrecision(4)}',
                          ),
                          Text(
                            'EUR: ${euro.toStringAsPrecision(4)}',
                          ),
                        ],
                      ),
                      divider,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              buildTextField(
                                'Real',
                                "R\$ ",
                                _controllerReal,
                                _realChanged,
                              ),
                              divider,
                              buildTextField(
                                'Dolar',
                                "US\$ ",
                                _controllerUSD,
                                _dolarChanged,
                              ),
                              divider,
                              buildTextField(
                                'Euro',
                                "Є ",
                                _controllerEUR,
                                _euroChanged,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Carregando...'),
              )
            ];
          }
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildTextField(
    label, prefix, TextEditingController controll, Function f) {
  return TextField(
    controller: controll,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.amber),
      errorStyle: const TextStyle(
        fontStyle: FontStyle.normal,
        color: Colors.redAccent,
      ),
      prefixText: prefix,
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.amber),
      ),
    ),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    onChanged: (value) {
      f(value);
    },
  );
}

import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calcular IMC',
      theme: ThemeData(
          primaryColor: Colors.white, errorColor: Colors.red.shade300),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String _title = 'Calcular IMC';
//Controller referencies
  final TextEditingController _controllerPeso = TextEditingController();
  final TextEditingController _controllerAltura = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Style  ElevatedButton
  final ButtonStyle style = ElevatedButton.styleFrom(primary: Colors.green);
  String _infoText = "Informe seus Dados";

  void _resetField() {
    setState(() {
      _controllerPeso.text = "";
      _controllerAltura.text = "";
      _infoText = "Informe seus Dados";
    });
  }

  void _calcularImc() {
    setState(() {
      double peso = double.parse(_controllerPeso.text);
      double altura = double.parse(_controllerAltura.text) / 100;
      double imc = peso / (altura * altura);
      if (imc < 18.6) {
        _infoText = "Abaixo do peso\n (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "Pesso ideal\n (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "Levemente acima do peso\n (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau I\n (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc > 39.9) {
        _infoText = "Obesidade Grau II\n (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        _infoText = "Obesidade Grau III\n (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text(_title)),
          actions: [
            IconButton(
                onPressed: _resetField,
                icon: const Icon(Icons.refresh, color: Colors.green))
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: Icon(Icons.person_outline,
                        size: 100.0, color: Colors.green),
                  ),
                  TextFormField(
                    controller: _controllerPeso,
                    decoration: const InputDecoration(
                        hintText: 'Peso(kg)*',
                        labelText: 'Peso(kg)*',
                        errorStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.redAccent)),
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o valor do peso(kg)';
                      }
                      return null;
                    },
                  ),
                  const Divider(height: 20, color: Colors.transparent),
                  TextFormField(
                    controller: _controllerAltura,
                    decoration: const InputDecoration(
                        hintText: 'Altura(cm)',
                        labelText: 'Altura(cm)',
                        errorStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.redAccent)),
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o valor do  altura(cm)';
                      }
                      return null;
                    },
                  ),
                  const Divider(height: 20, color: Colors.transparent),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      height: 30.0,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                          if (_formKey.currentState!.validate() == true) {
                            _calcularImc();
                          }
                        },
                        style: style,
                        child: const Text('Calcular'),
                      ),
                    ),
                  ),
                  const Divider(height: 15, color: Colors.transparent),
                  Center(
                    child: Text(
                      _infoText,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

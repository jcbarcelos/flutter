import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _todoControllerNota = TextEditingController();
  final _todoControllerQtde = TextEditingController();
  List _todoList = [];
  late Map<String, dynamic> _listRemove;
  late int _lastRemovePost;
  late int _totalQtde = 0;
  late int _totalValor = 0;
  @override
  void initState() {
    super.initState();
    _readData().then((value) => {
          setState(() {
            _todoList = json.decode(value);
          })
        });
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> _newTodo = Map();
      _newTodo["title"] = _todoControllerNota.text;
      _newTodo["qtde"] = _todoControllerQtde.text;
      _todoControllerNota.text = "";
      _todoControllerQtde.text = "";
      _newTodo["ok"] = false;
      _todoList.add(_newTodo);
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
      _saveData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          controller: _todoControllerNota,
                          decoration: const InputDecoration(
                            labelText: "Nova Tarefa",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width / 4,
                        child: TextField(
                          controller: _todoControllerQtde,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Qtde",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _addTodo,
                  iconSize: 40,
                  splashColor: Colors.blueAccent,
                  icon: const Icon(Icons.add_circle_rounded),
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
          const Divider(height: 8, color: Colors.transparent),
          Expanded(
              child: RefreshIndicator(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10.0),
              itemCount: _todoList.length,
              itemBuilder: buildItem,
            ),
            onRefresh: _refresh,
          ))
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}?/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return "";
    }
  }

  Widget buildItem(context, index) {
    return Dismissible(
      background: Container(
        color: Colors.redAccent,
        child: const Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(Icons.delete, color: Colors.white)),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      child: Lista(context, index),
      onDismissed: (direction) {
        setState(() {
          _listRemove = Map.from(_todoList[index]);
          _lastRemovePost = index;
          _todoList.removeAt(index);
          _saveData();
          final snackbar = SnackBar(
            backgroundColor: Color.lerp(Colors.black, Colors.black, 0),
            content: Text("Tarefa ${_listRemove["title"]} removida!",
                style: TextStyle(color: Colors.white)),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovePost, _listRemove);
                  _saveData();
                });
              },
            ),
            duration: const Duration(seconds: 5),
          );
          Scaffold.of(context).showSnackBar(snackbar);
        });
      },
    );
  }

  Widget Lista(context, index) {
    return CheckboxListTile(
      title: Text(
        _todoList[index]?["title"],
        style: TextStyle(
          decoration: _todoList[index]?["ok"]
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: _todoList[index]?["ok"] ? Colors.redAccent : Colors.white,
        ),
      ),
      subtitle: Text(
        "Quantidade:  ${_todoList[index]?["qtde"]}",
        style: TextStyle(
          decoration: _todoList[index]?["ok"]
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: _todoList[index]?["ok"] ? Colors.redAccent : Colors.white,
        ),
      ),
      value: _todoList[index]?["ok"],
      secondary: CircleAvatar(
        backgroundColor:
            _todoList[index]?["ok"] ? Colors.redAccent : Colors.blueAccent,
        child: Icon(
          _todoList[index]?["ok"]
              ? Icons.shopping_cart_rounded
              : Icons.shopping_bag_outlined,
          color: Colors.white,
        ),
      ),
      activeColor: _todoList[index]?["ok"] ? Colors.redAccent : Colors.white,
      onChanged: (bool? newTodo) {
        setState(() {
          _todoList[index]["ok"] = newTodo;
          _saveData();
          _refresh();
        });
      },
    );
  }
}

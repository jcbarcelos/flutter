import 'package:flutter/material.dart';
import 'package:lista_tarefas/Home.dart';
import 'package:lista_tarefas/Widgets/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}

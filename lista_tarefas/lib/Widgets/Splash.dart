import 'package:flutter/material.dart';
import 'package:lista_tarefas/Home.dart';

void main() => runApp(const Splash());

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  static const String _title = 'Lista de Tarefas';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5)).then((value) => {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Home()))
        });
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              'Lista de tarefa',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const Divider(
            height: 16.0,
            endIndent: 10.0,
            color: Colors.transparent,
          ),
          Center(
            child: CircularProgressIndicator(
              value: controller.value,
              semanticsLabel: 'Linear progress indicator',
            ),
          ),
        ],
      ),
    );
  }
}

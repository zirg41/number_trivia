import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empty app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(body: Center(child: Text("Empty page"))),
    );
  }
}
